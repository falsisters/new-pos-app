import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';

class FormulaHandler {
  final SheetModel sheet;

  FormulaHandler({required this.sheet});

  // Column name to index mapping
  Map<String, int> get _columnNameMap => {
        'Quantity': 0,
        'Name': 1,
        // Add any other custom column names here
      };

  // Convert column letter to index
  int _getColumnIndexFromLetter(String letter) {
    if (_columnNameMap.containsKey(letter)) {
      return _columnNameMap[letter]!;
    }

    // Handle Excel-style column letters (A=0, B=1, ...)
    int result = 0;
    for (int i = 0; i < letter.length; i++) {
      result *= 26;
      result += letter.codeUnitAt(i) - 'A'.codeUnitAt(0) + 1;
    }
    return result + 1; // Adding offset for Quantity and Name columns
  }

  // Extracts cell references from a formula
  Set<String> extractCellReferencesFromFormula(String formula) {
    Set<String> references = {};

    // Remove the leading equals sign
    if (formula.startsWith('=')) {
      formula = formula.substring(1).trim();
    }

    // Pattern to match a cell reference like A1, B2, AA34, or named columns like Quantity1, Name2
    // This regex matches:
    // - Column letters (A-Z, AA-ZZ, etc.) or named columns (Quantity, Name)
    // - Followed by one or more digits
    RegExp cellReferencePattern = RegExp(r'([A-Za-z]+)(\d+)');

    // Find all matches
    Iterable<RegExpMatch> matches = cellReferencePattern.allMatches(formula);

    for (RegExpMatch match in matches) {
      String columnRef = match.group(1)!;
      String rowRef = match.group(2)!;

      try {
        int rowIndex = int.parse(rowRef);

        // Store both as row_col key and as named reference
        String rowColKey =
            '${rowIndex}_${_getColumnIndexFromColumnRef(columnRef)}';
        String namedRef = '$columnRef$rowIndex';

        references.add(rowColKey);
        references.add(namedRef);
      } catch (e) {
        print('Error parsing cell reference: $e');
      }
    }

    // Also look for range references like SUM(A1:A10)
    RegExp rangePattern = RegExp(r'([A-Za-z]+)(\d+):([A-Za-z]+)(\d+)');
    matches = rangePattern.allMatches(formula);

    for (RegExpMatch match in matches) {
      String startCol = match.group(1)!;
      int startRow = int.parse(match.group(2)!);
      String endCol = match.group(3)!;
      int endRow = int.parse(match.group(4)!);

      int startColIndex = _getColumnIndexFromColumnRef(startCol);
      int endColIndex = _getColumnIndexFromColumnRef(endCol);

      // Add all cells in the range
      for (int row = startRow; row <= endRow; row++) {
        for (int col = startColIndex; col <= endColIndex; col++) {
          // Store both formats: row_col and named reference
          String rowColKey = '${row}_$col';
          String namedRef = '$startCol$row';
          references.add(rowColKey);
          references.add(namedRef);
        }
      }
    }

    return references;
  }

  // Helper method to get column index from name or letter
  int _getColumnIndexFromColumnRef(String columnRef) {
    if (_columnNameMap.containsKey(columnRef)) {
      return _columnNameMap[columnRef]!;
    }

    // Convert letter to index (A=0, B=1, AA=26, etc.)
    return _getColumnIndexFromLetter(columnRef);
  }

  String evaluateFormula(
      String formula, int currentRowIndex, int currentColumnIndex) {
    if (!formula.startsWith('=')) {
      return formula;
    }

    try {
      // Remove the equals sign at the beginning
      String expression = formula.substring(1).trim();

      // Process range functions like SUM, AVG, etc.
      expression = _processRangeFunctions(
          expression, currentRowIndex, currentColumnIndex);

      // Replace cell references with their values
      expression = _replaceCellReferences(
          expression, currentRowIndex, currentColumnIndex);

      // Evaluate the mathematical expression
      double result = _evaluateExpression(expression);

      // Round down the result
      result = result.floorToDouble();

      // Format the result - show whole number if it's an integer
      if (result == result.roundToDouble()) {
        return result.toInt().toString();
      }
      return result.toStringAsFixed(2);
    } catch (e) {
      print("Formula error: $e in formula: $formula");
      return "#ERROR";
    }
  }

