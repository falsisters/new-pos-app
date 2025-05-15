import 'package:falsisters_pos_android/features/inventory/data/models/inventory_cell_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_row_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_reference.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';
import 'package:math_expressions/math_expressions.dart';

class InventoryFormulaHandler {
  final InventorySheetModel sheet;
  final Map<String, String> _columnMap = {};
  final Map<String, int> _columnIndexMap = {};

  InventoryFormulaHandler({required this.sheet}) {
    _initializeColumnMaps();
  }

  void _initializeColumnMaps() {
    // Initialize column mapping (letter to index and vice versa)
    for (int i = 0; i < sheet.columns; i++) {
      String columnLetter = _getColumnLetter(i);
      _columnMap[i.toString()] = columnLetter;
      _columnIndexMap[columnLetter.toUpperCase()] = i;
    }
  }

  String _getColumnLetter(int index) {
    // Use Excel-like column letters (A, B, C, etc.)
    String columnLetter = '';
    int tempIndex = index;

    while (tempIndex >= 0) {
      columnLetter = String.fromCharCode((tempIndex % 26) + 65) + columnLetter;
      tempIndex = (tempIndex ~/ 26) - 1;
    }
    return columnLetter;
  }

  // Improved function to convert column letter to index
  int? _getColumnIndexFromLetter(String columnLetter) {
    // Handle uppercase and lowercase letters
    columnLetter = columnLetter.toUpperCase();

    // Check if it's a named column
    if (_columnIndexMap.containsKey(columnLetter)) {
      return _columnIndexMap[columnLetter];
    }

    // Handle Excel-style column letters (A=0, B=1, AA=26, etc.)
    int result = 0;
    for (int i = 0; i < columnLetter.length; i++) {
      int charValue = columnLetter.codeUnitAt(i) - 'A'.codeUnitAt(0);
      if (charValue < 0 || charValue > 25) {
        // Invalid character in column name
        return null;
      }
      result = result * 26 + charValue + 1;
    }
    return result - 1; // Convert to 0-based index
  }

