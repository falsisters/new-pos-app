import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/formula_handler_new.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart';

class KahonSheetFormulaManager {
  late FormulaHandler _formulaHandler;
  SheetModel _currentSheet;

  KahonSheetFormulaManager({required SheetModel sheet})
      : _currentSheet = sheet {
    _formulaHandler = FormulaHandler(sheet: sheet);
  }

  FormulaHandler get formulaHandler => _formulaHandler;
  SheetModel get currentSheet => _currentSheet;

  void updateSheet(SheetModel newSheet) {
    _currentSheet = newSheet;
    _formulaHandler = FormulaHandler(sheet: newSheet);
  }

  // Build a map of formula dependencies
  Map<String, Set<String>> buildFormulaDependencyMap() {
    final Map<String, Set<String>> formulaDependencies = {};
    print("Rebuilding formula dependency map...");

    for (var row in _currentSheet.rows) {
      for (var cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          Set<String> dependencies =
              _formulaHandler.extractCellReferencesFromFormula(cell.formula!);

          if (dependencies.isEmpty) {
            print("No dependencies found for formula: ${cell.formula}");
          }

          for (String dependency in dependencies) {
            if (!formulaDependencies.containsKey(dependency)) {
              formulaDependencies[dependency] = {};
            }

            String cellKey = '${row.rowIndex}_${cell.columnIndex}';
            formulaDependencies[dependency]!.add(cellKey);

            print(
                "Added dependency: $dependency -> $cellKey (formula: ${cell.formula})");
          }
        }
      }
    }

