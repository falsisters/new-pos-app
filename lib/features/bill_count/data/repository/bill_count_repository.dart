import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_count_model.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/create_bill_count_request_model.dart';

class BillCountRepository {
  final DioClient _dio = DioClient();

  // Get bill count for specific date (or today if date is null)
  Future<BillCountModel?> getBillCountForDate({String? date}) async {
    try {
      final queryParams = date != null ? {'date': date} : null;
      final response =
          await _dio.instance.get('/bills', queryParameters: queryParams);

      if (response.data == null) {
        return null;
      }

      return BillCountModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return null; // No bill count exists for this date
        }
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  // Create or update bill count
  Future<BillCountModel> createOrUpdateBillCount(
      CreateBillCountRequestModel billCount) async {
    try {
      final data = jsonEncode(billCount.toJson());
      final response = await _dio.instance.post('/bills', data: data);

      if (response.data == null) {
        throw Exception('Failed to create or update bill count');
      }

      return BillCountModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  // Update existing bill count by ID
  Future<BillCountModel> updateBillCount(
      String id, CreateBillCountRequestModel billCount) async {
    try {
      final data = jsonEncode(billCount.toJson());
      final response = await _dio.instance.put('/bills/$id', data: data);

      if (response.data == null) {
        throw Exception('Failed to update bill count');
      }

      return BillCountModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  // Get specific bill count by ID
  Future<BillCountModel> getBillCountById(String id) async {
    try {
      final response = await _dio.instance.get('/bills/$id');

      if (response.data == null) {
        throw Exception('Bill count not found');
      }

      return BillCountModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
