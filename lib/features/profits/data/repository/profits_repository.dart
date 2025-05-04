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
        return ProfitResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load profits: Invalid response format');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load profits: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load profits: $e');
    }
  }
}
