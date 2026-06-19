import 'package:falsisters_pos_android/core/database/providers/database_provider.dart';
import 'package:falsisters_pos_android/core/sync/sync_engine.dart';
import 'package:falsisters_pos_android/features/kahon/data/local/kahon_local_repository.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/sheet_state.dart';
import 'package:falsisters_pos_android/features/kahon/data/repository/kahon_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SheetNotifier extends AsyncNotifier<SheetState> {
  final KahonRepository _kahonRepository = KahonRepository();

  KahonLocalRepository get _localRepo =>
      KahonLocalRepository(ref.read(databaseProvider).requireValue);

  SyncEngine get _syncEngine => ref.read(syncEngineProvider);

  @override
  Future<SheetState> build() async {
    try {
      final localSheet = await _localRepo.getSheetByDate();
      if (localSheet != null) {
        _syncEngine.pullAndMerge('kahon', '/sheet/date');
        return SheetState(sheet: localSheet);
      }

      final sheetData = await _kahonRepository.getSheetByDate(null, null);
      return SheetState(sheet: sheetData);
    } catch (e) {
      return SheetState(error: e.toString());
    }
  }

  Future<void> getSheetByDate(DateTime? startDate, DateTime? endDate) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final localSheet = await _localRepo.getSheetByDate(
          startDate: startDate,
          endDate: endDate,
        );
        if (localSheet != null) {
          _syncEngine.pullAndMerge('kahon', '/sheet/date');
          return SheetState(sheet: localSheet);
        }

        final sheetData =
            await _kahonRepository.getSheetByDate(startDate, endDate);
        return SheetState(sheet: sheetData);
      } catch (e) {
        return SheetState(error: e.toString());
      }
    });
  }

  Future<void> _refreshLocalSheet() async {
    try {
      final localSheet = await _localRepo.getSheetByDate();
      if (localSheet != null) {
        state = AsyncValue.data(SheetState(sheet: localSheet));
      }
    } catch (_) {}
  }

  Future<void> createCalculationRow(String sheetId, int rowIndex) async {
    try {
      await _localRepo.createCalculationRow(
        sheetId: sheetId,
        rowIndex: rowIndex,
      );
      _syncEngine.syncFeature('kahon');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
    }
  }

  Future<void> createCalculationRows(
      String sheetId, List<int> rowIndexes) async {
    try {
      for (final rowIndex in rowIndexes) {
        await _localRepo.createCalculationRow(
          sheetId: sheetId,
          rowIndex: rowIndex,
        );
      }
      _syncEngine.syncFeature('kahon');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
    }
  }

  Future<void> deleteRow(String rowId) async {
    try {
      await _localRepo.deleteRow(rowId);
      _syncEngine.syncFeature('kahon');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
    }
  }

  Future<void> createCell(String rowId, int columnIndex, String value,
      String? color, String? formula) async {
    try {
      await _localRepo.createCell(
        rowId: rowId,
        columnIndex: columnIndex,
        value: value,
        color: color,
        formula: formula,
      );
      _syncEngine.syncFeature('kahon');
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
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
      _syncEngine.syncFeature('kahon');
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
    }
  }

  Future<void> deleteCell(String cellId) async {
    try {
      await _localRepo.deleteCell(cellId);
      _syncEngine.syncFeature('kahon');
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
    }
  }

  Future<void> updateCells(List<Map<String, dynamic>> cells) async {
    try {
      await _localRepo.updateCells(cells);
      _syncEngine.syncFeature('kahon');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
    }
  }

  Future<void> createCells(List<Map<String, dynamic>> cells) async {
    try {
      await _localRepo.createCells(cells);
      _syncEngine.syncFeature('kahon');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
    }
  }

  Future<void> updateRowPosition(String rowId, int newRowIndex) async {
    try {
      await _localRepo.updateRowPositions([
        {'rowId': rowId, 'newRowIndex': newRowIndex},
      ]);
      _syncEngine.syncFeature('kahon');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
    }
  }

  Future<void> updateRowPositions(List<Map<String, dynamic>> updates) async {
    try {
      await _localRepo.updateRowPositions(updates);
      _syncEngine.syncFeature('kahon');
      await _refreshLocalSheet();
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
    }
  }

  Future<bool> batchUpdateRowPositions(
      List<Map<String, dynamic>> updates) async {
    try {
      await _localRepo.updateRowPositions(updates);
      _syncEngine.syncFeature('kahon');
      await _refreshLocalSheet();
      return true;
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
      return false;
    }
  }

  Future<bool> comprehensiveRowReorder({
    required String sheetId,
    required List<Map<String, dynamic>> rowReorders,
    required List<Map<String, dynamic>> affectedFormulas,
  }) async {
    try {
      await _localRepo.comprehensiveRowReorder(
        sheetId: sheetId,
        rowMappings: rowReorders,
        formulaUpdates: affectedFormulas,
      );
      _syncEngine.syncFeature('kahon');
      await _refreshLocalSheet();
      return true;
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
      return false;
    }
  }

  Future<bool> enhancedRowReorder({
    required String sheetId,
    required List<Map<String, dynamic>> rowMappings,
    required List<Map<String, dynamic>> formulaUpdates,
  }) async {
    try {
      await _localRepo.comprehensiveRowReorder(
        sheetId: sheetId,
        rowMappings: rowMappings,
        formulaUpdates: formulaUpdates,
      );
      _syncEngine.syncFeature('kahon');
      await _refreshLocalSheet();
      return true;
    } catch (e) {
      state = AsyncValue.data(SheetState(error: e.toString()));
      return false;
    }
  }

  Future<Map<String, dynamic>> validateRowReorder({
    required String sheetId,
    required List<Map<String, dynamic>> rowMappings,
  }) async {
    try {
      return await _kahonRepository.validateRowReorder(
        sheetId: sheetId,
        rowMappings: rowMappings,
      );
    } catch (e) {
      return {
        'valid': false,
        'errors': [e.toString()],
      };
    }
  }
}
