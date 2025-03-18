import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_state.dart';
import 'package:falsisters_pos_android/features/products/data/providers/product_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider =
    AsyncNotifierProvider<ProductNotifier, ProductState>(() {
  return ProductNotifier();
});

final productsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productProvider).whenData((state) => state.products).value ??
      [];
});
