import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/database/providers/database_provider.dart';
import 'package:falsisters_pos_android/core/sync/connectivity_service.dart';
import 'package:falsisters_pos_android/core/sync/sync_engine.dart';
import 'package:falsisters_pos_android/features/products/data/providers/product_provider.dart';
import 'package:falsisters_pos_android/features/sales/data/local/sales_local_repository.dart';
import 'package:falsisters_pos_android/features/sales/data/model/cart_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sales_state.dart';
import 'package:falsisters_pos_android/features/sales_check/data/providers/sales_check_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesNotifier extends AsyncNotifier<SalesState> {
  late SalesLocalRepository _localRepository;

  @override
  Future<SalesState> build() async {
    final db = await ref.read(databaseProvider.future);
    _localRepository = SalesLocalRepository(db);

    try {
      final today = DateTime.now();
      final sales = await _localRepository.getSales(date: today);

      return SalesState(
        cart: CartModel(),
        sales: sales,
        orderId: null,
        selectedDate: today,
      );
    } catch (e) {
      debugPrint('Error in SalesNotifier.build: $e');
      return SalesState(
        cart: CartModel(),
        sales: [],
        orderId: null,
        selectedDate: DateTime.now(),
      );
    }
  }

  Future<void> deleteSale(String id) async {
    final currentState = state.value;
    if (currentState == null) return;
    final currentCart = currentState.cart;
    final currentOrderId = currentState.orderId;
    final currentSelectedDate = currentState.selectedDate ?? DateTime.now();

    state = await AsyncValue.guard(() async {
      try {
        await _localRepository.deleteSale(id);
        final sales = await _localRepository.getSales(date: currentSelectedDate);
        return SalesState(
          cart: currentCart,
          sales: sales,
          orderId: currentOrderId,
          selectedDate: currentSelectedDate,
        );
      } catch (e) {
        debugPrint('Error in SalesNotifier.deleteSale: $e');
        return SalesState(
          cart: currentCart,
          sales: state.value?.sales ?? [],
          orderId: currentOrderId,
          selectedDate: currentSelectedDate,
          error: e.toString(),
        );
      }
    });
  }

  Future<void> getSales({DateTime? date}) async {
    final currentState = state.value;
    if (currentState == null) return;
    final currentCart = currentState.cart;
    final currentOrderId = currentState.orderId;
    final targetDate = date ?? currentState.selectedDate ?? DateTime.now();

    state = await AsyncValue.guard(() async {
      try {
        final sales = await _localRepository.getSales(date: targetDate);
        return SalesState(
          cart: currentCart,
          sales: sales,
          orderId: currentOrderId,
          selectedDate: targetDate,
        );
      } catch (e) {
        debugPrint('Error in SalesNotifier.getSales: $e');
        return SalesState(
          cart: currentCart,
          sales: state.value?.sales ?? [],
          orderId: currentOrderId,
          selectedDate: targetDate,
          error: e.toString(),
        );
      }
    });

    final connectivityService = ConnectivityService();
    if (await connectivityService.isConnected()) {
      unawaited(_refreshFromServer(targetDate));
    }
  }

  Future<void> _refreshFromServer(DateTime date) async {
    try {
      final syncEngine = ref.read(syncEngineProvider);
      final dateStr = date.toIso8601String().split('T')[0];
      await syncEngine.pullAndMerge('sales', '/sale/recent/cashier?date=$dateStr');
      await getSales(date: date);
    } catch (e) {
      debugPrint('Background refresh failed: $e');
    }
  }

  Future<void> changeSelectedDate(DateTime newDate) async {
    await getSales(date: newDate);
  }

  Future<void> setCartItems(List<ProductDto> items, String? orderId) async {
    final currentState = state.value;
    if (currentState == null) return;
    state = await AsyncValue.guard(() async {
      final updatedCart = CartModel(products: items);
      return currentState.copyWith(
        cart: updatedCart,
        error: null,
        orderId: orderId,
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

      return currentState.copyWith(cart: updatedCart);
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

      return currentState.copyWith(cart: updatedCart);
    });
  }

  Future<void> submitSale(
      Decimal totalAmount, PaymentMethod paymentMethod) async {
    await submitSaleWithDetails(totalAmount, paymentMethod);
  }

  Future<void> submitSaleWithDetails(
    Decimal totalAmount,
    PaymentMethod paymentMethod, {
    Decimal? changeAmount,
    String? cashierId,
    String? cashierName,
    int? printCopies,
  }) async {
    final preAsyncState = state.value;
    if (preAsyncState == null) return;

    debugPrint('=== SUBMIT SALE WITH DETAILS ===');
    debugPrint('Total Amount: P${totalAmount.toStringAsFixed(2)}');
    debugPrint('Payment Method: $paymentMethod');

    final currentCart = preAsyncState.cart;
    final orderIdForRequest = preAsyncState.orderId;

    final metadata = <String, dynamic>{};
    if (changeAmount != null && changeAmount >= Decimal.zero) {
      metadata['change'] = changeAmount.toStringAsFixed(2);
      metadata['tenderedAmount'] =
          (totalAmount + changeAmount).toStringAsFixed(2);
    }
    if (cashierId != null) {
      metadata['cashierId'] = cashierId;
    }
    if (cashierName != null) {
      metadata['cashierName'] = cashierName;
    }
    if (printCopies != null) {
      metadata['printCopies'] = printCopies;
    }

    final saleRequest = CreateSaleRequestModel(
      orderId: orderIdForRequest,
      saleItems: currentCart.products,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      changeAmount: changeAmount,
      cashierId: cashierId,
      cashierName: cashierName,
      metadata: metadata.isNotEmpty ? metadata : null,
    );

    try {
      final createdSale = await _localRepository.createSale(saleRequest);

      final updatedSales = [createdSale, ...preAsyncState.sales];

      state = AsyncValue.data(SalesState(
        cart: CartModel(),
        sales: updatedSales,
        orderId: null,
        selectedDate: preAsyncState.selectedDate,
        saleToPrint: createdSale,
      ));

      debugPrint('Sale written locally, cart cleared, printing triggered');
    } catch (e) {
      debugPrint('Error creating sale locally: $e');

      state = AsyncValue.data(preAsyncState.copyWith(
        error: e.toString(),
      ));
    }

    Future.microtask(() async {
      try {
        await ref.read(productProvider.notifier).refresh();
        await ref.read(salesCheckProvider.notifier).refresh();
      } catch (e) {
        debugPrint('Error refreshing background providers: $e');
      }
    });
  }

  void clearSaleToPrint() {
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(saleToPrint: null));
    }
  }
}
