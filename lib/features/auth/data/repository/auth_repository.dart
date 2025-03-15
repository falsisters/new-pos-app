import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/core/handlers/dio_exception_handler.dart';
import 'package:falsisters_pos_android/core/handlers/secure_storage.dart';

class AuthRepository {
  final DioClient _dio = DioClient();
  final SecureStorage _secureStorage = SecureStorage();

  Future<Map<String, dynamic>> login(String name, String accessKey) async {
    try {
      final response = await _dio.instance.post('/cashier/login', data: {
        'name': name,
        'accessKey': accessKey,
      });

      // Extract and save token
      if (response.data != null && response.data['access_token'] != null) {
        await _secureStorage.saveToken(response.data['access_token']);
      }

      return response.data;
    } catch (e) {
      if (e is DioException) {
        final errorMessage = parseDioError(e);
        throw Exception(errorMessage);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Map<String, dynamic>> getCashierInfo() async {
    try {
      final response = await _dio.instance.get('/cashier');
      return response.data;
    } catch (e) {
      if (e is DioException) {
        final errorMessage = parseDioError(e);
        throw Exception(errorMessage);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
