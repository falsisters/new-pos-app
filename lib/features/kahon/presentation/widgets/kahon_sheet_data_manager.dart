import 'package:falsisters_pos_android/features/kahon/presentation/widgets/kahon_sheet_new.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/row_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/cell_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/providers/sheet_provider.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart'; // For RowReorderOperation
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/enhanced_row_reorder_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/formula_reference_updater.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';

class KahonSheetDataManager {
  final WidgetRef _ref;
  SheetModel _currentSheet;

  KahonSheetDataManager({
    required WidgetRef ref,
    required SheetModel sheet,
  })  : _ref = ref,
        _currentSheet = sheet;

  SheetModel get currentSheet => _currentSheet;

  void updateSheet(SheetModel newSheet) {
    _currentSheet = newSheet;
  }

  // Handle cell submission
  ({SheetModel updatedSheet, CellChange? pendingChange}) handleCellSubmit(
    int rowIndex,
    int columnIndex,
    String value,
    String? colorHex,
    String? originalValue,
    String? originalColorHex,
  ) {
    print(
        "_handleCellSubmit called with: rowIndex=$rowIndex, columnIndex=$columnIndex, value=$value, color=$colorHex");

    // Skip submitting empty unchanged values
    if (originalValue == value && originalColorHex == colorHex) {
      return (updatedSheet: _currentSheet, pendingChange: null);
    }

    try {
      final rowModel = _currentSheet.rows.firstWhere(
        (r) => r.rowIndex == rowIndex,
        orElse: () => throw Exception('Row not found'),
      );
      print("Found row with id: ${rowModel.id}");

      final existingCell = rowModel.cells.firstWhereOrNull(
        (c) => c.columnIndex == columnIndex,
      );

      String? formula;
      String displayValue = value;

      // Check if the value is a formula
      if (value.startsWith('=')) {
        formula = value;
        // Formula evaluation will be handled by FormulaManager
        displayValue = value; // Keep original for now
      }

      String changeKey = '${rowIndex}_${columnIndex}';
      CellChange? pendingChange;

      if (existingCell != null && !existingCell.id.startsWith('temp_')) {
        pendingChange = CellChange(
          isUpdate: true,
          cellId: existingCell.id,
          rowId: rowModel.id,
          columnIndex: columnIndex,
          displayValue: displayValue,
          formula: formula,
          color: colorHex,
        );
        print("Created update change: $changeKey");
      } else {
        pendingChange = CellChange(
          isUpdate: false,
          rowId: rowModel.id,
          columnIndex: columnIndex,
          displayValue: displayValue,
          formula: formula,
          color: colorHex,
        );
        print("Created new change: $changeKey");
      }

      // Create updated sheet for UI
      SheetModel updatedSheet = _createUpdatedSheetWithCell(
        _currentSheet,
        rowModel,
        existingCell,
        columnIndex,
        displayValue,
        formula,
        colorHex,
      );

      _currentSheet = updatedSheet;
      return (updatedSheet: updatedSheet, pendingChange: pendingChange);
    } catch (e) {
      print('Error handling cell submission: $e');
      return (updatedSheet: _currentSheet, pendingChange: null);
    }
  }

