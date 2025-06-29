import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/cell_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/row_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';

class KahonRepository {
  final DioClient _dio = DioClient();

  Future<SheetModel> getSheetByDate(
      DateTime? startDate, DateTime? endDate) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.instance.get('/sheet/date',
          queryParameters: queryParams.isNotEmpty ? queryParams : null);

      return SheetModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<RowModel> createCalculationRow(String sheetId, int rowIndex) async {
    try {
      final response =
          await _dio.instance.post('/sheet/calculation-row', data: {
        'sheetId': sheetId,
        'rowIndex': rowIndex,
      });
      return RowModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<List<RowModel>> createCalculationRows(
      String sheetId, List<int> rowIndexes) async {
    try {
      final response =
          await _dio.instance.post('/sheet/calculation-rows', data: {
        'sheetId': sheetId,
        'rowIndexes': rowIndexes,
      });
      return (response.data as List)
          .map((row) => RowModel.fromJson(row))
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
      await _dio.instance.delete('/sheet/row/$rowId');
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<CellModel> createCell(String rowId, int columnIndex, String value,
      String? color, String? formula) async {
    try {
      final response = await _dio.instance.post('/sheet/cell', data: {
        'rowId': rowId,
        'columnIndex': columnIndex,
        'color': color,
        'value': value,
        'formula': formula,
      });
      return CellModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<CellModel> updateCell(
      String cellId, String value, String? color, String? formula) async {
    try {
      final response = await _dio.instance.patch('/sheet/cell/$cellId', data: {
        'value': value,
        'color': color,
        'formula': formula,
      });
      return CellModel.fromJson(response.data);
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
      await _dio.instance.delete('/sheet/cell/$cellId');
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<List<CellModel>> updateCells(List<Map<String, dynamic>> cells) async {
    try {
      final response = await _dio.instance.patch('/sheet/cells', data: {
        'cells': cells
            .map((cell) => {
                  'id': cell['id'],
                  'value': cell['value'],
                  'color': cell['color'],
                  'formula': cell['formula'],
                })
            .toList(),
      });
      return (response.data as List)
          .map((cell) => CellModel.fromJson(cell))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<List<CellModel>> createCells(List<Map<String, dynamic>> cells) async {
    try {
      final response = await _dio.instance.post('/sheet/cells', data: {
        'cells': cells
            .map((cell) => {
                  'rowId': cell['rowId'],
                  'columnIndex': cell['columnIndex'],
                  'color': cell['color'],
                  'value': cell['value'],
                  'formula': cell['formula'],
                })
            .toList(),
      });
      return (response.data as List)
          .map((cell) => CellModel.fromJson(cell))
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
      await _dio.instance.patch('/sheet/user/rows/positions', data: {
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
          .patch('/sheet/user/rows/positions', data: {'updates': updates});
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Map<String, dynamic>> batchUpdateRowPositions(
      List<Map<String, dynamic>> updates) async {
    try {
      final response = await _dio.instance
          .patch('/sheet/rows/positions/batch', data: {'updates': updates});
      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Map<String, dynamic>> batchUpdateCellsWithFormulas({
    required List<Map<String, dynamic>> cellUpdates,
    required List<Map<String, dynamic>> rowMappings,
  }) async {
    try {
      final response =
          await _dio.instance.patch('/sheet/cells/formulas/batch', data: {
        'cellUpdates': cellUpdates,
        'rowMappings': rowMappings,
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

  Future<Map<String, dynamic>> comprehensiveRowReorder({
    required String sheetId,
    required List<Map<String, dynamic>> rowReorders,
    required List<Map<String, dynamic>> affectedFormulas,
  }) async {
    try {
      final response =
          await _dio.instance.post('/sheet/reorder/comprehensive', data: {
        'sheetId': sheetId,
        'rowReorders': rowReorders,
        'affectedFormulas': affectedFormulas,
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

  Future<Map<String, dynamic>> enhancedRowReorder({
    required String sheetId,
    required List<Map<String, dynamic>> rowMappings,
    required List<Map<String, dynamic>> formulaUpdates,
  }) async {
    try {
      final response =
          await _dio.instance.post('/sheet/reorder/comprehensive', data: {
        'sheetId': sheetId,
        'rowReorders': rowMappings,
        'affectedFormulas': formulaUpdates,
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

  Future<Map<String, dynamic>> validateRowReorder({
    required String sheetId,
    required List<Map<String, dynamic>> rowMappings,
  }) async {
    try {
      final response =
          await _dio.instance.post('/sheet/reorder/validate', data: {
        'sheetId': sheetId,
        'rowMappings': rowMappings,
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
