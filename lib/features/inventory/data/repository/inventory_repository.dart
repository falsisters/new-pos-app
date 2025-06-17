import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_cell_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_row_model.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';

class InventoryRepository {
  final DioClient _dio = DioClient();

  Future<InventorySheetModel> getExpensesByDate(
      DateTime? startDate, DateTime? endDate) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.instance.get('/inventory/expenses/date',
          queryParameters: queryParams.isNotEmpty ? queryParams : null);

      return InventorySheetModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<InventorySheetModel> getInventoryByDate(
      DateTime? startDate, DateTime? endDate) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.instance.get('/inventory/date',
          queryParameters: queryParams.isNotEmpty ? queryParams : null);

      return InventorySheetModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<InventoryRowModel> createInventoryRow(
      String inventoryId, int rowIndex) async {
    try {
      final response =
          await _dio.instance.post('/inventory/calculation-row', data: {
        'inventoryId': inventoryId,
        'rowIndex': rowIndex,
      });

      return InventoryRowModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<List<InventoryRowModel>> createInventoryRows(
      String inventoryId, List<int> rowIndexes) async {
    try {
      final response =
          await _dio.instance.post('/inventory/calculation-rows', data: {
        'inventoryId': inventoryId,
        'rowIndexes': rowIndexes,
      });
      return (response.data as List)
          .map((row) => InventoryRowModel.fromJson(row))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<void> deleteRow(String rowId) async {
    try {
      await _dio.instance.delete('/inventory/row/$rowId');
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<InventoryCellModel> createCell(String rowId, int columnIndex,
      String value, String? color, String? formula) async {
    try {
      final response = await _dio.instance.post('/inventory/cell', data: {
        'rowId': rowId,
        'columnIndex': columnIndex,
        'value': value,
        'color': color,
        'formula': formula,
      });
      return InventoryCellModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<InventoryCellModel> updateCell(
      String cellId, String value, String? color, String? formula) async {
    try {
      final response =
          await _dio.instance.patch('/inventory/cell/$cellId', data: {
        'value': value,
        'color': color,
        'formula': formula,
      });

      return InventoryCellModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<void> deleteCell(String cellId) async {
    try {
      await _dio.instance.delete('/inventory/cell/$cellId');
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<List<InventoryCellModel>> updateCells(
      List<Map<String, dynamic>> cells) async {
    try {
      final response = await _dio.instance.patch('/inventory/cells', data: {
        'cells': cells
            .map((cell) => {
                  'id': cell['id'],
                  'value': cell['value'],
                  'color': cell['color'],
                  'formula': cell['formula'],
                })
            .toList()
      });
      return (response.data as List)
          .map((cell) => InventoryCellModel.fromJson(cell))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<List<InventoryCellModel>> createCells(
      List<Map<String, dynamic>> cells) async {
    try {
      final response = await _dio.instance.post('/inventory/cells', data: {
        'cells': cells
            .map((cell) => {
                  'rowId': cell['rowId'],
                  'columnIndex': cell['columnIndex'],
                  'color': cell['color'],
                  'value': cell['value'],
                  'formula': cell['formula'],
                })
            .toList()
      });
      return (response.data as List)
          .map((cell) => InventoryCellModel.fromJson(cell))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<void> updateRowPosition(String rowId, int newRowIndex) async {
    try {
      await _dio.instance.patch('/inventory/user/rows/positions', data: {
        'updates': [
          {
            'rowId': rowId,
            'newRowIndex': newRowIndex,
          }
        ]
      });
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<void> updateRowPositions(List<Map<String, dynamic>> updates) async {
    try {
      await _dio.instance
          .patch('/inventory/user/rows/positions', data: {'updates': updates});
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Map<String, dynamic>> batchUpdateRowPositions(
      List<Map<String, dynamic>> mappings) async {
    try {
      final response = await _dio.instance.patch(
          '/inventory/rows/positions/batch',
          data: {'mappings': mappings});
      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Map<String, dynamic>> batchUpdateCellFormulas(
      List<Map<String, dynamic>> updates) async {
    try {
      final response = await _dio.instance
          .patch('/inventory/cells/formulas/batch', data: {'updates': updates});
      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Map<String, dynamic>> validateRowMappings(
      String sheetId, List<Map<String, dynamic>> mappings) async {
    try {
      final response =
          await _dio.instance.post('/inventory/rows/validate', data: {
        'sheetId': sheetId,
        'mappings': mappings,
      });
      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
