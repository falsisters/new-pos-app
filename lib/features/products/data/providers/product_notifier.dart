import 'package:falsisters_pos_android/features/products/data/models/product_state.dart';
import 'package:falsisters_pos_android/features/products/data/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNotifier extends AsyncNotifier<ProductState> {
  final ProductRepository _productRepository = ProductRepository();

  @override
  Future<ProductState> build() async {
    final products = await _productRepository.getProducts();

    // Preload images after getting products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadProductImages(products);
    });

    return ProductState(
      products: products,
    );
  }

  Future<ProductState> getProducts() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final products = await _productRepository.getProducts();

        // Preload images after getting products
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _preloadProductImages(products);
        });

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

  void _preloadProductImages(List<dynamic> products) {
    for (final product in products) {
      if (product.picture != null && product.picture.isNotEmpty) {
        try {
          // Preload image into Flutter's image cache
          final imageProvider = NetworkImage(product.picture);
          imageProvider.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener((ImageInfo info, bool synchronousCall) {
              // Image is now cached
            }),
          );
        } catch (e) {
          // Ignore errors for individual image preloading
          print('Failed to preload image: ${product.picture}');
        }
      }
    }
  }
}
