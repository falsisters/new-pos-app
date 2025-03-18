import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_state.dart';
import 'package:falsisters_pos_android/features/products/data/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNotifier extends AsyncNotifier<ProductState> {
  final ProductRepository _productRepository = ProductRepository();

  @override
  Future<ProductState> build() async {
    final products = await _productRepository.getProducts();

    return ProductState(
      products: products,
    );
  }

  Future<List<Product>> getProducts() async {
    return await _productRepository.getProducts();
  }
}
