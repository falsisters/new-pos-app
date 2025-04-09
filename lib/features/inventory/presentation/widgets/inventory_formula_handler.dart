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

      // Round down the result to a whole number
      return result.floor().toString();
    } catch (e) {
      print('Formula evaluation error: $e');
      return '#ERROR';
    }
  }

  // Process range functions like SUM, AVG, COUNT, MAX, MIN
  String _processRangeFunctions(String formula) {
    // Pattern to match range functions: SUM(A1:A10), AVG(A1:A10), etc.
    RegExp rangePattern =
        RegExp(r'(SUM|AVG|COUNT|MAX|MIN)\(([A-Za-z0-9]+):([A-Za-z0-9]+)\)');

    return formula.replaceAllMapped(rangePattern, (match) {
      String function = match.group(1)!.toUpperCase();
      String startRef = match.group(2)!;
      String endRef = match.group(3)!;

      try {
        // Parse cell references
        CellReference startCell = _parseCellReference(startRef);
        CellReference endCell = _parseCellReference(endRef);

        // Ensure column indices match for ranges
        if (startCell.columnIndex != endCell.columnIndex) {
          throw Exception('Range must be in the same column');
        }

        // Get values in the range
        List<double> values = _getValuesInRange(
            startCell.columnIndex, startCell.rowIndex, endCell.rowIndex);

        // Apply the function to the values without rounding intermediate values
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

    // Ensure proper range ordering
    int start = startRowIndex < endRowIndex ? startRowIndex : endRowIndex;
    int end = startRowIndex > endRowIndex ? startRowIndex : endRowIndex;

    // Collect values from cells in the range
    for (int rowIndex = start; rowIndex <= end; rowIndex++) {
      try {
        // Find the row
        InventoryRowModel? row =
            sheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
        if (row == null) continue;

        // Find the cell
        InventoryCellModel? cell =
            row.cells.firstWhereOrNull((c) => c.columnIndex == columnIndex);
        if (cell == null || cell.value == null || cell.value!.isEmpty) continue;

        // Try to parse the value
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
    // Pattern to match cell references: A1, B2, Quantity5, etc.
    RegExp cellPattern = RegExp(r'([A-Za-z]+)([0-9]+)');

    return formula.replaceAllMapped(cellPattern, (match) {
      String column = match.group(1)!;
      int rowIndex = int.parse(match.group(2)!);

      try {
        // Check if the column exists in our mapping
        if (!_columnIndexMap.containsKey(column.toUpperCase())) {
          throw Exception('Invalid column reference: $column');
        }

        int columnIndex = _columnIndexMap[column.toUpperCase()]!;

        // Find the row
        InventoryRowModel? row =
            sheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
        if (row == null) {
          return '0';
        }

        // Find the cell
        InventoryCellModel? cell =
            row.cells.firstWhereOrNull((c) => c.columnIndex == columnIndex);
        if (cell == null || cell.value == null || cell.value!.isEmpty) {
          return '0';
        }

        // Try to parse the value, return 0 if not a number
        double? value = double.tryParse(cell.value!);
        if (value == null) {
          return '0';
        }

        // Return the exact value without rounding
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

    // Check if the column exists in our mapping
    if (!_columnIndexMap.containsKey(column.toUpperCase())) {
      throw Exception('Invalid column reference: $column');
    }

    int columnIndex = _columnIndexMap[column.toUpperCase()]!;

    return CellReference(columnIndex, rowIndex);
  }
}
