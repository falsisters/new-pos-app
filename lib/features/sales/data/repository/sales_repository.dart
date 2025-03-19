import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';

class SalesRepository {
  final DioClient _dio = DioClient();

  Future<Map<String, dynamic>> createSale(CreateSaleRequestModel sale) async {
    try {
      final saleData = sale.toJson();
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
}
