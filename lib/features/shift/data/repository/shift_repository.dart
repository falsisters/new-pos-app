import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/shift/data/model/create_shift_request_model.dart';
import 'package:falsisters_pos_android/features/shift/data/model/employee_model.dart';
import 'package:falsisters_pos_android/features/shift/data/model/shift_model.dart';

class ShiftRepository {
  final DioClient _dio = DioClient();

  Future<List<ShiftModel>> getShifts() async {
    try {
      final response = await _dio.instance.get('/shift/cashier');

      if (response.data == null) {
        return [];
      }

      return (response.data as List)
          .map((shift) => ShiftModel.fromJson(shift))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<void> endShift(String shiftId) async {
    try {
      await _dio.instance.post('/shift/end/$shiftId');
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<List<EmployeeModel>> getEmployees() async {
    try {
      final response = await _dio.instance.get('/employee/cashier');

      if (response.data == null) {
        return [];
      }

      return (response.data as List)
          .map((employee) => EmployeeModel.fromJson(employee))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<ShiftModel> createShift(CreateShiftRequestModel shift) async {
    try {
      final requestData = shift.toJson();
      final response = await _dio.instance.post('/shift/create', data: {
        'employees':
            requestData['employees'].map((employee) => employee).toList()
      });

      return ShiftModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<ShiftModel> editShift(
      String shiftId, CreateShiftRequestModel shift) async {
    try {
      final requestData = shift.toJson();
      final response = await _dio.instance.patch('/shift/$shiftId', data: {
        'employees':
            requestData['employees'].map((employee) => employee).toList()
      });

      return ShiftModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
