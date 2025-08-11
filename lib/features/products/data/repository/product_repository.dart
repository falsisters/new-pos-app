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

      final List<dynamic> productsData = response.data as List;
      final List<Product> products = [];

      for (final productData in productsData) {
        try {
          final product = Product.fromJson(productData as Map<String, dynamic>);
          products.add(product);
        } catch (e) {
          // Log individual product parsing errors but continue with others
          print('Failed to parse product: $productData, Error: $e');
        }
      }

      return products;
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      final response = await _dio.instance.get('/product/$id');

      if (response.data == null) {
        return null;
      }

      return Product.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return null;
        }
        throw Exception('Network error: ${e.message}');
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
