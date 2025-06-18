import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';
import 'package:math_expressions/math_expressions.dart';

class FormulaHandler {
  final SheetModel sheet;
  final Map<String, int> _columnIndexMap = {};

  // Enhanced error handling cache
  final Map<String, String> _evaluationCache = {};
  final Set<String> _circularReferenceCheck = {};

  FormulaHandler({required this.sheet}) {
    _initializeColumnMaps();
  }

  void _initializeColumnMaps() {
    // Initialize column mapping to match the UI's _getColumnLetter method
    _columnIndexMap['QUANTITY'] = 0;
    _columnIndexMap['NAME'] = 1;

    // For standard Excel letters starting from index 2
    // UI: index 2→"A", index 3→"B", index 4→"C", etc.
    for (int i = 2; i < sheet.columns; i++) {
      String columnLetter = _getColumnLetter(i);
      _columnIndexMap[columnLetter.toUpperCase()] = i;
    }
  }

  String _getColumnLetter(int index) {
    // Must match the UI's _getColumnLetter method exactly
    if (index == 0) return "QUANTITY";
    if (index == 1) return "NAME";

    String columnLetter = '';
    int adjustedIndex =
        index - 2; // Adjust index to start from 0 after our custom columns
    while (adjustedIndex >= 0) {
      columnLetter =
          String.fromCharCode((adjustedIndex % 26) + 65) + columnLetter;
      adjustedIndex = (adjustedIndex ~/ 26) - 1;
    }
    return columnLetter;
  }

  // Extracts cell references from a formula for dependency tracking
  Set<String> extractCellReferencesFromFormula(String formula) {
    Set<String> references = {};

    // Remove the leading equals sign
    if (formula.startsWith('=')) {
      formula = formula.substring(1).trim();
    }

    // Pattern to match a cell reference like A1, B2, AA34, Quantity1, Name2
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
      }

