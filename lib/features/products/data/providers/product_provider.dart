import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_state.dart';
import 'package:falsisters_pos_android/features/products/data/providers/product_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider =
    AsyncNotifierProvider<ProductNotifier, ProductState>(() {
  return ProductNotifier();
});

final productsProvider = Provider<List<Product>>((ref) {
  final asyncState = ref.watch(productProvider);

  return asyncState.when(
    data: (state) => state.products,
    loading: () {
      // During loading, try to return previous products if available
      final previousState = ref.read(productProvider).value;
      return previousState?.products ?? [];
    },
    error: (error, stack) {
      // On error, try to return previous products if available
      final previousState = ref.read(productProvider).value;
      return previousState?.products ?? [];
    },
  );
});
