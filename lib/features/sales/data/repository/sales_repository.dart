import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';

class SalesRepository {
  final DioClient _dio = DioClient();

  Future<Map<String, dynamic>> createSale(CreateSaleRequestModel sale) async {
    try {
      final saleData = jsonEncode(sale.toJson());
      final response = await _dio.instance.post('/sale/create', data: saleData);

      if (response.data == null) {
        return {};
      }

      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<List<SaleModel>> getSales() async {
    try {
      final response = await _dio.instance.get('/sale/recent');

      if (response.data == null) {
        return [];
      }

      return (response.data as List)
          .map((sale) => SaleModel.fromJson(sale))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<List<SaleModel>> editSale(
      String id, CreateSaleRequestModel sale) async {
    try {
      final saleData = jsonEncode(sale.toJson());
      final response = await _dio.instance.put('/sale/$id', data: saleData);

      if (response.data == null) {
        return [];
      }

      return (response.data as List)
          .map((sale) => SaleModel.fromJson(sale))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