  // Create updated sheet with new/modified cell
  SheetModel _createUpdatedSheetWithCell(
    SheetModel currentSheet,
    RowModel targetRow,
    CellModel? existingCell,
    int columnIndex,
    String displayValue,
    String? formula,
    String? colorHex,
  ) {
    return SheetModel(
      id: currentSheet.id,
      name: currentSheet.name,
      columns: currentSheet.columns,
      kahonId: currentSheet.kahonId,
      createdAt: currentSheet.createdAt,
      updatedAt: currentSheet.updatedAt,
      rows: currentSheet.rows.map((row) {
        if (row.id == targetRow.id) {
          List<CellModel> updatedCells = [...row.cells];

          if (existingCell != null) {
            // Update existing cell
            int cellIndex =
                updatedCells.indexWhere((c) => c.id == existingCell.id);
            if (cellIndex != -1) {
              updatedCells[cellIndex] = CellModel(
                id: existingCell.id,
                rowId: existingCell.rowId,
                columnIndex: existingCell.columnIndex,
                value: displayValue,
                formula: formula,
                color: colorHex,
                isCalculated: formula != null,
                createdAt: existingCell.createdAt,
                updatedAt: DateTime.now(),
              );
            }
          } else {
            // Add new cell
            updatedCells.add(CellModel(
              id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
              rowId: targetRow.id,
              columnIndex: columnIndex,
              value: displayValue,
              formula: formula,
              color: colorHex,
              isCalculated: formula != null,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ));
          }

          return RowModel(
            id: row.id,
            sheetId: row.sheetId,
            rowIndex: row.rowIndex,
            isItemRow: row.isItemRow,
            itemId: row.itemId,
            cells: updatedCells,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
          );
        }
        return row;
      }).toList(),
    );
  }

  // Handle row reordering
  Future<RowReorderOperation?> handleRowReorder(
    String movedRowId,
    int oldDisplayIndex,
    int newDisplayIndex,
  ) async {
    print(
        "Handling row reorder: $movedRowId from $oldDisplayIndex to $newDisplayIndex");

    final List<RowModel> currentDisplayOrderedRows =
        List<RowModel>.from(_currentSheet.rows)
          ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    final List<RowMapping> rowMappings =
        EnhancedRowReorderHandler.calculateSequentialMappings(
      currentDisplayOrderedRows,
      movedRowId,
      oldDisplayIndex,
      newDisplayIndex,
    );

    if (rowMappings.isEmpty) {
      print("No row mappings generated, reorder resulted in no change.");
      return null;
    }

    final Map<int, int> actualRowIndexChangesMap = {
      for (var mapping in rowMappings) mapping.oldRowIndex: mapping.newRowIndex
    };

    final List<FormulaReferenceUpdate> formulaUpdates =
        FormulaReferenceUpdater.calculateFormulaUpdates(
            _currentSheet, actualRowIndexChangesMap);

    // Create optimistic UI update
    SheetModel optimisticSheet =
        _createOptimisticReorderedSheet(rowMappings, formulaUpdates);
    _currentSheet = optimisticSheet;

    // Prepare data for persistence
    final List<Map<String, dynamic>> rowMappingsForNotifier =
        rowMappings.map((m) => m.toJson()).toList();

    final List<Map<String, dynamic>> formulaUpdatesForNotifier = formulaUpdates
        .map((fu) => {
              'cellId': fu.cellId,
              'newFormula': fu.newFormula,
              'newValue': fu.newValue,
              'rowIndex': fu.rowIndex,
              'columnIndex': fu.columnIndex,
            })
        .toList();

    return RowReorderOperation(
      sheetId: _currentSheet.id,
      rowMappings: rowMappingsForNotifier,
      formulaUpdates: formulaUpdatesForNotifier,
    );
  }

  // Create optimistic sheet after row reorder
  SheetModel _createOptimisticReorderedSheet(
    List<RowMapping> rowMappings,
    List<FormulaReferenceUpdate> formulaUpdates,
  ) {
    SheetModel optimisticSheet = _currentSheet;

    // Update row indices
    List<RowModel> updatedRowsOptimistic = optimisticSheet.rows.map((row) {
      final mapping = rowMappings.firstWhereOrNull((m) => m.rowId == row.id);
      if (mapping != null) {
        return row.copyWith(rowIndex: mapping.newRowIndex);
      }
      return row;
    }).toList();
    optimisticSheet = optimisticSheet.copyWith(rows: updatedRowsOptimistic);

    // Update formulas
    List<RowModel> finalRowsOptimistic = optimisticSheet.rows.map((row) {
      List<CellModel> updatedCells = row.cells.map((cell) {
        final formulaUpdate =
            formulaUpdates.firstWhereOrNull((fu) => fu.cellId == cell.id);
        if (formulaUpdate != null) {
          return cell.copyWith(
            formula: formulaUpdate.newFormula,
            value: formulaUpdate.newValue,
            isCalculated: formulaUpdate.newFormula.startsWith('='),
            updatedAt: DateTime.now(),
          );
        }
        return cell;
      }).toList();
      return row.copyWith(cells: updatedCells);
    }).toList();
    optimisticSheet = optimisticSheet.copyWith(rows: finalRowsOptimistic);

    // Sort rows by index
    final mutableRows = List<RowModel>.from(optimisticSheet.rows);
    mutableRows.sort((a, b) => a.rowIndex.compareTo(b.rowIndex));
    optimisticSheet = optimisticSheet.copyWith(rows: mutableRows);

    return optimisticSheet;
  }

