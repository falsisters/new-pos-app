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
      print("Getting bill count with date parameter: $queryParams");

      // Use the /bills endpoint for cashier (not /bills/user)
      final response =
          await _dio.instance.get('/bills', queryParameters: queryParams);

      if (response.data == null) {
        print("No data returned from API");
        return null;
      }

      print("API Response: ${response.data}");
      return BillCountModel.fromJson(response.data);
    } catch (e) {
      print("Error in getBillCountForDate: $e");
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return null; // No bill count exists for this date
        }
        throw Exception(e.message ?? "API error occurred");
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
      print("Creating bill count with data: $data");

      // Use the /bills endpoint for cashiers
      final response = await _dio.instance.post('/bills', data: data);

      if (response.data == null) {
        throw Exception('Failed to create or update bill count');
      }

      print("Created bill count: ${response.data}");
      return BillCountModel.fromJson(response.data);
    } catch (e) {
      print("Error in createOrUpdateBillCount: $e");
      if (e is DioException) {
        print("DioException details: ${e.response?.data}");
        throw Exception('API error: ${e.message}');
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
      print("Updating bill count with ID: $id");
      print("Bills being sent in update: " +
          billCount.bills!.map((b) => '${b.type.name}:${b.amount}').join(', '));
      print("Starting amount being sent: ${billCount.startingAmount}");
      print("Update payload: $data");

      // Use the /bills/:id endpoint
      final response = await _dio.instance.put('/bills/$id', data: data);

      if (response.data == null) {
        throw Exception('Failed to update bill count');
      }

      print("Updated bill count response: ${response.data}");
      final updatedBillCount = BillCountModel.fromJson(response.data);
      print("Parsed bill count model: ${updatedBillCount.billsByType}");

      return updatedBillCount;
    } catch (e) {
      print("Error in updateBillCount: $e");
      if (e is DioException) {
        print("DioException details: ${e.response?.data}");
        throw Exception('API error: ${e.message}');
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  // Get specific bill count by ID
  Future<BillCountModel> getBillCountById(String id) async {
    try {
      // Use the /bills/:id endpoint (not /bills/user/:id)
      final response = await _dio.instance.get('/bills/$id');

      if (response.data == null) {
        throw Exception('Bill count not found');
      }

      return BillCountModel.fromJson(response.data);
    } catch (e) {
      print("Error in getBillCountById: $e");
      if (e is DioException) {
        throw Exception('API error: ${e.message}');
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
