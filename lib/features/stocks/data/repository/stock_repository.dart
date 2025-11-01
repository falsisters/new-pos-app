import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/edit_per_kilo_price_request.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/edit_sack_price_request_model.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/transfer_model.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/transfer_product_request.dart';

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

  Future<List<TransferModel>> getTransfers({DateTime? date}) async {
    try {
      String endpoint = '/transfer/cashier';

      // Add date query parameter if provided
      if (date != null) {
        final dateString =
            date.toIso8601String().split('T')[0]; // Format as YYYY-MM-DD
        endpoint = '/transfer/cashier/date?date=$dateString';
      }

      final response = await _dio.instance.get(endpoint);

      if (response.data == null) {
        return [];
      }

      return (response.data as List)
          .map((transfer) => TransferModel.fromJson(transfer))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Map<String, dynamic>> transferStock(
      TransferProductRequest request) async {
    try {
      // Just pass the toJson result directly without additional encoding
      print(jsonEncode(request.toJson()));
      print(jsonEncode(request.toJson()));
      print(jsonEncode(request.toJson()));
      print(jsonEncode(request.toJson()));

      final response =
          await _dio.instance.post('/transfer/product', data: request.toJson());

      print(request.toJson());

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

  Future<Map<String, dynamic>> getStockStatistics({DateTime? date}) async {
    try {
      String endpoint = '/stock/statistics/cashier';

      // Add date query parameter if provided
      if (date != null) {
        final dateString =
            date.toIso8601String().split('T')[0]; // Format as YYYY-MM-DD
        endpoint = '/stock/statistics/cashier?date=$dateString';
      }

      final response = await _dio.instance.get(endpoint);

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
