import 'dart:async';

import 'package:falsisters_pos_android/features/products/data/providers/product_provider.dart';
import 'package:falsisters_pos_android/features/sales/data/model/cart_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sales_state.dart';
import 'package:falsisters_pos_android/features/sales/data/repository/sales_repository.dart';
import 'package:falsisters_pos_android/features/sales_check/data/providers/sales_check_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/features/sales/data/services/sales_queue_service.dart';

class SalesNotifier extends AsyncNotifier<SalesState> {
  final SalesRepository _salesRepository = SalesRepository();
  late SalesQueueService _queueService;
  StreamSubscription? _queueSubscription;
  StreamSubscription? _processedSaleSubscription;

  @override
  Future<SalesState> build() async {
    _queueService = ref.read(salesQueueServiceProvider);
    _setupQueueListener();
    _setupProcessedSaleListener();

    try {
      final today = DateTime.now();
      final sales = await _salesRepository.getSales(date: today);
      return SalesState(
        cart: CartModel(),
        sales: sales,
        pendingSales: _queueService.currentQueue,
        orderId: null,
        selectedDate: today,
      );
    } catch (e) {
      print('Error in SalesNotifier.build: $e');
      return SalesState(
        cart: CartModel(),
        sales: [],
        pendingSales: _queueService.currentQueue,
        orderId: null,
        selectedDate: DateTime.now(),
      );
    }
  }

  void _setupQueueListener() {
    _queueSubscription = _queueService.queueStream.listen((pendingSales) {
      final currentState = state.value;
      if (currentState != null) {
        state =
            AsyncValue.data(currentState.copyWith(pendingSales: pendingSales));
      }
    });
  }

  void _setupProcessedSaleListener() {
    _processedSaleSubscription =
        _queueService.processedSaleStream.listen((processedSale) {
      final currentState = state.value;
      if (currentState != null) {
        // Add the new sale to the list and set it as the one to be printed
        final updatedSales = [processedSale, ...currentState.sales];
        state = AsyncValue.data(currentState.copyWith(
          sales: updatedSales,
          saleToPrint: processedSale,
        ));
      }
    });
  }

  // @override
  // void dispose() {
  //   _queueSubscription?.cancel();
  //   _processedSaleSubscription?.cancel();
  //   super.dispose();
  // }

  Future<void> deleteSale(String id) async {
    // Don't set loading state to preserve current data
    final currentCart = state.value?.cart ?? CartModel();
    final currentOrderId = state.value?.orderId;
    final currentSelectedDate = state.value?.selectedDate ?? DateTime.now();
    final currentPendingSales = state.value?.pendingSales ?? [];

    state = await AsyncValue.guard(() async {
      try {
        await _salesRepository.deleteSale(id);
        final sales =
            await _salesRepository.getSales(date: currentSelectedDate);
        return SalesState(
          cart: currentCart,
          sales: sales,
          pendingSales: currentPendingSales,
          orderId: currentOrderId,
          selectedDate: currentSelectedDate,
        );
      } catch (e) {
        print('Error in SalesNotifier.deleteSale: $e');
        return SalesState(
          cart: currentCart,
          sales: state.value?.sales ?? [], // Preserve current sales on error
          pendingSales: currentPendingSales,
          orderId: currentOrderId,
          selectedDate: currentSelectedDate,
          error: e.toString(),
        );
      }
    });
  }

  Future<void> getSales({DateTime? date}) async {
    // Don't set loading state to preserve current data
    final currentCart = state.value?.cart ?? CartModel();
    final currentOrderId = state.value?.orderId;
    final currentPendingSales = state.value?.pendingSales ?? [];
    final targetDate = date ?? state.value?.selectedDate ?? DateTime.now();

    state = await AsyncValue.guard(() async {
      try {
        final sales = await _salesRepository.getSales(date: targetDate);
        return SalesState(
          cart: currentCart,
          sales: sales,
          pendingSales: currentPendingSales,
          orderId: currentOrderId,
          selectedDate: targetDate,
        );
      } catch (e) {
        print('Error in SalesNotifier.getSales: $e');
        return SalesState(
          cart: currentCart,
          sales: state.value?.sales ?? [], // Preserve current sales on error
          pendingSales: currentPendingSales,
          orderId: currentOrderId,
          selectedDate: targetDate,
          error: e.toString(),
        );
      }
    });
  }

  Future<void> changeSelectedDate(DateTime newDate) async {
    await getSales(date: newDate);
  }

  Future<void> setCartItems(List<ProductDto> items, String? orderId) async {
    final currentState = state.value!;
    state = await AsyncValue.guard(() async {
      final updatedCart = CartModel(products: items);
      return SalesState(
        cart: updatedCart,
        error: null,
        orderId: orderId,
        sales: currentState.sales,
        selectedDate: currentState.selectedDate,
        pendingSales: currentState.pendingSales,
      );
    });
  }

  Future<void> addProductToCart(ProductDto product) async {
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final currentCart = currentState.cart;

      final updatedCart = CartModel(
        products: [...currentCart.products, product],
      );

      return SalesState(
        cart: updatedCart,
        sales: currentState.sales,
        orderId: currentState.orderId,
        error: currentState.error,
        selectedDate: currentState.selectedDate,
        pendingSales: currentState.pendingSales,
      );
    });
  }

  Future<void> removeProductFromCart(ProductDto product) async {
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final currentCart = currentState.cart;

      final updatedCart = CartModel(
        products: currentCart.products
            .where((element) => element.id != product.id)
            .toList(),
      );

      return SalesState(
        cart: updatedCart,
        sales: currentState.sales,
        orderId: currentState.orderId,
        error: currentState.error,
        selectedDate: currentState.selectedDate,
        pendingSales: currentState.pendingSales,
      );
    });
  }

  Future<void> submitSale(
      double totalAmount, PaymentMethod paymentMethod) async {
    final preAsyncState = state.value;
    if (preAsyncState == null) return;

    // Instantly clear cart and add to queue
    final currentCart = preAsyncState.cart;
    final orderIdForRequest = preAsyncState.orderId;

    final saleRequest = CreateSaleRequestModel(
      orderId: orderIdForRequest,
      saleItems: currentCart.products,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
    );

    // Add to queue and clear cart immediately
    _queueService.addToQueue(saleRequest);

    state = await AsyncValue.guard(() async {
      return SalesState(
        cart: CartModel(), // Clear cart immediately
        sales: preAsyncState.sales,
        pendingSales: _queueService.currentQueue,
        orderId: null,
        error: null,
        selectedDate: preAsyncState.selectedDate,
      );
    });

    // Refresh other providers in background silently
    try {
      // Use refresh instead of getProducts to avoid loading state
      await ref.read(productProvider.notifier).refresh();
      await ref.read(salesCheckProvider.notifier).refresh();
    } catch (e) {
      print('Error refreshing providers: $e');
    }
  }

  void clearSaleToPrint() {
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(saleToPrint: null));
    }
  }
}
