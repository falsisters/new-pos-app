import 'package:falsisters_pos_android/features/inventory/data/models/expenses_state.dart';
import 'package:falsisters_pos_android/features/inventory/data/repository/inventory_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesNotifier extends AsyncNotifier<ExpensesState> {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  @override
  Future<ExpensesState> build() async {
    try {
      final expensesData =
          await _inventoryRepository.getExpensesByDate(null, null);
      return ExpensesState(sheet: expensesData);
    } catch (e) {
      return ExpensesState(error: e.toString());
    }
  }

  Future<void> getExpensesByDate(DateTime? startDate, DateTime? endDate) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final inventoryData =
            await _inventoryRepository.getExpensesByDate(startDate, endDate);
        return ExpensesState(sheet: inventoryData);
      } catch (e) {
        return ExpensesState(error: e.toString());
      }
    });
  }

  Future<void> createInventoryRow(String inventoryId, int rowIndex) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _inventoryRepository.createInventoryRow(inventoryId, rowIndex);
        final updatedInventory =
            await _inventoryRepository.getInventoryByDate(null, null);
        return ExpensesState(sheet: updatedInventory);
      } catch (e) {
        return ExpensesState(error: e.toString());
      }
    });
  }

  Future<void> createInventoryRows(String sheetId, List<int> rowIndexes) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _inventoryRepository.createInventoryRows(sheetId, rowIndexes);
        final updatedInventory =
            await _inventoryRepository.getInventoryByDate(null, null);
        return ExpensesState(sheet: updatedInventory);
      } catch (e) {
        return ExpensesState(error: e.toString());
      }
    });
  }

  Future<void> deleteRow(String rowId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _inventoryRepository.deleteRow(rowId);
        final updatedInventory =
            await _inventoryRepository.getInventoryByDate(null, null);
        return ExpensesState(sheet: updatedInventory);
      } catch (e) {
        return ExpensesState(error: e.toString());
      }
    });
  }

  Future<void> createCell(String rowId, int columnIndex, String value,
      String? color, String? formula) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _inventoryRepository.createCell(
            rowId, columnIndex, value, color, formula);
        final updatedInventory =
            await _inventoryRepository.getInventoryByDate(null, null);
        return ExpensesState(sheet: updatedInventory);
      } catch (e) {
        return ExpensesState(error: e.toString());
      }
    });
  }

  Future<void> updateCell(
      String cellId, String value, String? color, String? formula) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _inventoryRepository.updateCell(cellId, value, color, formula);
        final updatedInventory =
            await _inventoryRepository.getInventoryByDate(null, null);
        return ExpensesState(sheet: updatedInventory);
      } catch (e) {
        return ExpensesState(error: e.toString());
      }
    });
  }

  Future<void> deleteCell(String cellId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _inventoryRepository.deleteCell(cellId);
        final updatedInventory =
            await _inventoryRepository.getInventoryByDate(null, null);
        return ExpensesState(sheet: updatedInventory);
      } catch (e) {
        return ExpensesState(error: e.toString());
      }
    });
  }

  Future<void> updateCells(List<Map<String, dynamic>> cells) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _inventoryRepository.updateCells(cells);
        final updatedInventory =
            await _inventoryRepository.getInventoryByDate(null, null);
        return ExpensesState(sheet: updatedInventory);
      } catch (e) {
        return ExpensesState(error: e.toString());
      }
    });
  }

  Future<void> createCells(List<Map<String, dynamic>> cells) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _inventoryRepository.createCells(cells);
        final updatedInventory =
            await _inventoryRepository.getInventoryByDate(null, null);
        return ExpensesState(sheet: updatedInventory);
      } catch (e) {
        return ExpensesState(error: e.toString());
      }
    });
  }
}