  // Apply pending changes to database
  Future<bool> applyPendingChanges(
      Map<String, CellChange> pendingChanges) async {
    if (pendingChanges.isEmpty) return true;

    try {
      List<Map<String, dynamic>> cellsToUpdate = [];
      List<Map<String, dynamic>> cellsToCreate = [];

      print("Processing ${pendingChanges.length} pending changes");

      for (var change in pendingChanges.values) {
        if (change.isUpdate) {
          cellsToUpdate.add({
            'id': change.cellId,
            'value': change.displayValue,
            'formula': change.formula,
            'color': change.color,
          });
          print(
              "Update cell: id=${change.cellId}, value=${change.displayValue}, color=${change.color}");
        } else {
          cellsToCreate.add({
            'rowId': change.rowId,
            'columnIndex': change.columnIndex,
            'value': change.displayValue,
            'formula': change.formula,
            'color': change.color,
          });
          print(
              "Create cell: rowId=${change.rowId}, columnIndex=${change.columnIndex}, value=${change.displayValue}, color=${change.color}");
        }
      }

      if (cellsToUpdate.isNotEmpty) {
        print("Updating ${cellsToUpdate.length} cells");
        await _ref
            .read(sheetNotifierProvider.notifier)
            .updateCells(cellsToUpdate);
      }

      if (cellsToCreate.isNotEmpty) {
        print("Creating ${cellsToCreate.length} cells");
        await _ref
            .read(sheetNotifierProvider.notifier)
            .createCells(cellsToCreate);
      }

      return true;
    } catch (e) {
      print('Error applying pending changes: $e');
      return false;
    }
  }

  // Apply row reorder operations
  Future<bool> applyRowReorderOperations(
      List<RowReorderOperation> operations) async {
    if (operations.isEmpty) return true;

    try {
      print("Processing ${operations.length} pending row reorder operations");
      for (var operation in operations) {
        bool success =
            await _ref.read(sheetNotifierProvider.notifier).enhancedRowReorder(
                  sheetId: operation.sheetId,
                  rowMappings: operation.rowMappings,
                  formulaUpdates: operation.formulaUpdates,
                );
        if (!success) {
          throw Exception("Failed to save one or more row reorder operations.");
        }
      }
      return true;
    } catch (e) {
      print('Error applying row reorder operations: $e');
      return false;
    }
  }

  // Add calculation row
  Future<bool> addCalculationRow(int afterRowIdx) async {
    try {
      await _ref
          .read(sheetNotifierProvider.notifier)
          .createCalculationRow(_currentSheet.id, afterRowIdx + 1);
      return true;
    } catch (e) {
      print('Error adding calculation row: $e');
      return false;
    }
  }

  // Add multiple calculation rows
  Future<bool> addMultipleCalculationRows(List<int> rowIndexes) async {
    try {
      await _ref
          .read(sheetNotifierProvider.notifier)
          .createCalculationRows(_currentSheet.id, rowIndexes);
      return true;
    } catch (e) {
      print('Error adding calculation rows: $e');
      return false;
    }
  }

  // Delete row
  Future<bool> deleteRow(String rowId) async {
    try {
      await _ref.read(sheetNotifierProvider.notifier).deleteRow(rowId);
      return true;
    } catch (e) {
      print('Error deleting row: $e');
      return false;
    }
  }
}
