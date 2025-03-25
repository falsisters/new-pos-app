import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/edit_per_kilo_price_request.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/edit_sack_price_request_model.dart';

class StockRepository {
  final DioClient _dio = DioClient();

  Future<Map<String, dynamic>> editSackPrice(
      EditSackPriceRequestModel product) async {
    try {
      final productData = jsonEncode(product.toJson());

      final response = await _dio.instance
          .post('/product/edit-sack-price', data: productData);

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

  Future<Map<String, dynamic>> editPerKiloPrice(
      EditPerKiloPriceRequest product) async {
    try {
      final productData = jsonEncode(product.toJson());

      final response = await _dio.instance
          .post('/product/edit-per-kilo-price', data: productData);

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
}
