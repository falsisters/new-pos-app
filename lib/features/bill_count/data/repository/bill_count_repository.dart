import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_count_model.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/create_bill_count_request_model.dart';

class BillCountRepository {
  final DioClient _dio = DioClient();

  // Helper method to safely parse response data
  Map<String, dynamic>? _parseResponseData(dynamic responseData) {
    if (responseData == null) {
      return null;
    }

    // If it's already a Map, return it
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }

    // If it's a string, try to parse it as JSON
    if (responseData is String) {
      try {
        final decoded = jsonDecode(responseData);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        print("Decoded JSON is not a Map: $decoded (${decoded.runtimeType})");
        return null;
      } catch (e) {
        print("Failed to parse string response as JSON: $e");
        print("Raw string response: $responseData");
        return null;
      }
    }

    print("Unexpected response type: ${responseData.runtimeType}");
    print("Response data: $responseData");
    return null;
  }

  // Get bill count for specific date (or today if date is null)
  Future<BillCountModel?> getBillCountForDate({String? date}) async {
    try {
      final queryParams = date != null ? {'date': date} : null;
      print("Getting bill count with date parameter: $queryParams");

      // Use the /bills endpoint for cashier
      final response =
          await _dio.instance.get('/bills', queryParameters: queryParams);

      print("Raw API Response: ${response.data}");
      print("Response type: ${response.data.runtimeType}");
      print("Response status: ${response.statusCode}");

      final parsedData = _parseResponseData(response.data);

      if (parsedData == null) {
        print("No valid data returned from API");
        return null;
      }

      print("Parsed API Response: $parsedData");
      return BillCountModel.fromJson(parsedData);
    } catch (e) {
      print("Error in getBillCountForDate: $e");
      if (e is DioException) {
        print("DioException status code: ${e.response?.statusCode}");
        print("DioException response data: ${e.response?.data}");
        print("DioException response type: ${e.response?.data.runtimeType}");

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

      print("Create/Update Response: ${response.data}");
      print("Create/Update Response type: ${response.data.runtimeType}");

      final parsedData = _parseResponseData(response.data);

      if (parsedData == null) {
        throw Exception(
            'Failed to create or update bill count - invalid response format');
      }

      print("Created bill count: $parsedData");
      return BillCountModel.fromJson(parsedData);
    } catch (e) {
      print("Error in createOrUpdateBillCount: $e");
      if (e is DioException) {
        print("DioException details: ${e.response?.data}");
        print("DioException response type: ${e.response?.data.runtimeType}");
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

      // Use the /bills/:id endpoint for cashiers
      final response = await _dio.instance.put('/bills/$id', data: data);

      print("Update Response: ${response.data}");
      print("Update Response type: ${response.data.runtimeType}");

      final parsedData = _parseResponseData(response.data);

      if (parsedData == null) {
        throw Exception(
            'Failed to update bill count - invalid response format');
      }

      print("Updated bill count response: $parsedData");
      final updatedBillCount = BillCountModel.fromJson(parsedData);
      print("Parsed bill count model: ${updatedBillCount.billsByType}");

      return updatedBillCount;
    } catch (e) {
      print("Error in updateBillCount: $e");
      if (e is DioException) {
        print("DioException details: ${e.response?.data}");
        print("DioException response type: ${e.response?.data.runtimeType}");
        throw Exception('API error: ${e.message}');
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  // Get specific bill count by ID
  Future<BillCountModel> getBillCountById(String id) async {
    try {
      // Use the /bills/:id endpoint for cashiers
      final response = await _dio.instance.get('/bills/$id');

      print("Get by ID Response: ${response.data}");
      print("Get by ID Response type: ${response.data.runtimeType}");

      final parsedData = _parseResponseData(response.data);

      if (parsedData == null) {
        throw Exception('Bill count not found - invalid response format');
      }

      return BillCountModel.fromJson(parsedData);
    } catch (e) {
      print("Error in getBillCountById: $e");
      if (e is DioException) {
        print("DioException details: ${e.response?.data}");
        print("DioException response type: ${e.response?.data.runtimeType}");
        throw Exception('API error: ${e.message}');
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
