import 'package:falsisters_pos_android/features/inventory/data/models/inventory_state.dart';
import 'package:falsisters_pos_android/features/inventory/data/repository/inventory_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryNotifier extends AsyncNotifier<InventoryState> {
  final InventoryRepository _inventoryRepository = InventoryRepository();

  @override
  Future<InventoryState> build() async {
    try {
      final inventoryData =
          await _inventoryRepository.getInventoryByDate(null, null);
      return InventoryState(sheet: inventoryData);
    } catch (e) {
      return InventoryState(error: e.toString());
    }
  }

  Future<void> getInventoryByDate(
      DateTime? startDate, DateTime? endDate) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final inventoryData =
            await _inventoryRepository.getInventoryByDate(startDate, endDate);
        return InventoryState(sheet: inventoryData);
      } catch (e) {
        return InventoryState(error: e.toString());
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
        return InventoryState(sheet: updatedInventory);
      } catch (e) {
        return InventoryState(error: e.toString());
      }
    });
  }

  Future<void> createInventoryRows(
      String inventoryId, List<int> rowIndexes) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _inventoryRepository.createInventoryRows(inventoryId, rowIndexes);
        final updatedInventory =
            await _inventoryRepository.getInventoryByDate(null, null);
        return InventoryState(sheet: updatedInventory);
      } catch (e) {
        return InventoryState(error: e.toString());
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
        return InventoryState(sheet: updatedInventory);
      } catch (e) {
        return InventoryState(error: e.toString());
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
        return InventoryState(sheet: updatedInventory);
      } catch (e) {
        return InventoryState(error: e.toString());
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
        return InventoryState(sheet: updatedInventory);
      } catch (e) {
        return InventoryState(error: e.toString());
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
        return InventoryState(sheet: updatedInventory);
      } catch (e) {
        return InventoryState(error: e.toString());
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
        return InventoryState(sheet: updatedInventory);
      } catch (e) {
        return InventoryState(error: e.toString());
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
        return InventoryState(sheet: updatedInventory);
      } catch (e) {
        return InventoryState(error: e.toString());
      }
    });
  }

  Future<void> updateRowPosition(String rowId, int newRowIndex) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _inventoryRepository.updateRowPosition(rowId, newRowIndex);
        final updatedInventory =
            await _inventoryRepository.getInventoryByDate(null, null);
        return InventoryState(sheet: updatedInventory);
      } catch (e) {
        return InventoryState(error: e.toString());
      }
    });
  }

  Future<void> updateRowPositions(List<Map<String, dynamic>> updates) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _inventoryRepository.updateRowPositions(updates);
        final updatedInventory =
            await _inventoryRepository.getInventoryByDate(null, null);
        return InventoryState(sheet: updatedInventory);
      } catch (e) {
        return InventoryState(error: e.toString());
      }
    });
  }

  Future<Map<String, dynamic>> batchUpdateRowPositions(
      List<Map<String, dynamic>> mappings) async {
    try {
      return await _inventoryRepository.batchUpdateRowPositions(mappings);
    } catch (e) {
      throw Exception('Failed to batch update row positions: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> batchUpdateCellFormulas(
      List<Map<String, dynamic>> updates) async {
    try {
      return await _inventoryRepository.batchUpdateCellFormulas(updates);
    } catch (e) {
      throw Exception('Failed to batch update cell formulas: ${e.toString()}');
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