    print(
        'Formula dependencies built with ${formulaDependencies.length} entries');
    return formulaDependencies;
  }

  // Recalculate all formulas when sheet is loaded
  ({SheetModel updatedSheet, Map<String, CellChange> pendingChanges})
      recalculateAllFormulasOnLoad() {
    print("Recalculating all formulas on sheet load...");

    List<Map<String, dynamic>> formulaCells =
        _formulaHandler.getAllFormulaCells();
    if (formulaCells.isEmpty) {
      print("No formula cells found to recalculate");
      return (
        updatedSheet: _currentSheet,
        pendingChanges: <String, CellChange>{}
      );
    }

    SheetModel workingSheet = _currentSheet.copyWith();
    Map<String, CellChange> pendingChanges = {};
    bool hasChanges = false;

    int maxPasses = 5;
    for (int pass = 0; pass < maxPasses; pass++) {
      bool changesInThisPass = false;
      print("Formula recalculation pass ${pass + 1}");

      FormulaHandler passHandler = FormulaHandler(sheet: workingSheet);

      for (var formulaCell in formulaCells) {
        try {
          int rowIndex = formulaCell['rowIndex'];
          int columnIndex = formulaCell['columnIndex'];
          String formula = formulaCell['formula'];
          String cellId = formulaCell['cellId'];
          String rowId = formulaCell['rowId'];

          String newValue =
              passHandler.evaluateFormula(formula, rowIndex, columnIndex);

          final rowModel =
              workingSheet.rows.firstWhereOrNull((r) => r.id == rowId);
          if (rowModel != null) {
            final cellModel =
                rowModel.cells.firstWhereOrNull((c) => c.id == cellId);
            if (cellModel != null && cellModel.value != newValue) {
              print(
                  "Updating formula cell $rowIndex,$columnIndex: ${cellModel.value} -> $newValue");

              workingSheet = updateCellInSheet(
                  workingSheet,
                  rowId,
                  cellId,
                  newValue,
                  formula,
                  cellModel.color,
                  true); // Ensure isCalculated is true

              String changeKey = '${rowIndex}_${columnIndex}';
              pendingChanges[changeKey] = CellChange(
                isUpdate: true,
                cellId: cellId,
                rowId: rowId,
                columnIndex: columnIndex,
                displayValue: newValue,
                formula: formula,
                color: cellModel.color,
                isCalculated:
                    true, // Ensure this is set to true for formula cells
              );

              changesInThisPass = true;
              hasChanges = true;
            }
          }
        } catch (e) {
          print("Error recalculating formula cell: $e");
        }
      }

      if (!changesInThisPass) {
        print(
            "No changes in pass ${pass + 1}, recalculation complete for this loop.");
        break;
      }
      if (pass == maxPasses - 1 && changesInThisPass) {
        print(
            "Max passes reached in formula recalculation. There might be circular dependencies or an issue.");
      }
    }

    if (hasChanges) {
      print("Formula recalculation on load complete with changes.");
      _currentSheet = workingSheet;
      _formulaHandler = FormulaHandler(sheet: workingSheet);
    }

    return (updatedSheet: workingSheet, pendingChanges: pendingChanges);
  }

  // Update dependent formulas after cell value change
  ({SheetModel updatedSheet, Map<String, CellChange> newPendingChanges})
      updateDependentFormulas(
    int rowIndex,
    int columnIndex,
    SheetModel currentSheet,
    Map<String, Set<String>> formulaDependencies,
  ) {
    String cellKey = '${rowIndex}_${columnIndex}';
    String columnLetter = getColumnLetter(columnIndex);
    String namedCellKey = '$columnLetter$rowIndex';

    Set<String> dependentCells = {};
    if (formulaDependencies.containsKey(cellKey)) {
      dependentCells.addAll(formulaDependencies[cellKey]!);
    }
    if (formulaDependencies.containsKey(namedCellKey)) {
      dependentCells.addAll(formulaDependencies[namedCellKey]!);
    }

    if (dependentCells.isEmpty) {
      print("No dependent cells found for $cellKey or $namedCellKey");
      return (
        updatedSheet: currentSheet,
        newPendingChanges: <String, CellChange>{}
      );
    }

    print(
        'Updating dependent formulas for cell $cellKey ($namedCellKey): $dependentCells');

    _formulaHandler = FormulaHandler(sheet: currentSheet);
    SheetModel updatedSheet =
        currentSheet.copyWith(rows: [...currentSheet.rows]);
    Set<String> processedCells = {cellKey, namedCellKey};

    Map<String, CellChange> newPendingChanges = {};
    processDependentCells(
        dependentCells, processedCells, updatedSheet, newPendingChanges);

    return (updatedSheet: updatedSheet, newPendingChanges: newPendingChanges);
  }

  // Process dependent cells recursively
  void processDependentCells(
    Set<String> cellsToUpdate,
    Set<String> processedCells,
    SheetModel sheet,
    Map<String, CellChange> pendingChanges,
  ) {
    List<String> cellsToProcess = cellsToUpdate.toList();

    for (String cellKey in cellsToProcess) {
      if (processedCells.contains(cellKey)) {
        print("Skipping already processed cell: $cellKey");
        continue;
      }

      print("Processing dependent cell: $cellKey");
      processedCells.add(cellKey);

      List<String> parts = cellKey.split('_');
      if (parts.length == 2) {
        int depRowIndex = int.parse(parts[0]);
        int depColumnIndex = int.parse(parts[1]);

        var rowModel =
            sheet.rows.firstWhereOrNull((r) => r.rowIndex == depRowIndex);
        if (rowModel == null) {
          print("Row not found for index: $depRowIndex");
          continue;
        }

        var cellModel = rowModel.cells
            .firstWhereOrNull((c) => c.columnIndex == depColumnIndex);
        if (cellModel == null ||
            cellModel.formula == null ||
            !cellModel.formula!.startsWith('=')) {
          print("Cell doesn't contain a formula: $cellKey");
          continue;
        }

        try {
          print(
              "Recalculating formula: ${cellModel.formula} for cell $cellKey");

          String newValue = _formulaHandler.evaluateFormula(
              cellModel.formula!, depRowIndex, depColumnIndex);
          print("Formula result: $newValue (old value: ${cellModel.value})");

          if (newValue != cellModel.value) {
            String changeKey = '${depRowIndex}_${depColumnIndex}';
            pendingChanges[changeKey] = CellChange(
              isUpdate: true,
              cellId: cellModel.id,
              rowId: rowModel.id,
              columnIndex: depColumnIndex,
              displayValue: newValue,
              formula: cellModel.formula,
              color: cellModel.color,
              isCalculated:
                  true, // Ensure this is set to true for formula cells
            );
            print("Added formula update to pending changes: $changeKey");
          }
        } catch (e) {
          print("Error recalculating formula: $e");
        }
      }
    }
  }

  // Recalculate all formula cells in the sheet
  ({SheetModel updatedSheet, Map<String, CellChange> newPendingChanges})
      recalculateAllFormulas(SheetModel currentSheet) {
    print("Starting full formula recalculation...");

    SheetModel updatedSheet = currentSheet.copyWith();
    Map<String, CellChange> newPendingChanges = {};
    int formulasProcessed = 0;
    FormulaHandler localFormulaHandler = FormulaHandler(sheet: updatedSheet);

    for (var row in updatedSheet.rows) {
      for (var cell in row.cells) {
        if (cell.formula != null && cell.formula!.startsWith('=')) {
          try {
            String newValue = localFormulaHandler.evaluateFormula(
                cell.formula!, row.rowIndex, cell.columnIndex);

            if (newValue != cell.value) {
              String changeKey = '${row.rowIndex}_${cell.columnIndex}';
              newPendingChanges[changeKey] = CellChange(
                isUpdate: true,
                cellId: cell.id,
                rowId: row.id,
                columnIndex: cell.columnIndex,
                displayValue: newValue,
                formula: cell.formula,
                color: cell.color,
                isCalculated:
                    true, // Ensure this is set to true for formula cells
              );
              updatedSheet = updateCellInSheet(
                  updatedSheet,
                  row.id,
                  cell.id,
                  newValue,
                  cell.formula,
                  cell.color,
                  true); // Ensure isCalculated is true
              formulasProcessed++;
            }
          } catch (e) {
            print("Error recalculating formula ${cell.formula}: $e");
          }
        }
      }
    }

    print(
        "Formula recalculation complete. Updated $formulasProcessed formulas.");

    if (formulasProcessed > 0) {
      _currentSheet = updatedSheet;
      _formulaHandler = FormulaHandler(sheet: updatedSheet);
    }

    return (updatedSheet: updatedSheet, newPendingChanges: newPendingChanges);
  }

  // Helper method to update a cell in the sheet immutably
  SheetModel updateCellInSheet(SheetModel sheet, String rowId, String cellId,
      String newValue, String? formula, String? color,
      [bool? isCalculated]) {
    return sheet.copyWith(
      rows: sheet.rows.map((row) {
        if (row.id == rowId) {
          return row.copyWith(
            cells: row.cells.map((cell) {
              if (cell.id == cellId) {
                return cell.copyWith(
                  value: newValue,
                  formula: formula,
                  color: color,
                  isCalculated: isCalculated ??
                      (formula != null && formula.startsWith('=')),
                  updatedAt: DateTime.now(),
                );
              }
              return cell;
            }).toList(),
            updatedAt: DateTime.now(),
          );
        }
        return row;
      }).toList(),
      updatedAt: DateTime.now(),
    );
  }

  // Convert column index to Excel-like column letters
  String getColumnLetter(int index) {
    if (index == 0) return "Quantity";
    if (index == 1) return "Name";
    String columnLetter = '';
    int adjustedIndex = index - 2;
    while (adjustedIndex >= 0) {
      columnLetter =
          String.fromCharCode((adjustedIndex % 26) + 65) + columnLetter;
      adjustedIndex = (adjustedIndex ~/ 26) - 1;
    }
    return columnLetter;
  }

  // Quick Formula Generators
  String generateAddVerticalFormula(int rowIndex, int columnIndex) {
    if (rowIndex >= 2) {
      final topRowIndex = rowIndex - 2;
      final bottomRowIndex = rowIndex - 1;

      bool topRowExists =
          _currentSheet.rows.any((r) => r.rowIndex == topRowIndex);
      bool bottomRowExists =
          _currentSheet.rows.any((r) => r.rowIndex == bottomRowIndex);

      if (topRowExists && bottomRowExists) {
        return '=${getColumnLetter(columnIndex)}$topRowIndex + ${getColumnLetter(columnIndex)}$bottomRowIndex';
      }
    }
    return '';
  }

  String generateSubtractVerticalFormula(int rowIndex, int columnIndex) {
    if (rowIndex >= 2) {
      final topRowIndex = rowIndex - 2;
      final bottomRowIndex = rowIndex - 1;

      bool topRowExists =
          _currentSheet.rows.any((r) => r.rowIndex == topRowIndex);
      bool bottomRowExists =
          _currentSheet.rows.any((r) => r.rowIndex == bottomRowIndex);

      if (topRowExists && bottomRowExists) {
        return '=${getColumnLetter(columnIndex)}$topRowIndex - ${getColumnLetter(columnIndex)}$bottomRowIndex';
      }
    }
    return '';
  }

  String generateSumAllAboveFormula(int rowIndex, int columnIndex) {
    List<int> validRowIndexes = _currentSheet.rows
        .where((r) => r.rowIndex < rowIndex)
        .map((r) => r.rowIndex)
        .toList();

    if (validRowIndexes.isNotEmpty) {
      validRowIndexes.sort();
      String cellReferences = validRowIndexes
          .map((idx) => '${getColumnLetter(columnIndex)}$idx')
          .join(' + ');
      return '=$cellReferences';
    }
    return '';
  }

  String generateMultiplyFormula(int rowIndex, int columnIndex) {
    if (columnIndex >= 2) {
      int leftColumnIndex = columnIndex - 2;
      int rightColumnIndex = columnIndex - 1;

      return '=${getColumnLetter(leftColumnIndex)}$rowIndex * ${getColumnLetter(rightColumnIndex)}$rowIndex';
    }
    return '';
  }

  // Evaluate formula and return result directly
  String evaluateQuickFormula(String formula, int rowIndex, int columnIndex) {
    if (formula.isEmpty) return '';

    try {
      return _formulaHandler.evaluateFormulaDirectly(
          formula, rowIndex, columnIndex);
    } catch (e) {
      print('Error evaluating quick formula: $e');
      return '#ERROR';
    }
  }

  // Check if cells are valid for calculations
  bool _isCellValidForCalculation(int rowIndex, int columnIndex) {
    final rowModel =
        _currentSheet.rows.firstWhereOrNull((r) => r.rowIndex == rowIndex);
    if (rowModel == null) return false;

    final cell =
        rowModel.cells.firstWhereOrNull((c) => c.columnIndex == columnIndex);
    if (cell == null || cell.value == null || cell.value!.isEmpty) {
      return false;
    }

    return double.tryParse(cell.value!) != null ||
        (cell.formula != null && cell.formula!.startsWith('='));
  }
}