  // Extracts cell references from a formula for dependency tracking
  Set<String> extractCellReferencesFromFormula(String formula) {
    Set<String> references = {};

    // Remove the leading equals sign
    if (formula.startsWith('=')) {
      formula = formula.substring(1).trim();
    }

    // Pattern to match a cell reference like A1, B2, AA34
    RegExp cellReferencePattern = RegExp(r'([A-Za-z]+)(\d+)');

    // Find all matches
    Iterable<RegExpMatch> matches = cellReferencePattern.allMatches(formula);

    for (RegExpMatch match in matches) {
      String columnRef = match.group(1)!;
      String rowRef = match.group(2)!;

      try {
        int rowIndex = int.parse(rowRef);

        // Get column index if available
        int? columnIndex;
        if (_columnIndexMap.containsKey(columnRef.toUpperCase())) {
          columnIndex = _columnIndexMap[columnRef.toUpperCase()];
        } else {
          // Try to parse column letter to index directly
          columnIndex = _getColumnIndexFromLetter(columnRef);
        }

        // Store references if we could determine the column index
        if (columnIndex != null) {
          String rowColKey = '${rowIndex}_${columnIndex}';
          String namedRef = '$columnRef$rowIndex';

          references.add(rowColKey);
          references.add(namedRef);

          // Print for debugging
          print('Formula dependency found: $rowColKey ($namedRef)');
        }
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

      int? startColIndex, endColIndex;

      if (_columnIndexMap.containsKey(startCol.toUpperCase())) {
        startColIndex = _columnIndexMap[startCol.toUpperCase()];
      } else {
        startColIndex = _getColumnIndexFromLetter(startCol);
      }

      if (_columnIndexMap.containsKey(endCol.toUpperCase())) {
        endColIndex = _columnIndexMap[endCol.toUpperCase()];
      } else {
        endColIndex = _getColumnIndexFromLetter(endCol);
      }

      if (startColIndex != null && endColIndex != null) {
        // Add all cells in the range
        for (int row = startRow; row <= endRow; row++) {
          for (int col = startColIndex; col <= endColIndex; col++) {
            String rowColKey = '${row}_$col';
            String colLetter = _getColumnLetter(col);
            String namedRef = '$colLetter$row';
            references.add(rowColKey);
            references.add(namedRef);
          }
        }
      }
    }

    return references;
  }

  // Main method to evaluate formulas
  String evaluateFormula(
      String formula, int currentRowIndex, int currentColumnIndex) {
    if (!formula.startsWith('=')) {
      return formula;
    }

    try {
      String processedFormula = formula.substring(1); // Remove the '=' sign

      // Process range functions first (SUM, AVG, etc.)
      processedFormula = _processRangeFunctions(processedFormula);

      // Process cell references (A1, B2, etc.)
      processedFormula =
          _processCellReferences(processedFormula, currentRowIndex);

      // Evaluate the processed formula using math_expressions
      Parser p = Parser();
      Expression exp = p.parse(processedFormula);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      // Format the result: if it's an integer equivalent (e.g. 15.0), show as "15".
      // Otherwise, show with two decimal places (e.g. "15.25").
      if (result == result.truncateToDouble()) {
        // Check if the number has no fractional part
        return result.toInt().toString();
      } else {
        return result
            .toStringAsFixed(2); // Preserve two decimal places for non-integers
      }
    } catch (e) {
      print('Formula evaluation error: $e');
      return '#ERROR';
    }
  }

  // Process range functions like SUM, AVG, COUNT, MAX, MIN
  String _processRangeFunctions(String formula) {
    RegExp rangePattern =
        RegExp(r'(SUM|AVG|COUNT|MAX|MIN)\(([A-Za-z0-9]+):([A-Za-z0-9]+)\)');

    return formula.replaceAllMapped(rangePattern, (match) {
      String function = match.group(1)!.toUpperCase();
      String startRef = match.group(2)!;
      String endRef = match.group(3)!;

      try {
        CellReference startCell = _parseCellReference(startRef);
        CellReference endCell = _parseCellReference(endRef);

        if (startCell.columnIndex != endCell.columnIndex) {
          throw Exception('Range must be in the same column');
        }

        List<double> values = _getValuesInRange(
            startCell.columnIndex, startCell.rowIndex, endCell.rowIndex);

        switch (function) {
          case 'SUM':
            return values.fold(0.0, (a, b) => a + b).toString();
          case 'AVG':
            if (values.isEmpty) return '0';
            return (values.fold(0.0, (a, b) => a + b) / values.length)
                .toString();
          case 'COUNT':
            return values.length.toString();
          case 'MAX':
            if (values.isEmpty) return '0';
            return values.reduce((a, b) => a > b ? a : b).toString();
          case 'MIN':
            if (values.isEmpty) return '0';
            return values.reduce((a, b) => a < b ? a : b).toString();
          default:
            return '0';
        }
      } catch (e) {
        print('Error processing range function: $e');
        return '0';
      }
    });
  }

  // Get values from cells in a specific range
  List<double> _getValuesInRange(
      int columnIndex, int startRowIndex, int endRowIndex) {
    List<double> values = [];

    int start = startRowIndex < endRowIndex ? startRowIndex : endRowIndex;
    int end = startRowIndex > endRowIndex ? startRowIndex : endRowIndex;

    for (int rowIndex = start; rowIndex <= end; rowIndex++) {
      try {
        InventoryRowModel? row =
            sheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
        if (row == null) continue;

        InventoryCellModel? cell =
            row.cells.firstWhereOrNull((c) => c.columnIndex == columnIndex);
        if (cell == null || cell.value == null || cell.value!.isEmpty) continue;

        double? value = double.tryParse(cell.value!);
        if (value != null) {
          values.add(value);
        }
      } catch (e) {
        print('Error getting value from cell: $e');
      }
    }

    return values;
  }

  // Process individual cell references like A1, B2, etc.
  String _processCellReferences(String formula, int currentRowIndex) {
    RegExp cellPattern = RegExp(r'([A-Za-z]+)([0-9]+)');

    return formula.replaceAllMapped(cellPattern, (match) {
      String column = match.group(1)!;
      int rowIndex = int.parse(match.group(2)!);

      try {
        if (!_columnIndexMap.containsKey(column.toUpperCase())) {
          throw Exception('Invalid column reference: $column');
        }

        int columnIndex = _columnIndexMap[column.toUpperCase()]!;

        InventoryRowModel? row =
            sheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
        if (row == null) {
          return '0';
        }

        InventoryCellModel? cell =
            row.cells.firstWhereOrNull((c) => c.columnIndex == columnIndex);
        if (cell == null || cell.value == null || cell.value!.isEmpty) {
          return '0';
        }

        double? value = double.tryParse(cell.value!);
        if (value == null) {
          return '0';
        }

        return value.toString();
      } catch (e) {
        print('Error processing cell reference: $e');
        return '0';
      }
    });
  }

  // Parse a cell reference (like A1) into column index and row index
  CellReference _parseCellReference(String reference) {
    RegExp cellPattern = RegExp(r'([A-Za-z]+)([0-9]+)');
    Match? match = cellPattern.firstMatch(reference);

    if (match == null) {
      throw Exception('Invalid cell reference: $reference');
    }

    String column = match.group(1)!;
    int rowIndex = int.parse(match.group(2)!);

    if (!_columnIndexMap.containsKey(column.toUpperCase())) {
      throw Exception('Invalid column reference: $column');
    }

    int columnIndex = _columnIndexMap[column.toUpperCase()]!;

    return CellReference(columnIndex, rowIndex);
  }
}
