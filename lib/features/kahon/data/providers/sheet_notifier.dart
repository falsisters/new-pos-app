import 'package:falsisters_pos_android/features/kahon/data/models/sheet_state.dart';
import 'package:falsisters_pos_android/features/kahon/data/repository/kahon_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SheetNotifier extends AsyncNotifier<SheetState> {
  final KahonRepository _kahonRepository = KahonRepository();

  @override
  Future<SheetState> build() async {
    try {
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
        final sheetData =
            await _kahonRepository.getSheetByDate(startDate, endDate);
        return SheetState(sheet: sheetData);
      } catch (e) {
        return SheetState(error: e.toString());
      }
    });
  }

  Future<void> createCalculationRow(String sheetId, int rowIndex) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _kahonRepository.createCalculationRow(sheetId, rowIndex);
        final updatedSheet = await _kahonRepository.getSheetByDate(null, null);
        return SheetState(sheet: updatedSheet);
      } catch (e) {
        return SheetState(error: e.toString());
      }
    });
  }

  Future<void> deleteRow(String rowId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _kahonRepository.deleteRow(rowId);
        final updatedSheet = await _kahonRepository.getSheetByDate(null, null);
        return SheetState(sheet: updatedSheet);
      } catch (e) {
        return SheetState(error: e.toString());
      }
    });
  }

  Future<void> createCell(
      String rowId, int columnIndex, String value, String? formula) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _kahonRepository.createCell(rowId, columnIndex, value, formula);
        final updatedSheet = await _kahonRepository.getSheetByDate(null, null);
        return SheetState(sheet: updatedSheet);
      } catch (e) {
        return SheetState(error: e.toString());
      }
    });
  }

  Future<void> updateCell(String cellId, String value, String? formula) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _kahonRepository.updateCell(cellId, value, formula);
        final updatedSheet = await _kahonRepository.getSheetByDate(null, null);
        return SheetState(sheet: updatedSheet);
      } catch (e) {
        return SheetState(error: e.toString());
      }
    });
  }

  Future<void> deleteCell(String cellId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _kahonRepository.deleteCell(cellId);
        final updatedSheet = await _kahonRepository.getSheetByDate(null, null);
        return SheetState(sheet: updatedSheet);
      } catch (e) {
        return SheetState(error: e.toString());
      }
    });
  }

  Future<void> updateCells(List<Map<String, dynamic>> cells) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _kahonRepository.updateCells(cells);
        final updatedSheet = await _kahonRepository.getSheetByDate(null, null);
        return SheetState(sheet: updatedSheet);
      } catch (e) {
        return SheetState(error: e.toString());
      }
    });
  }
}
