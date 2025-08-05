import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/profits/data/model/profit_filter_dto.dart';
import 'package:falsisters_pos_android/features/profits/data/model/profit_response.dart';

class ProfitsRepository {
  final DioClient _dio = DioClient();

  Future<ProfitResponse> getProfits(ProfitFilterDto filters) async {
    try {
      final response = await _dio.instance.get(
        '/profit/cashier',
        queryParameters: filters.toJson(),
      );

      if (response.statusCode == 200 && response.data is Map) {
        // Validate that the response contains the expected structure for Decimal parsing
        final data = response.data as Map<String, dynamic>;

        // Ensure numeric fields are strings for proper Decimal parsing
        _validateAndConvertNumericFields(data);

        return ProfitResponse.fromJson(data);
      } else {
        throw Exception('Failed to load profits: Invalid response format');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load profits: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load profits: $e');
    }
  }

  void _validateAndConvertNumericFields(Map<String, dynamic> data) {
    // Convert overallTotal to string if it's a number
    if (data['overallTotal'] is num) {
      data['overallTotal'] = data['overallTotal'].toString();
    }

    // Convert sacks.totalProfit
    if (data['sacks']?['totalProfit'] is num) {
      data['sacks']['totalProfit'] = data['sacks']['totalProfit'].toString();
    }

    // Convert asin.totalProfit
    if (data['asin']?['totalProfit'] is num) {
      data['asin']['totalProfit'] = data['asin']['totalProfit'].toString();
    }

    // Convert numeric fields in sacks.items
    if (data['sacks']?['items'] is List) {
      for (var item in data['sacks']['items']) {
        _convertItemNumericFields(item);
      }
    }

    // Convert numeric fields in asin.items
    if (data['asin']?['items'] is List) {
      for (var item in data['asin']['items']) {
        _convertItemNumericFields(item);
      }
    }

    // Convert numeric fields in rawItems
    if (data['rawItems'] is List) {
      for (var item in data['rawItems']) {
        _convertRawItemNumericFields(item);
      }
    }
  }

  void _convertItemNumericFields(Map<String, dynamic> item) {
    if (item['profitPerUnit'] is num) {
      item['profitPerUnit'] = item['profitPerUnit'].toString();
    }
    if (item['totalQuantity'] is num) {
      item['totalQuantity'] = item['totalQuantity'].toString();
    }
    if (item['totalProfit'] is num) {
      item['totalProfit'] = item['totalProfit'].toString();
    }
  }

  void _convertRawItemNumericFields(Map<String, dynamic> item) {
    if (item['quantity'] is num) {
      item['quantity'] = item['quantity'].toString();
    }
    if (item['profitPerUnit'] is num) {
      item['profitPerUnit'] = item['profitPerUnit'].toString();
    }
    if (item['totalProfit'] is num) {
      item['totalProfit'] = item['totalProfit'].toString();
    }
  }
}
