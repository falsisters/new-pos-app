import 'package:falsisters_pos_android/core/database/providers/database_provider.dart';
import 'package:falsisters_pos_android/core/sync/sync_engine.dart';
import 'package:falsisters_pos_android/features/products/data/local/products_local_repository.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_state.dart';
import 'package:falsisters_pos_android/features/products/data/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNotifier extends AsyncNotifier<ProductState> {
  final ProductRepository _productRepository = ProductRepository();

  ProductsLocalRepository get _localRepo =>
      ProductsLocalRepository(ref.read(databaseProvider).requireValue);

  SyncEngine get _syncEngine => ref.read(syncEngineProvider);

  @override
  Future<ProductState> build() async {
    try {
      final localProducts = await _localRepo.getProducts();

      if (localProducts.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _preloadProductImages(localProducts);
        });
      }

      _syncEngine.pullAndMerge('products', '/product/cashier');

      return ProductState(products: localProducts);
    } catch (e) {
      return ProductState(products: [], error: e.toString());
    }
  }

  Future<ProductState> getProducts() async {
    final currentProducts = state.value?.products ?? [];

    state = await AsyncValue.guard(() async {
      try {
        final localProducts = await _localRepo.getProducts();

        if (localProducts.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _preloadProductImages(localProducts);
          });
        }

        _syncEngine.pullAndMerge('products', '/product/cashier');

        return ProductState(products: localProducts);
      } catch (e) {
        return ProductState(products: currentProducts, error: e.toString());
      }
    });

    return state.value!;
  }

  Future<void> refresh() async {
    final currentProducts = state.value?.products ?? [];

    state = await AsyncValue.guard(() async {
      try {
        final products = await _productRepository.getProducts();
        await _localRepo.clearAndUpsert(products);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _preloadProductImages(products);
        });

        return ProductState(products: products);
      } catch (e) {
        return ProductState(products: currentProducts, error: e.toString());
      }
    });
  }

  Future<Product?> getProductById(String id) async {
    try {
      final local = await _localRepo.getProductById(id);
      if (local != null) return local;

      final remote = await _productRepository.getProductById(id);
      if (remote != null) {
        await _localRepo.upsertProducts([remote]);
      }
      return remote;
    } catch (e) {
      final currentState = state.value ?? ProductState(products: []);
      state = AsyncValue.data(currentState.copyWith(error: e.toString()));
      rethrow;
    }
  }

  void _preloadProductImages(List<Product> products) {
    for (final product in products) {
      if (product.picture.isNotEmpty) {
        try {
          final imageProvider = NetworkImage(product.picture);
          imageProvider.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener((ImageInfo info, bool synchronousCall) {}),
          );
        } catch (e) {
          print('Failed to preload image: ${product.picture}');
        }
      }
    }
  }
}