      if (_columnIndexMap.containsKey(endCol.toUpperCase())) {
        endColIndex = _columnIndexMap[endCol.toUpperCase()];
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

  // Main method to evaluate formulas with enhanced error handling
  String evaluateFormula(
      String formula, int currentRowIndex, int currentColumnIndex) {
    if (!formula.startsWith('=')) {
      return formula;
    }

    // Create cache key
    final cacheKey = '${formula}_${currentRowIndex}_$currentColumnIndex';

    // Check cache first for performance
    if (_evaluationCache.containsKey(cacheKey)) {
      return _evaluationCache[cacheKey]!;
    }

    // Check for circular references
    if (_circularReferenceCheck.contains(cacheKey)) {
      print('Circular reference detected: $formula');
      return '#CIRCULAR';
    }

    _circularReferenceCheck.add(cacheKey);

    try {
      String processedFormula =
          formula.substring(1).trim(); // Remove the '=' sign

      // Validate formula isn't empty
      if (processedFormula.isEmpty) {
        throw Exception('Empty formula');
      }

      // Process range functions first with error handling
      try {
        processedFormula = _processRangeFunctions(processedFormula);
      } catch (e) {
        print('Error processing range functions: $e');
        throw Exception('Range function error: ${e.toString()}');
      }

      // Process cell references with error handling
      try {
        processedFormula =
            _processCellReferences(processedFormula, currentRowIndex);
      } catch (e) {
        print('Error processing cell references: $e');
        throw Exception('Cell reference error: ${e.toString()}');
      }

      // Validate processed formula
      if (processedFormula.isEmpty || processedFormula.trim().isEmpty) {
        throw Exception('Formula resulted in empty expression');
      }

      // Evaluate the processed formula using math_expressions with timeout
      String result = _evaluateWithTimeout(processedFormula);

      // Cache the result
      _evaluationCache[cacheKey] = result;

      return result;
    } catch (e) {
      print('Error evaluating formula "$formula": $e');
      final errorResult = '#ERROR: ${e.toString().split(':').last.trim()}';
      _evaluationCache[cacheKey] = errorResult;
      return errorResult;
    } finally {
      _circularReferenceCheck.remove(cacheKey);
    }
  }

  // Direct evaluation without caching for quick formulas
  String evaluateFormulaDirectly(
      String formula, int currentRowIndex, int currentColumnIndex) {
    if (!formula.startsWith('=')) {
      return formula;
    }

    try {
      String processedFormula =
          formula.substring(1).trim(); // Remove the '=' sign

      // Validate formula isn't empty
      if (processedFormula.isEmpty) {
        throw Exception('Empty formula');
      }

      // Process range functions first with error handling
      try {
        processedFormula = _processRangeFunctions(processedFormula);
      } catch (e) {
        print('Error processing range functions: $e');
        throw Exception('Range function error: ${e.toString()}');
      }

      // Process cell references with error handling
      try {
        processedFormula =
            _processCellReferences(processedFormula, currentRowIndex);
      } catch (e) {
        print('Error processing cell references: $e');
        throw Exception('Cell reference error: ${e.toString()}');
      }

      // Validate processed formula
      if (processedFormula.isEmpty || processedFormula.trim().isEmpty) {
        throw Exception('Formula resulted in empty expression');
      }

      // Evaluate the processed formula using math_expressions with timeout
      String result = _evaluateWithTimeout(processedFormula);

      return result;
    } catch (e) {
      print('Error evaluating formula directly "$formula": $e');
      return '#ERROR: ${e.toString().split(':').last.trim()}';
    }
  }

  String _evaluateWithTimeout(String processedFormula) {
    try {
      // Add timeout to prevent long-running calculations
      Parser p = Parser();
      Expression exp = p.parse(processedFormula);
      ContextModel cm = ContextModel();

      // Simple timeout simulation - if the formula is too complex, it might hang
      final stopwatch = Stopwatch()..start();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      stopwatch.stop();

      if (stopwatch.elapsedMilliseconds > 1000) {
        print(
            'Warning: Formula evaluation took ${stopwatch.elapsedMilliseconds}ms');
      }

      // Validate result
      if (result.isNaN || result.isInfinite) {
        throw Exception('Invalid calculation result');
      }

      // Truncate decimal values (round down)
      return result.floor().toString();
    } catch (e) {
      throw Exception('Math evaluation failed: ${e.toString()}');
    }
  }

  // Enhanced range function processing with better error handling
  String _processRangeFunctions(String formula) {
    RegExp rangePattern =
        RegExp(r'(SUM|AVG|COUNT|MAX|MIN)\(([A-Za-z]+)(\d+):([A-Za-z]+)(\d+)\)');

    return formula.replaceAllMapped(rangePattern, (match) {
      try {
        String function = match.group(1)!.toUpperCase();
        String startRef = match.group(2)! + match.group(3)!;
        String endRef = match.group(4)! + match.group(5)!;

        CellReference startCell = _parseCellReference(startRef);
        CellReference endCell = _parseCellReference(endRef);

        if (startCell.columnIndex != endCell.columnIndex) {
          throw Exception('Range must be in the same column');
        }

        List<double> values = _getValuesInRange(
            startCell.columnIndex, startCell.rowIndex, endCell.rowIndex);

        double result;
        switch (function) {
          case 'SUM':
            result = values.fold(0.0, (a, b) => a + b);
            break;
          case 'AVG':
            if (values.isEmpty) return '0';
            result = values.fold(0.0, (a, b) => a + b) / values.length;
            break;
          case 'COUNT':
            return values.length.toString();
          case 'MAX':
            if (values.isEmpty) return '0';
            result = values.reduce((a, b) => a > b ? a : b);
            break;
          case 'MIN':
            if (values.isEmpty) return '0';
            result = values.reduce((a, b) => a < b ? a : b);
            break;
          default:
            throw Exception('Unknown function: $function');
        }

        // Truncate the result (round down)
        return result.floor().toString();
      } catch (e) {
        print('Error processing range function ${match.group(0)}: $e');
        throw Exception('Range function error: ${e.toString()}');
      }
    });
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

        var rowModel =
            sheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
        if (rowModel == null) {
          return '0';
        }

        var cellModel = rowModel.cells
            .firstWhereOrNull((c) => c.columnIndex == columnIndex);
        if (cellModel == null ||
            cellModel.value == null ||
            cellModel.value!.isEmpty) {
          return '0';
        }

        double? value = double.tryParse(cellModel.value!);
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

  CellReference _parseCellReference(String cellRef) {
    RegExp pattern = RegExp(r'([A-Za-z]+)(\d+)');
    Match? match = pattern.firstMatch(cellRef);

    if (match == null) {
      throw Exception('Invalid cell reference: $cellRef');
    }

    String columnRef = match.group(1)!;
    int rowIndex = int.parse(match.group(2)!);

    if (!_columnIndexMap.containsKey(columnRef.toUpperCase())) {
      throw Exception('Invalid column reference: $columnRef');
    }

    int columnIndex = _columnIndexMap[columnRef.toUpperCase()]!;

    return CellReference(rowIndex: rowIndex, columnIndex: columnIndex);
  }

  List<double> _getValuesInRange(int columnIndex, int start, int end) {
    List<double> values = [];

    for (int rowIndex = start; rowIndex <= end; rowIndex++) {
      try {
        var rowModel =
            sheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
        if (rowModel == null) continue;

        var cellModel = rowModel.cells
            .firstWhereOrNull((c) => c.columnIndex == columnIndex);
        if (cellModel == null ||
            cellModel.value == null ||
            cellModel.value!.isEmpty) continue;

        double? value = double.tryParse(cellModel.value!);
        if (value != null) {
          values.add(value);
        }
      } catch (e) {
        print('Error getting value from cell: $e');
      }
    }

    return values;
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

  // Get all formula cells in the sheet, sorted by dependencies
  List<Map<String, dynamic>> getAllFormulaCells() {
    List<Map<String, dynamic>> formulaCells = [];

    try {
      for (var row in sheet.rows) {
        for (var cell in row.cells) {
          if (cell.formula != null && cell.formula!.startsWith('=')) {
            formulaCells.add({
              'rowIndex': row.rowIndex,
              'columnIndex': cell.columnIndex, // Added
              'formula': cell.formula!, // Added
              'cellId': cell.id, // Added
              'rowId': row.id, // Added
              'dependencies': extractCellReferencesFromFormula(cell.formula!),
            });
          }
        }
      }

      // Sort by row index and then column index for consistent processing
      formulaCells.sort((a, b) {
        int rowComparison = a['rowIndex'].compareTo(b['rowIndex']);
        if (rowComparison != 0) return rowComparison;
        return a['columnIndex'].compareTo(b['columnIndex']);
      });

      print("Found ${formulaCells.length} formula cells to process");
    } catch (e) {
      print('Error getting all formula cells: $e');
    }

    return formulaCells;
  }

  // Clear cache when sheet data changes
  void clearCache() {
    _evaluationCache.clear();
    _circularReferenceCheck.clear();
  }
}

class CellReference {
  final int rowIndex;
  final int columnIndex;

  CellReference({required this.rowIndex, required this.columnIndex});
}