  // Replace cell references (like A1, B2) with their actual values
  String _replaceCellReferences(
      String expression, int currentRowIndex, int currentColumnIndex) {
    // Pattern to match cell references like A1, B2, AA34
    RegExp cellRefPattern = RegExp(r'([A-Za-z]+)(\d+)');

    return expression.replaceAllMapped(cellRefPattern, (match) {
      String columnRef = match.group(1)!;
      String rowRef = match.group(2)!;

      try {
        int targetRowIndex = int.parse(rowRef);
        int targetColumnIndex = _getColumnIndexFromColumnRef(columnRef);

        // Get the cell value
        String cellValue = _getCellValue(targetRowIndex, targetColumnIndex);

        // If the cell value is empty or non-numeric, use 0
        if (cellValue.isEmpty) return '0';

        try {
          // Try to parse as number
          double.parse(cellValue);
          return cellValue;
        } catch (_) {
          // If not numeric, return 0
          return '0';
        }
      } catch (_) {
        return '0';
      }
    });
  }

  // Process range functions like SUM(A1:A5), AVG(B1:B10), etc.
  String _processRangeFunctions(
      String expression, int currentRowIndex, int currentColumnIndex) {
    // Match patterns like SUM(A1:A5), AVG(B1:B10), COUNT(C1:C20)
    RegExp rangePattern =
        RegExp(r'(SUM|AVG|COUNT|MAX|MIN)\(([A-Za-z]+)(\d+):([A-Za-z]+)(\d+)\)');

    return expression.replaceAllMapped(rangePattern, (match) {
      String function = match.group(1)!.toUpperCase();
      String startColRef = match.group(2)!;
      int startRowIndex = int.parse(match.group(3)!);
      String endColRef = match.group(4)!;
      int endRowIndex = int.parse(match.group(5)!);

      int startColIndex = _getColumnIndexFromColumnRef(startColRef);
      int endColIndex = _getColumnIndexFromColumnRef(endColRef);

      // Calculate result based on function type
      double result = 0;
      int count = 0;
      List<double> values = [];

      // Collect values in the range
      for (int rowIdx = startRowIndex; rowIdx <= endRowIndex; rowIdx++) {
        for (int colIdx = startColIndex; colIdx <= endColIndex; colIdx++) {
          String cellValue = _getCellValue(rowIdx, colIdx);
          if (cellValue.isNotEmpty) {
            try {
              double numValue = double.parse(cellValue);
              values.add(numValue);
              count++;
            } catch (_) {
              // Skip non-numeric values
            }
          }
        }
      }

      // Calculate based on function
      switch (function) {
        case 'SUM':
          result = values.fold(0, (sum, val) => sum + val);
          break;
        case 'AVG':
          if (count > 0) {
            result = values.fold(0.0, (sum, val) => sum + val) / count;
          }
          break;
        case 'COUNT':
          result = count.toDouble();
          break;
        case 'MAX':
          if (values.isNotEmpty) {
            result = values.reduce((max, val) => max > val ? max : val);
          }
          break;
        case 'MIN':
          if (values.isNotEmpty) {
            result = values.reduce((min, val) => min < val ? min : val);
          }
          break;
      }

      return result.toString();
    });
  }

  // Get cell value from the sheet
  String _getCellValue(int rowIndex, int columnIndex) {
    try {
      var rowModel = sheet.rows.firstWhereOrNull(
        (row) => row.rowIndex == rowIndex,
      );

      if (rowModel == null) return '';

      var cellModel = rowModel.cells.firstWhereOrNull(
        (cell) => cell.columnIndex == columnIndex,
      );

      return cellModel?.value ?? '';
    } catch (e) {
      print('Error getting cell value: $e');
      return '';
    }
  }

