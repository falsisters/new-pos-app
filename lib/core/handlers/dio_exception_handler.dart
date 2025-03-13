import 'package:dio/dio.dart';

String parseDioError(DioException e) {
  String errorMessage = 'An unexpected error occurred';

  if (e.response?.statusCode == 401) {
    errorMessage = 'Invalid credentials';
    final errorData = e.response?.data;

    if (errorData != null && errorData['message'] != null) {
      if (errorData['message'] is List) {
        errorMessage = errorData['message'][0]?.toString() ?? errorMessage;
      } else if (errorData['message'] is String) {
        errorMessage = errorData['message'];
      }
    }
  }

  return errorMessage;
}
