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

  Future<ProductState> getProducts() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final products = await _productRepository.getProducts();

        return ProductState(
          products: products,
        );
      } catch (e) {
        return ProductState(
          products: [],
          error: e.toString(),
        );
      }
    });

    return state.value!;
  }
}
