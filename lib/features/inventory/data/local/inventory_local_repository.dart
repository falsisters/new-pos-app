import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:falsisters_pos_android/core/database/database.dart';
import 'package:falsisters_pos_android/core/sync/idempotency_service.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_cell_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_row_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';

class InventoryLocalRepository {
  final AppDatabase _db;

  InventoryLocalRepository(this._db);

  // ── READ ──

  Future<InventorySheetModel?> getSheetByDate({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final now = DateTime.now();
    final start = startDate ?? DateTime(now.year, now.month, now.day);
    final end = endDate ?? start.add(const Duration(days: 1));

    final localSheets = await (_db.select(_db.localInventorySheets)
          ..where((tbl) => tbl.createdAt.isBetweenValues(
              start.millisecondsSinceEpoch, end.millisecondsSinceEpoch)))
        .get();

    if (localSheets.isEmpty) return null;

    final sheet = localSheets.first;

    final localRows = await (_db.select(_db.localInventoryRows)
          ..where((tbl) => tbl.inventorySheetId.equals(sheet.id))
          ..orderBy([(t) => OrderingTerm(expression: t.rowIndex)]))
        .get();

    final allCells = <String, List<LocalInventoryCell>>{};
    for (final row in localRows) {
      final cells = await (_db.select(_db.localInventoryCells)
            ..where((tbl) => tbl.inventoryRowId.equals(row.id))
            ..orderBy([(t) => OrderingTerm(expression: t.columnIndex)]))
          .get();
      allCells[row.id] = cells;
    }

    final rows = localRows.map((lr) {
      final cells = (allCells[lr.id] ?? []).map((lc) {
        return InventoryCellModel(
          id: lc.id,
          columnIndex: lc.columnIndex,
          inventoryRowId: lc.inventoryRowId,
          color: lc.color,
          value: lc.value,
          formula: lc.formula,
          isCalculated: lc.isCalculated,
          createdAt: lc.createdAt,
          updatedAt: lc.updatedAt,
        );
      }).toList();

      return InventoryRowModel(
        id: lr.id,
        rowIndex: lr.rowIndex,
        inventorySheetId: lr.inventorySheetId,
        isItemRow: lr.isItemRow,
        itemId: lr.itemId,
        createdAt: lr.createdAt,
        updatedAt: lr.updatedAt,
        cells: cells,
      );
    }).toList();

    return InventorySheetModel(
      id: sheet.id,
      name: sheet.name,
      inventoryId: sheet.inventoryId,
      columns: sheet.columns,
      createdAt: sheet.createdAt,
      updatedAt: sheet.updatedAt,
      rows: rows,
    );
  }

  // ── INDIVIDUAL CELL: CREATE ──

  Future<InventoryCellModel> createCell({
    required String inventoryRowId,
    required int columnIndex,
    String? value,
    String? color,
    String? formula,
    bool isCalculated = false,
  }) async {
    final cellCuid = IdempotencyService.generateCuid();
    final now = DateTime.now();

    await _db.transaction(() async {
      await _db.into(_db.localInventoryCells).insert(
        LocalInventoryCellsCompanion.insert(
          id: cellCuid,
          inventoryRowId: inventoryRowId,
          columnIndex: columnIndex,
          value: value != null ? Value(value) : const Value.absent(),
          color: color != null ? Value(color) : const Value.absent(),
          formula: formula != null ? Value(formula) : const Value.absent(),
          isCalculated: isCalculated,
          inventoryItemId: const Value.absent(),
          createdAt: now,
          updatedAt: now,
          synced: const Value(false),
          localUpdatedAt: now,
        ),
      );

      await _db.into(_db.outboxEntries).insert(
        OutboxEntriesCompanion.insert(
          id: IdempotencyService.generateCuid(),
          feature: 'inventory',
          operation: 'create',
          endpoint: '/inventory/cell',
          method: 'POST',
          clientCuid: cellCuid,
          payload: jsonEncode({
            'rowId': inventoryRowId,
            'columnIndex': columnIndex,
            'value': value ?? '',
            'color': color,
            'formula': formula,
          }),
          idempotencyKey: IdempotencyService.generateIdempotencyKey(),
          createdAt: now,
        ),
      );
    });

    return InventoryCellModel(
      id: cellCuid,
      columnIndex: columnIndex,
      inventoryRowId: inventoryRowId,
      color: color,
      value: value,
      formula: formula,
      isCalculated: isCalculated,
      createdAt: now,
      updatedAt: now,
    );
  }

  // ── INDIVIDUAL CELL: UPDATE ──

  Future<InventoryCellModel> updateCell({
    required String cellId,
    String? value,
    String? color,
    String? formula,
    bool? isCalculated,
  }) async {
    final now = DateTime.now();

    await _db.transaction(() async {
      await (_db.update(_db.localInventoryCells)
            ..where((tbl) => tbl.id.equals(cellId)))
          .write(LocalInventoryCellsCompanion(
        value: value != null ? Value(value) : const Value.absent(),
        color: color != null ? Value(color) : const Value.absent(),
        formula: formula != null ? Value(formula) : const Value.absent(),
        isCalculated: isCalculated != null
            ? Value(isCalculated)
            : const Value.absent(),
        updatedAt: Value(now),
        synced: const Value(false),
        localUpdatedAt: Value(now),
      ));

      await _db.into(_db.outboxEntries).insert(
        OutboxEntriesCompanion.insert(
          id: IdempotencyService.generateCuid(),
          feature: 'inventory',
          operation: 'update',
          endpoint: '/inventory/cell/$cellId',
          method: 'PATCH',
          clientCuid: cellId,
          payload: jsonEncode({
            'value': value ?? '',
            'color': color,
            'formula': formula,
          }),
          idempotencyKey: IdempotencyService.generateIdempotencyKey(),
          createdAt: now,
        ),
      );
    });

    final existing = await (_db.select(_db.localInventoryCells)
          ..where((tbl) => tbl.id.equals(cellId)))
        .getSingle();

    return InventoryCellModel(
      id: existing.id,
      columnIndex: existing.columnIndex,
      inventoryRowId: existing.inventoryRowId,
      color: color ?? existing.color,
      value: value ?? existing.value,
      formula: formula != null ? formula : existing.formula,
      isCalculated: isCalculated ?? existing.isCalculated,
      createdAt: existing.createdAt,
      updatedAt: now,
    );
  }

  // ── INDIVIDUAL CELL: DELETE ──

  Future<void> deleteCell(String cellId) async {
    final now = DateTime.now();

    await _db.transaction(() async {
      await (_db.update(_db.localInventoryCells)
            ..where((tbl) => tbl.id.equals(cellId)))
          .write(LocalInventoryCellsCompanion(
        synced: const Value(false),
        localUpdatedAt: Value(now),
      ));

      await _db.into(_db.outboxEntries).insert(
        OutboxEntriesCompanion.insert(
          id: IdempotencyService.generateCuid(),
          feature: 'inventory',
          operation: 'delete',
          endpoint: '/inventory/cell/$cellId',
          method: 'DELETE',
          clientCuid: cellId,
          payload: '{}',
          idempotencyKey: IdempotencyService.generateIdempotencyKey(),
          createdAt: now,
        ),
      );
    });
  }

  // ── BATCH: CREATE CELLS ──

  Future<List<InventoryCellModel>> createCells(
      List<Map<String, dynamic>> cells) async {
    final now = DateTime.now();
    final createdCells = <InventoryCellModel>[];
    final payloadList = <Map<String, dynamic>>[];

    await _db.transaction(() async {
      for (final cellData in cells) {
        final cellCuid = IdempotencyService.generateCuid();
        final rowId = cellData['rowId'] as String;
        final columnIndex = cellData['columnIndex'] as int;
        final cellValue = cellData['value'] as String?;
        final cellColor = cellData['color'] as String?;
        final cellFormula = cellData['formula'] as String?;
        final cellIsCalculated = cellData['isCalculated'] as bool? ?? false;

        await _db.into(_db.localInventoryCells).insert(
          LocalInventoryCellsCompanion.insert(
            id: cellCuid,
            inventoryRowId: rowId,
            columnIndex: columnIndex,
            value: cellValue != null ? Value(cellValue) : const Value.absent(),
            color: cellColor != null ? Value(cellColor) : const Value.absent(),
            formula: cellFormula != null ? Value(cellFormula) : const Value.absent(),
            isCalculated: cellIsCalculated,
            inventoryItemId: const Value.absent(),
            createdAt: now,
            updatedAt: now,
            synced: const Value(false),
            localUpdatedAt: now,
          ),
        );

        createdCells.add(InventoryCellModel(
          id: cellCuid,
          columnIndex: columnIndex,
          inventoryRowId: rowId,
          color: cellColor,
          value: cellValue,
          formula: cellFormula,
          isCalculated: cellIsCalculated,
          createdAt: now,
          updatedAt: now,
        ));

        payloadList.add({
          'rowId': rowId,
          'columnIndex': columnIndex,
          'value': cellValue ?? '',
          'color': cellColor,
          'formula': cellFormula,
        });
      }

      await _db.into(_db.outboxEntries).insert(
        OutboxEntriesCompanion.insert(
          id: IdempotencyService.generateCuid(),
          feature: 'inventory',
          operation: 'create',
          endpoint: '/inventory/cells',
          method: 'POST',
          clientCuid: IdempotencyService.generateCuid(),
          payload: jsonEncode(payloadList),
          idempotencyKey: IdempotencyService.generateIdempotencyKey(),
          createdAt: now,
        ),
      );
    });

    return createdCells;
  }

  // ── BATCH: UPDATE CELLS ──

  Future<List<InventoryCellModel>> updateCells(
      List<Map<String, dynamic>> cells) async {
    final now = DateTime.now();
    final updatedCells = <InventoryCellModel>[];
    final payloadList = <Map<String, dynamic>>[];

    await _db.transaction(() async {
      for (final cellData in cells) {
        final cellId = cellData['id'] as String?;
        final cellValue = cellData['value'] as String?;
        final cellColor = cellData['color'] as String?;
        final cellFormula = cellData['formula'] as String?;

        if (cellId == null) continue;

        await (_db.update(_db.localInventoryCells)
              ..where((tbl) => tbl.id.equals(cellId)))
            .write(LocalInventoryCellsCompanion(
          value: cellValue != null ? Value(cellValue) : const Value.absent(),
          color: cellColor != null ? Value(cellColor) : const Value.absent(),
          formula: cellFormula != null ? Value(cellFormula) : const Value.absent(),
          updatedAt: Value(now),
          synced: const Value(false),
          localUpdatedAt: Value(now),
        ));

        final existing = await (_db.select(_db.localInventoryCells)
              ..where((tbl) => tbl.id.equals(cellId)))
            .getSingle();

        updatedCells.add(InventoryCellModel(
          id: existing.id,
          columnIndex: existing.columnIndex,
          inventoryRowId: existing.inventoryRowId,
          color: cellColor ?? existing.color,
          value: cellValue ?? existing.value,
          formula: cellFormula != null ? cellFormula : existing.formula,
          isCalculated: existing.isCalculated,
          createdAt: existing.createdAt,
          updatedAt: now,
        ));

        payloadList.add({
          'id': cellId,
          'value': cellValue ?? '',
          'color': cellColor,
          'formula': cellFormula,
        });
      }

      await _db.into(_db.outboxEntries).insert(
        OutboxEntriesCompanion.insert(
          id: IdempotencyService.generateCuid(),
          feature: 'inventory',
          operation: 'update',
          endpoint: '/inventory/cells',
          method: 'PATCH',
          clientCuid: IdempotencyService.generateCuid(),
          payload: jsonEncode(payloadList),
          idempotencyKey: IdempotencyService.generateIdempotencyKey(),
          createdAt: now,
        ),
      );
    });

    return updatedCells;
  }

  // ── ROW: CREATE CALCULATION ──

  Future<InventoryRowModel> createCalculationRow({
    required String sheetId,
    required int rowIndex,
  }) async {
    final rowCuid = IdempotencyService.generateCuid();
    final now = DateTime.now();

    await _db.transaction(() async {
      final sheet = await (_db.select(_db.localInventorySheets)
            ..where((tbl) => tbl.id.equals(sheetId)))
          .getSingle();

      await _db.into(_db.localInventoryRows).insert(
        LocalInventoryRowsCompanion.insert(
          id: rowCuid,
          inventorySheetId: sheetId,
          rowIndex: rowIndex,
          isItemRow: false,
          itemId: const Value.absent(),
          createdAt: now,
          updatedAt: now,
          synced: const Value(false),
        ),
      );

      for (var i = 0; i < sheet.columns; i++) {
        final cellCuid = IdempotencyService.generateCuid();
        await _db.into(_db.localInventoryCells).insert(
          LocalInventoryCellsCompanion.insert(
            id: cellCuid,
            inventoryRowId: rowCuid,
            columnIndex: i,
            value: const Value(''),
            color: const Value.absent(),
            formula: const Value.absent(),
            isCalculated: false,
            inventoryItemId: const Value.absent(),
            createdAt: now,
            updatedAt: now,
            synced: const Value(false),
            localUpdatedAt: now,
          ),
        );
      }

      await _db.into(_db.outboxEntries).insert(
        OutboxEntriesCompanion.insert(
          id: IdempotencyService.generateCuid(),
          feature: 'inventory',
          operation: 'create',
          endpoint: '/inventory/calculation-row',
          method: 'POST',
          clientCuid: rowCuid,
          payload: jsonEncode({
            'inventoryId': sheet.inventoryId,
            'rowIndex': rowIndex,
          }),
          idempotencyKey: IdempotencyService.generateIdempotencyKey(),
          createdAt: now,
        ),
      );
    });

    return InventoryRowModel(
      id: rowCuid,
      rowIndex: rowIndex,
      inventorySheetId: sheetId,
      isItemRow: false,
      createdAt: now,
      updatedAt: now,
      cells: [],
    );
  }

  // ── ROW: DELETE ──

  Future<void> deleteRow(String rowId) async {
    final now = DateTime.now();

    await _db.transaction(() async {
      await (_db.update(_db.localInventoryRows)
            ..where((tbl) => tbl.id.equals(rowId)))
          .write(LocalInventoryRowsCompanion(
        synced: const Value(false),
        updatedAt: Value(now),
      ));

      await (_db.update(_db.localInventoryCells)
            ..where((tbl) => tbl.inventoryRowId.equals(rowId)))
          .write(LocalInventoryCellsCompanion(
        synced: const Value(false),
        localUpdatedAt: Value(now),
      ));

      await _db.into(_db.outboxEntries).insert(
        OutboxEntriesCompanion.insert(
          id: IdempotencyService.generateCuid(),
          feature: 'inventory',
          operation: 'delete',
          endpoint: '/inventory/row/$rowId',
          method: 'DELETE',
          clientCuid: rowId,
          payload: '{}',
          idempotencyKey: IdempotencyService.generateIdempotencyKey(),
          createdAt: now,
        ),
      );
    });
  }

  // ── REORDER: ROW POSITIONS ──

  Future<void> updateRowPositions(List<Map<String, dynamic>> mappings) async {
    final now = DateTime.now();

    await _db.transaction(() async {
      for (final mapping in mappings) {
        final rowId = mapping['rowId'] as String;
        final newRowIndex = mapping['newRowIndex'] as int;

        await (_db.update(_db.localInventoryRows)
              ..where((tbl) => tbl.id.equals(rowId)))
            .write(LocalInventoryRowsCompanion(
          rowIndex: Value(newRowIndex),
          synced: const Value(false),
          updatedAt: Value(now),
        ));
      }

      await _db.into(_db.outboxEntries).insert(
        OutboxEntriesCompanion.insert(
          id: IdempotencyService.generateCuid(),
          feature: 'inventory',
          operation: 'update',
          endpoint: '/inventory/rows/positions/batch',
          method: 'PATCH',
          clientCuid: IdempotencyService.generateCuid(),
          payload: jsonEncode({'mappings': mappings}),
          idempotencyKey: IdempotencyService.generateIdempotencyKey(),
          createdAt: now,
          priority: const Value(10),
        ),
      );
    });
  }

  // ── SERVER UPSERT ──

  Future<void> upsertSheetFromServer(InventorySheetModel sheet) async {
    await _db.transaction(() async {
      await _db.into(_db.localInventorySheets).insertOnConflictUpdate(
        LocalInventorySheetsCompanion.insert(
          id: sheet.id,
          name: sheet.name,
          inventoryId: sheet.inventoryId,
          columns: sheet.columns,
          createdAt: sheet.createdAt,
          updatedAt: sheet.updatedAt,
          needsRefresh: const Value(false),
        ),
      );

      for (final row in sheet.rows) {
        final localRow = await (_db.select(_db.localInventoryRows)
              ..where((tbl) => tbl.id.equals(row.id)))
            .getSingleOrNull();

        if (localRow != null) {
          if (localRow.synced) {
            await _db.into(_db.localInventoryRows).insertOnConflictUpdate(
              LocalInventoryRowsCompanion.insert(
                id: row.id,
                inventorySheetId: row.inventorySheetId,
                rowIndex: row.rowIndex,
                isItemRow: row.isItemRow,
                itemId: row.itemId != null ? Value(row.itemId) : const Value.absent(),
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
                synced: const Value(true),
              ),
            );
          }
        } else {
          await _db.into(_db.localInventoryRows).insert(
            LocalInventoryRowsCompanion.insert(
              id: row.id,
              inventorySheetId: row.inventorySheetId,
              rowIndex: row.rowIndex,
              isItemRow: row.isItemRow,
              itemId: row.itemId != null ? Value(row.itemId) : const Value.absent(),
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
              synced: const Value(true),
            ),
          );
        }

        for (final cell in row.cells) {
          final localCell = await (_db.select(_db.localInventoryCells)
                ..where((tbl) => tbl.id.equals(cell.id)))
              .getSingleOrNull();

          if (localCell != null) {
            if (localCell.synced) {
              await _db.into(_db.localInventoryCells).insertOnConflictUpdate(
                LocalInventoryCellsCompanion.insert(
                  id: cell.id,
                  inventoryRowId: cell.inventoryRowId,
                  columnIndex: cell.columnIndex,
                  value: cell.value != null ? Value(cell.value) : const Value.absent(),
                  color: cell.color != null ? Value(cell.color) : const Value.absent(),
                  formula: cell.formula != null ? Value(cell.formula) : const Value.absent(),
                  isCalculated: cell.isCalculated,
                  inventoryItemId: const Value.absent(),
                  createdAt: cell.createdAt,
                  updatedAt: cell.updatedAt,
                  synced: const Value(true),
                  localUpdatedAt: DateTime.now(),
                ),
              );
            }
          } else {
            await _db.into(_db.localInventoryCells).insert(
              LocalInventoryCellsCompanion.insert(
                id: cell.id,
                inventoryRowId: cell.inventoryRowId,
                columnIndex: cell.columnIndex,
                value: cell.value != null ? Value(cell.value) : const Value.absent(),
                color: cell.color != null ? Value(cell.color) : const Value.absent(),
                formula: cell.formula != null ? Value(cell.formula) : const Value.absent(),
                isCalculated: cell.isCalculated,
                inventoryItemId: const Value.absent(),
                createdAt: cell.createdAt,
                updatedAt: cell.updatedAt,
                synced: const Value(true),
                localUpdatedAt: DateTime.now(),
              ),
            );
          }
        }
      }

      final serverRowIds = sheet.rows.map((r) => r.id).toSet();
      final allLocalRows = await (_db.select(_db.localInventoryRows)
            ..where((tbl) => tbl.inventorySheetId.equals(sheet.id)))
          .get();

      for (final localRow in allLocalRows) {
        if (localRow.synced && !serverRowIds.contains(localRow.id)) {
          await (_db.delete(_db.localInventoryCells)
                ..where((tbl) => tbl.inventoryRowId.equals(localRow.id)))
              .go();
          await (_db.delete(_db.localInventoryRows)
                ..where((tbl) => tbl.id.equals(localRow.id)))
              .go();
        }
      }
    });
  }
}
