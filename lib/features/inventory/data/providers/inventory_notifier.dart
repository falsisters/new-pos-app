import 'package:drift/drift.dart';
import 'package:falsisters_pos_android/core/database/database.dart';
import 'package:falsisters_pos_android/core/database/providers/database_provider.dart';
import 'package:falsisters_pos_android/core/sync/sync_engine.dart';
import 'package:falsisters_pos_android/features/inventory/data/local/inventory_local_repository.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_state.dart';
import 'package:falsisters_pos_android/features/inventory/data/repository/inventory_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryNotifier extends AsyncNotifier<InventoryState> {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  InventoryLocalRepository get _localRepo =>
      InventoryLocalRepository(ref.read(databaseProvider).requireValue);

  SyncEngine get _syncEngine => ref.read(syncEngineProvider);

  @override
  Future<InventoryState> build() async {
    try {
      final localSheet = await _localRepo.getSheetByDate();
      if (localSheet != null) {
        _syncEngine.pullAndMerge('inventory', '/inventory/date');
        return InventoryState(sheet: localSheet);
      }

      final inventoryData =
          await _inventoryRepository.getInventoryByDate(null, null);
      return InventoryState(sheet: inventoryData);
    } catch (e) {
      return InventoryState(error: e.toString());
    }
  }

  Future<void> _refreshLocalSheet() async {
    try {
      final localSheet = await _localRepo.getSheetByDate();
      if (localSheet != null) {
        state = AsyncValue.data(InventoryState(sheet: localSheet));
      }
    } catch (_) {}
  }

  Future<void> getInventoryByDate(
      DateTime? startDate, DateTime? endDate) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final localSheet = await _localRepo.getSheetByDate(
          startDate: startDate,
          endDate: endDate,
        );
        if (localSheet != null) {
          _syncEngine.pullAndMerge('inventory', '/inventory/date');
          return InventoryState(sheet: localSheet);
        }

        final inventoryData =
            await _inventoryRepository.getInventoryByDate(startDate, endDate);
        return InventoryState(sheet: inventoryData);
      } catch (e) {
        return InventoryState(error: e.toString());
      }
    });
  }

  Future<void> createInventoryRow(String inventoryId, int rowIndex) async {
    try {
      await _localRepo.createCalculationRow(
        sheetId: inventoryId,
        rowIndex: rowIndex,
      );
      _syncEngine.syncFeature('inventory');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(InventoryState(error: e.toString()));
    }
  }

  Future<void> createInventoryRows(
      String inventoryId, List<int> rowIndexes) async {
    try {
      for (final rowIndex in rowIndexes) {
        await _localRepo.createCalculationRow(
          sheetId: inventoryId,
          rowIndex: rowIndex,
        );
      }
      _syncEngine.syncFeature('inventory');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(InventoryState(error: e.toString()));
    }
  }

  Future<void> deleteRow(String rowId) async {
    try {
      await _localRepo.deleteRow(rowId);
      _syncEngine.syncFeature('inventory');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(InventoryState(error: e.toString()));
    }
  }

  Future<void> createCell(String rowId, int columnIndex, String value,
      String? color, String? formula) async {
    try {
      await _localRepo.createCell(
        inventoryRowId: rowId,
        columnIndex: columnIndex,
        value: value,
        color: color,
        formula: formula,
      );
      _syncEngine.syncFeature('inventory');
    } catch (e) {
      state = AsyncValue.data(InventoryState(error: e.toString()));
    }
  }

  Future<void> updateCell(
      String cellId, String value, String? color, String? formula) async {
    try {
      await _localRepo.updateCell(
        cellId: cellId,
        value: value,
        color: color,
        formula: formula,
      );
      _syncEngine.syncFeature('inventory');
    } catch (e) {
      state = AsyncValue.data(InventoryState(error: e.toString()));
    }
  }

  Future<void> deleteCell(String cellId) async {
    try {
      await _localRepo.deleteCell(cellId);
      _syncEngine.syncFeature('inventory');
    } catch (e) {
      state = AsyncValue.data(InventoryState(error: e.toString()));
    }
  }

  Future<void> updateCells(List<Map<String, dynamic>> cells) async {
    try {
      await _localRepo.updateCells(cells);
      _syncEngine.syncFeature('inventory');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(InventoryState(error: e.toString()));
    }
  }

  Future<void> createCells(List<Map<String, dynamic>> cells) async {
    try {
      await _localRepo.createCells(cells);
      _syncEngine.syncFeature('inventory');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(InventoryState(error: e.toString()));
    }
  }

  Future<void> updateRowPosition(String rowId, int newRowIndex) async {
    try {
      await _localRepo.updateRowPositions([
        {'rowId': rowId, 'newRowIndex': newRowIndex},
      ]);
      _syncEngine.syncFeature('inventory');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(InventoryState(error: e.toString()));
    }
  }

  Future<void> updateRowPositions(List<Map<String, dynamic>> updates) async {
    try {
      await _localRepo.updateRowPositions(updates);
      _syncEngine.syncFeature('inventory');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(InventoryState(error: e.toString()));
    }
  }

  Future<Map<String, dynamic>> batchUpdateRowPositions(
      List<Map<String, dynamic>> mappings) async {
    try {
      await _localRepo.updateRowPositions(mappings);
      _syncEngine.syncFeature('inventory');
      await _refreshLocalSheet();
      return {'success': true};
    } catch (e) {
      throw Exception('Failed to batch update row positions: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> batchUpdateCellFormulas(
      List<Map<String, dynamic>> updates) async {
    try {
      final now = DateTime.now();
      final db = ref.read(databaseProvider).requireValue;
      for (final update in updates) {
        final cellId = update['cellId'] as String?;
        if (cellId == null) continue;
        final formula = update['formula'] as String?;
        final value = update['value'] as String?;
        await (db.update(db.localInventoryCells)
              ..where((tbl) => tbl.id.equals(cellId)))
            .write(LocalInventoryCellsCompanion(
          formula: formula != null ? Value(formula) : const Value.absent(),
          value: value != null ? Value(value) : const Value.absent(),
          synced: const Value(false),
          localUpdatedAt: Value(now),
        ));
      }
      _syncEngine.syncFeature('inventory');
      await _refreshLocalSheet();
      return {'success': true};
    } catch (e) {
      throw Exception(
          'Failed to batch update cell formulas: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> validateRowMappings(
      String sheetId, List<Map<String, dynamic>> mappings) async {
    try {
      return await _inventoryRepository.validateRowMappings(sheetId, mappings);
    } catch (e) {
      throw Exception('Failed to validate row mappings: ${e.toString()}');
    }
  }
}
