import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/edit_per_kilo_price_request.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/edit_sack_price_request_model.dart';

class StockRepository {
  final DioClient _dio = DioClient();

  Future<Map<String, dynamic>> editSackPrice(
      String id, EditSackPriceRequestModel product) async {
    try {
      // Create FormData
      FormData formData = FormData.fromMap({
        'sackPrice': jsonEncode(product.sackPrice).toString(),
      });

      print(formData.fields);

      final response =
          await _dio.instance.patch('/product/$id', data: formData);

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
      String id, EditPerKiloPriceRequest product) async {
    try {
      // Create FormData
      FormData formData = FormData.fromMap({
        'perKiloPrice': jsonEncode(product.perKiloPrice).toString(),
      });

      print(formData.fields);

      final response =
          await _dio.instance.patch('/product/$id', data: formData);

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
