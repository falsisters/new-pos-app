import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/grouped_sales_check_item.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/sales_check_filter_dto.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/total_sales_check.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/total_sales_filter_dto.dart';

class SalesCheckRepository {
  final DioClient _dio = DioClient();

  Future<List<GroupedSalesCheckItem>> getGroupedSales(
      SalesCheckFilterDto filters) async {
    try {
      final response = await _dio.instance.get(
        '/sales-check/cashier',
        queryParameters: filters.toJson(),
      );

      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> dataList = response.data;
        return dataList
            .map((json) =>
                GroupedSalesCheckItem.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Failed to load grouped sales: Invalid response format');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load grouped sales: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load grouped sales: $e');
    }
  }

  Future<TotalSalesCheck> getTotalSales(TotalSalesFilterDto filters) async {
    try {
      final response = await _dio.instance.get(
        '/sales-check/cashier/total',
        queryParameters: filters.toJson(),
      );

      if (response.statusCode == 200 && response.data is Map) {
        return TotalSalesCheck.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load total sales: Invalid response format');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load total sales: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load total sales: $e');
    }
  }
}