  // Check if a cell contains a formula
  bool isCellFormula(int rowIndex, int columnIndex) {
    try {
      var rowModel = sheet.rows.firstWhereOrNull(
        (row) => row.rowIndex == rowIndex,
      );

      if (rowModel == null) return false;

      var cellModel = rowModel.cells.firstWhereOrNull(
        (cell) => cell.columnIndex == columnIndex,
      );

      if (cellModel == null) return false;

      return cellModel.formula != null && cellModel.formula!.startsWith('=');
    } catch (e) {
      print('Error checking if cell is formula: $e');
      return false;
    }
  }

  // Get all formula cells in the sheet
  List<Map<String, dynamic>> getAllFormulaCells() {
    List<Map<String, dynamic>> formulaCells = [];

    try {
      for (var row in sheet.rows) {
        for (var cell in row.cells) {
          if (cell.formula != null && cell.formula!.startsWith('=')) {
            formulaCells.add({
              'rowIndex': row.rowIndex,
              'columnIndex': cell.columnIndex,
              'formula': cell.formula,
              'cellId': cell.id,
              'rowId': row.id,
            });
          }
        }
      }
    } catch (e) {
      print('Error getting all formula cells: $e');
    }

    return formulaCells;
  }

  // Evaluate a mathematical expression
  double _evaluateExpression(String expression) {
    // Handle basic arithmetic
    expression = expression.replaceAll(' ', ''); // Remove all spaces

    // Parse and evaluate the expression
    return _parseExpression(expression);
  }

  // Simple expression parser for basic mathematical operations
  double _parseExpression(String expression) {
    // First check for addition and subtraction
    int lastAddSubtractIndex = -1;
    int parenthesesLevel = 0;

    for (int i = expression.length - 1; i >= 0; i--) {
      if (expression[i] == ')') parenthesesLevel++;
      if (expression[i] == '(') parenthesesLevel--;

      if (parenthesesLevel == 0) {
        if (expression[i] == '+' ||
            (expression[i] == '-' &&
                i > 0 &&
                !_isOperator(expression[i - 1]))) {
          lastAddSubtractIndex = i;
          break;
        }
      }
    }

    if (lastAddSubtractIndex != -1) {
      String leftPart = expression.substring(0, lastAddSubtractIndex);
      String rightPart = expression.substring(lastAddSubtractIndex + 1);
      if (expression[lastAddSubtractIndex] == '+') {
        return _parseExpression(leftPart) + _parseExpression(rightPart);
      } else {
        return _parseExpression(leftPart) - _parseExpression(rightPart);
      }
    }

    // Then check for multiplication and division
    int lastMultDivIndex = -1;
    parenthesesLevel = 0;

    for (int i = expression.length - 1; i >= 0; i--) {
      if (expression[i] == ')') parenthesesLevel++;
      if (expression[i] == '(') parenthesesLevel--;

      if (parenthesesLevel == 0) {
        if (expression[i] == '*' || expression[i] == '/') {
          lastMultDivIndex = i;
          break;
        }
      }
    }

    if (lastMultDivIndex != -1) {
      String leftPart = expression.substring(0, lastMultDivIndex);
      String rightPart = expression.substring(lastMultDivIndex + 1);
      if (expression[lastMultDivIndex] == '*') {
        return _parseExpression(leftPart) * _parseExpression(rightPart);
      } else {
        return _parseExpression(leftPart) / _parseExpression(rightPart);
      }
    }

    // Check for exponentiation (^)
    int expIndex = expression.indexOf('^');
    if (expIndex != -1) {
      String base = expression.substring(0, expIndex);
      String exponent = expression.substring(expIndex + 1);
      return _pow(_parseExpression(base), _parseExpression(exponent));
    }

    // Handle parentheses
    if (expression.startsWith('(') && expression.endsWith(')')) {
      return _parseExpression(expression.substring(1, expression.length - 1));
    }

    // Finally, try to parse the expression as a number
    try {
      return double.parse(expression);
    } catch (e) {
      print('Error parsing number: $expression');
      return 0;
    }
  }

  // Custom pow function
  double _pow(double base, double exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  bool _isOperator(String char) {
    return char == '+' ||
        char == '-' ||
        char == '*' ||
        char == '/' ||
        char == '^';
  }
}
