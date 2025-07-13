import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/core/utils/api_response_handler.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';

class SalesRepository {
  final DioClient _dio = DioClient();

  Future<SaleModel> createSale(CreateSaleRequestModel sale) async {
    try {
      final saleData = jsonEncode(sale.toJson());
      final response = await _dio.instance.post('/sale/create', data: saleData);

      if (response.data == null) {
        throw Exception('Failed to create sale: No data in response');
      }

      return SaleModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<List<SaleModel>> getSales({DateTime? date}) async {
    try {
      String endpoint = '/sale/recent/cashier';

      // Add date query parameter if provided
      if (date != null) {
        final dateString =
            date.toIso8601String().split('T')[0]; // Format as YYYY-MM-DD
        endpoint += '?date=$dateString';
      }

      final response = await _dio.instance.get(endpoint);

      print('Response Type: ${response.data.runtimeType}');
      print('Response Text:');
      print(response.data);

      // Use our utility function to handle the response consistently
      return ApiResponseHandler.parseList(response.data, SaleModel.fromJson);
    } catch (e) {
      print('Error fetching sales: $e');
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<SaleModel> deleteSale(String id) async {
    try {
      final response = await _dio.instance.delete('/sale/$id');

      print('Delete Sale Response: ${response.data.runtimeType}');
      print('Delete Sale Response data: ${response.data}');

      // Use our utility function to handle the response consistently
      // Assuming delete returns the deleted item or a success message,
      // but the original code expected a list. If API returns single object:
      if (response.data is Map<String, dynamic>) {
        return SaleModel.fromJson(response.data);
      }
      // If API returns a list (even if one item), keep original:
      return ApiResponseHandler.parseList(response.data, SaleModel.fromJson)
          .first;
    } catch (e) {
      print('Error deleting sale: $e');
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
