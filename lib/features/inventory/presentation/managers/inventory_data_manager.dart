import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_cell_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_row_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/providers/inventory_provider.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/enhanced_row_reorder_handler.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/cell_change.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/row_reorder_change.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/first_or_where_null.dart';

class InventoryDataManager {
  final WidgetRef ref;

  InventoryDataManager({required this.ref});

  Future<void> applyPendingChanges(
    Map<String, CellChange> pendingChanges,
    Map<String, RowReorderChange> pendingRowReorders,
  ) async {
    if (pendingChanges.isEmpty && pendingRowReorders.isEmpty) return;

    try {
      // Apply row reordering first
      if (pendingRowReorders.isNotEmpty) {
        List<Map<String, dynamic>> rowUpdates = pendingRowReorders.values
            .map((change) => {
                  'rowId': change.rowId,
                  'newRowIndex': change.newRowIndex,
                })
            .toList();

        await ref
            .read(inventoryProvider.notifier)
            .updateRowPositions(rowUpdates);
      }

      // Apply cell changes
      if (pendingChanges.isNotEmpty) {
        List<Map<String, dynamic>> cellsToUpdate = [];
        List<Map<String, dynamic>> cellsToCreate = [];

        for (var change in pendingChanges.values) {
          if (change.isUpdate) {
            cellsToUpdate.add({
              'id': change.cellId,
              'value': change.displayValue,
              'formula': change.formula,
              'color': change.color,
            });
          } else {
            cellsToCreate.add({
              'rowId': change.rowId,
              'columnIndex': change.columnIndex,
              'value': change.displayValue,
              'formula': change.formula,
              'color': change.color,
            });
          }
        }

        if (cellsToUpdate.isNotEmpty) {
          await ref.read(inventoryProvider.notifier).updateCells(cellsToUpdate);
        }

        if (cellsToCreate.isNotEmpty) {
          await ref.read(inventoryProvider.notifier).createCells(cellsToCreate);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> applyEnhancedRowReorder(
    List<RowMapping> mappings,
    List<FormulaUpdate> formulaUpdates,
  ) async {
    try {
      if (mappings.isNotEmpty) {
        final rowResults = await ref
            .read(inventoryProvider.notifier)
            .batchUpdateRowPositions(mappings.map((m) => m.toJson()).toList());

        if (rowResults['errors'] != null && rowResults['errors'].isNotEmpty) {
          throw Exception(
              'Row position update errors: ${rowResults['errors']}');
        }
      }

      if (formulaUpdates.isNotEmpty) {
        final formulaResults = await ref
            .read(inventoryProvider.notifier)
            .batchUpdateCellFormulas(
                formulaUpdates.map((u) => u.toJson()).toList());

        if (formulaResults['errors'] != null &&
            formulaResults['errors'].isNotEmpty) {
          throw Exception('Formula update errors: ${formulaResults['errors']}');
        }
      }

      await ref.read(inventoryProvider.notifier).getInventoryByDate(null, null);
    } catch (e) {
      try {
        await ref
            .read(inventoryProvider.notifier)
            .getInventoryByDate(null, null);
      } catch (refreshError) {
        // Log refresh error but don't override original error
      }
      rethrow;
    }
  }

  Future<void> autoSaveRecalculatedFormulas(
      List<Map<String, dynamic>> cellsToUpdate) async {
    try {
      await ref.read(inventoryProvider.notifier).updateCells(cellsToUpdate);
    } catch (e) {
      // Don't show error to user since this is a background operation
      print('Error auto-saving recalculated formulas: $e');
    }
  }

  Future<void> addCalculationRow(String inventoryId, int afterRowIndex) async {
    await ref
        .read(inventoryProvider.notifier)
        .createInventoryRow(inventoryId, afterRowIndex + 1);
  }

  Future<void> addMultipleCalculationRows(
      String inventoryId, int afterRowIndex, int rowCount) async {
    List<int> rowIndexes =
        List.generate(rowCount, (index) => afterRowIndex + 1 + index);

    await ref
        .read(inventoryProvider.notifier)
        .createInventoryRows(inventoryId, rowIndexes);
  }

  Future<void> deleteRow(String rowId) async {
    await ref.read(inventoryProvider.notifier).deleteRow(rowId);
  }

  InventorySheetModel updateRowOrderInSheet(
    InventorySheetModel currentSheet,
    int oldIndex,
    int newIndex,
  ) {
    final sortedRows = List<InventoryRowModel>.from(currentSheet.rows)
      ..sort((a, b) => a.rowIndex.compareTo(b.rowIndex));

    if (oldIndex >= 0 &&
        oldIndex < sortedRows.length &&
        newIndex >= 0 &&
        newIndex < sortedRows.length) {
      final movedRow = sortedRows.removeAt(oldIndex);
      sortedRows.insert(newIndex, movedRow);

      final updatedRows = <InventoryRowModel>[];
      for (int i = 0; i < sortedRows.length; i++) {
        final row = sortedRows[i];
        updatedRows.add(InventoryRowModel(
          id: row.id,
          inventorySheetId: row.inventorySheetId,
          rowIndex: i,
          isItemRow: row.isItemRow,
          itemId: row.itemId,
          cells: row.cells,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
        ));
      }

      return InventorySheetModel(
        id: currentSheet.id,
        name: currentSheet.name,
        columns: currentSheet.columns,
        inventoryId: currentSheet.inventoryId,
        createdAt: currentSheet.createdAt,
        updatedAt: currentSheet.updatedAt,
        rows: updatedRows,
      );
    }

    return currentSheet;
  }

  InventorySheetModel updateCellInSheet(
      InventorySheetModel currentSheet,
      String rowId,
      int columnIndex,
      String displayValue,
      String? formula,
      String? color,
      {String? existingCellId}) {
    return InventorySheetModel(
      id: currentSheet.id,
      name: currentSheet.name,
      columns: currentSheet.columns,
      inventoryId: currentSheet.inventoryId,
      createdAt: currentSheet.createdAt,
      updatedAt: currentSheet.updatedAt,
      rows: currentSheet.rows.map((row) {
        if (row.id == rowId) {
          List<InventoryCellModel> updatedCells = [...row.cells];

          if (existingCellId != null) {
            // Update existing cell
            int cellIndex =
                updatedCells.indexWhere((c) => c.id == existingCellId);
            if (cellIndex != -1) {
              final existingCell = updatedCells[cellIndex];
              updatedCells[cellIndex] = InventoryCellModel(
                id: existingCell.id,
                inventoryRowId: existingCell.inventoryRowId,
                columnIndex: existingCell.columnIndex,
                value: displayValue,
                formula: formula,
                color: color,
                isCalculated: formula != null,
                createdAt: existingCell.createdAt,
                updatedAt: DateTime.now(),
              );
            }
          } else {
            // Add new cell
            updatedCells.add(InventoryCellModel(
              id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
              inventoryRowId: rowId,
              columnIndex: columnIndex,
              value: displayValue,
              formula: formula,
              color: color,
              isCalculated: formula != null,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ));
          }

          return InventoryRowModel(
            id: row.id,
            inventorySheetId: row.inventorySheetId,
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
}
