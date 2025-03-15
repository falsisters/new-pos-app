import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static final DioClient _singleton = DioClient._internal();
  static late Dio _dio;
  final SecureStorage _secureStorage = SecureStorage();

  factory DioClient() {
    return _singleton;
  }

  DioClient._internal() {
    _dio = Dio();

    // Ensure API_URL exists before setting it
    final apiUrl = dotenv.env['API_URL'];
    if (apiUrl != null && apiUrl.isNotEmpty) {
      _dio.options.baseUrl = apiUrl;
    } else {
      print('Warning: API_URL not found in .env file');
    }

    // Add logging interceptor
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    // Add Bearer token to the header
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // The key issue: getToken() is async but you're not awaiting it
        final token = await _secureStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle 401 unauthorized errors by clearing the token
        if (e.response?.statusCode == 401) {
          _secureStorage.deleteToken();
        }
        handler.next(e);
      },
    ));
  }

  Dio get instance => _dio;
}
