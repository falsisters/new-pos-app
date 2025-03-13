// Create the dioClient class for me so I can use this globally when I am using dio, with the following features:
// Have an interceptor to insert my Bearer Authentication token in the header
// Have an interceptor to log all requests and responses

import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/secure_storage.dart';

class DioClient {
  static final DioClient _singleton = DioClient._internal();
  static late Dio _dio;
  final SecureStorage _secureStorage = SecureStorage();

  factory DioClient() {
    return _singleton;
  }

  DioClient._internal() {
    _dio = Dio();
    // Add Bearer token to the header
    _dio.interceptors.add(InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
      handler.next(e);
    }, onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      final token = _secureStorage.getToken();
      options.headers['Authorization'] = 'Bearer $token';
    }));
  }

  Dio get instance => _dio;
}
