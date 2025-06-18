import 'package:falsisters_pos_android/features/inventory/data/models/inventory_cell_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_row_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/inventory_formula_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';

class InventoryFormulaManager {
  InventorySheetModel _sheet;
  late InventoryFormulaHandler _formulaHandler;
  final Map<String, Set<String>> _formulaDependencies = {};

  InventoryFormulaManager({required InventorySheetModel sheet})
      : _sheet = sheet {
    _formulaHandler = InventoryFormulaHandler(sheet: sheet);
    buildFormulaDependencyMap();
  }

  InventoryFormulaHandler get formulaHandler => _formulaHandler;
  Map<String, Set<String>> get formulaDependencies => _formulaDependencies;

  void updateSheet(InventorySheetModel newSheet) {
    _sheet = newSheet;
    _formulaHandler = InventoryFormulaHandler(sheet: newSheet);
    buildFormulaDependencyMap();
  }

  void buildFormulaDependencyMap() {
    _formulaDependencies.clear();
    for (var row in _sheet.rows) {
      for (var cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          Set<String> dependencies =
              _formulaHandler.extractCellReferencesFromFormula(cell.formula!);

          for (String dependency in dependencies) {
            if (!_formulaDependencies.containsKey(dependency)) {
              _formulaDependencies[dependency] = {};
            }
            _formulaDependencies[dependency]!
                .add('${row.rowIndex}_${cell.columnIndex}');
          }
        }
      }
    }
  }

  List<Map<String, dynamic>> getAllFormulaCells() {
    List<Map<String, dynamic>> formulaCells = [];

    final sortedRows = List<InventoryRowModel>.from(_sheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    for (var row in sortedRows) {
      final sortedCells = List<InventoryCellModel>.from(row.cells)
        ..sort((a, b) => a.columnIndex.compareTo(b.columnIndex));

      for (var cell in sortedCells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          formulaCells.add({
            'cellId': cell.id,
            'rowIndex': row.rowIndex,
            'columnIndex': cell.columnIndex,
            'formula': cell.formula!,
            'currentValue': cell.value,
          });
        }
      }
    }

    return formulaCells;
  }

  List<Map<String, dynamic>> recalculateAllFormulas() {
    List<Map<String, dynamic>> cellsToUpdate = [];
    List<Map<String, dynamic>> formulaCells = getAllFormulaCells();

    if (formulaCells.isEmpty) return cellsToUpdate;

    int maxPasses = 5;
    bool hasChanges = true;

    for (int pass = 0; pass < maxPasses && hasChanges; pass++) {
      hasChanges = false;

      for (var cellData in formulaCells) {
        try {
          String formula = cellData['formula'] as String;
          int rowIndex = cellData['rowIndex'] as int;
          int columnIndex = cellData['columnIndex'] as int;
          String cellId = cellData['cellId'] as String;
          String? currentValue = cellData['currentValue'] as String?;

          String newValue =
              _formulaHandler.evaluateFormula(formula, rowIndex, columnIndex);

          if (newValue != currentValue) {
            hasChanges = true;
            cellData['currentValue'] = newValue;

            cellsToUpdate.removeWhere((cell) => cell['id'] == cellId);
            cellsToUpdate.add({
              'id': cellId,
              'value': newValue,
              'formula': formula,
            });
          }
        } catch (e) {
          String cellId = cellData['cellId'] as String;
          cellsToUpdate.removeWhere((cell) => cell['id'] == cellId);
          cellsToUpdate.add({
            'id': cellId,
            'value': '#ERROR',
            'formula': cellData['formula'],
          });
        }
      }
    }

    return cellsToUpdate;
  }

  Set<String> getDependentCells(int rowIndex, int columnIndex) {
    String cellKey = '${rowIndex}_${columnIndex}';
    String columnLetter = getColumnLetter(columnIndex);
    String namedCellKey = '$columnLetter$rowIndex';

    Set<String> dependentCells = {};

    if (_formulaDependencies.containsKey(cellKey)) {
      dependentCells.addAll(_formulaDependencies[cellKey]!);
    }
    if (_formulaDependencies.containsKey(namedCellKey)) {
      dependentCells.addAll(_formulaDependencies[namedCellKey]!);
    }

    return dependentCells;
  }

  String getColumnLetter(int index) {
    String columnLetter = '';
    int tempIndex = index;

    while (tempIndex >= 0) {
      columnLetter = String.fromCharCode((tempIndex % 26) + 65) + columnLetter;
      tempIndex = (tempIndex ~/ 26) - 1;
    }
    return columnLetter;
  }

  // Quick Formula Generators
  String generateSubtractVerticalFormula(int rowIndex, int columnIndex) {
    if (rowIndex >= 2) {
      final topRowIndex = rowIndex - 2;
      final bottomRowIndex = rowIndex - 1;

      bool topRowExists = _sheet.rows.any((r) => r.rowIndex == topRowIndex);
      bool bottomRowExists =
          _sheet.rows.any((r) => r.rowIndex == bottomRowIndex);

      if (topRowExists && bottomRowExists) {
        return '=${getColumnLetter(columnIndex)}$topRowIndex - ${getColumnLetter(columnIndex)}$bottomRowIndex';
      }
    }
    return '';
  }

  String generateProductFormula(
      int rowIndex, int columnIndex, InventoryRowModel rowModel) {
    if (columnIndex < 2) return '';

    int firstColumnIndex = columnIndex - 2;
    int secondColumnIndex = columnIndex - 1;

    final firstCell = rowModel.cells
        .firstWhereOrNull((c) => c.columnIndex == firstColumnIndex);
    final secondCell = rowModel.cells
        .firstWhereOrNull((c) => c.columnIndex == secondColumnIndex);

    bool firstCellValid = _isCellValidForCalculation(firstCell);
    bool secondCellValid = _isCellValidForCalculation(secondCell);

    if (!firstCellValid || !secondCellValid) return '';

    return "=${getColumnLetter(firstColumnIndex)}$rowIndex * ${getColumnLetter(secondColumnIndex)}$rowIndex";
  }

  String generateSumFormula(
      int rowIndex, int columnIndex, InventoryRowModel rowModel) {
    if (columnIndex <= 1) return '';

    List<String> terms = [];
    bool hasValidValues = false;

    for (int colToSum = 1; colToSum < columnIndex; colToSum++) {
      final cell =
          rowModel.cells.firstWhereOrNull((c) => c.columnIndex == colToSum);

      if (_isCellValidForCalculation(cell)) {
        terms.add("${getColumnLetter(colToSum)}$rowIndex");
        hasValidValues = true;
      }
    }

    if (!hasValidValues || terms.isEmpty) return '';

    return "=" + terms.join(" + ");
  }

  String generateSumAllAboveFormula(int rowIndex, int columnIndex) {
    List<String> terms = [];

    final sortedRows = List<InventoryRowModel>.from(_sheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    for (var rowIter in sortedRows) {
      if (rowIter.rowIndex < rowIndex) {
        final cellInColumn =
            rowIter.cells.firstWhereOrNull((c) => c.columnIndex == columnIndex);

        if (_isCellValidForCalculation(cellInColumn)) {
          terms.add('${getColumnLetter(columnIndex)}${rowIter.rowIndex}');
        }
      }
    }

    if (terms.isEmpty) return '';

    return '=' + terms.join(' + ');
  }

  bool _isCellValidForCalculation(InventoryCellModel? cell) {
    if (cell == null ||
        cell.value == null ||
        cell.value!.isEmpty ||
        cell.value == '0') {
      return false;
    }

    try {
      double.parse(cell.value!);
      return true;
    } catch (_) {
      return cell.formula != null && cell.formula!.startsWith('=');
    }
  }
}
