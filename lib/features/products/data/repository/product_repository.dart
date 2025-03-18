import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';

class ProductRepository {
  final DioClient _dio = DioClient();

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.instance.get('/product/cashier');

      if (response.data == null) {
        return [];
      }

      return (response.data as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
