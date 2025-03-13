import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/core/handlers/dio_exception_handler.dart';

class AuthRepository {
  final DioClient _dio = DioClient();

  Future<void> login(String name, String accessKey) async {
    try {
      final response = await _dio.instance.post('/cashier/login', data: {
        'name': name,
        'accessKey': accessKey,
      });

      return response.data;
    } catch (e) {
      if (e is DioException) {
        final errorMessage = parseDioError(e);
        throw Exception(errorMessage);
      } else {
        throw Exception('An unexpected error occurred');
      }
    }
  }

  Future<void> getCashierInfo() async {
    try {
      final response = await _dio.instance.get('/cashier');
      return response.data;
    } catch (e) {
      if (e is DioException) {
        final errorMessage = parseDioError(e);
        throw Exception(errorMessage);
      } else {
        throw Exception('An unexpected error occurred');
      }
    }
  }
}
