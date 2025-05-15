import 'package:falsisters_pos_android/features/products/data/providers/product_provider.dart';
import 'package:falsisters_pos_android/features/sales/data/model/cart_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/per_kilo_price_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sack_price_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sales_state.dart';
import 'package:falsisters_pos_android/features/sales/data/repository/sales_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class SalesNotifier extends AsyncNotifier<SalesState> {
  final SalesRepository _salesRepository = SalesRepository();

  @override
  Future<SalesState> build() async {
    try {
      final sales = await _salesRepository.getSales();
      return SalesState(cart: CartModel(), sales: sales, orderId: null);
    } catch (e) {
      print('Error in SalesNotifier.build: $e');
      // Return empty state instead of throwing
      return SalesState(cart: CartModel(), sales: [], orderId: null);
    }
  }

  Future<void> deleteSale(String id) async {
    state = const AsyncLoading();
    final currentCart = state.value?.cart ?? CartModel();
    final currentOrderId = state.value?.orderId;

    state = await AsyncValue.guard(() async {
      try {
        await _salesRepository.deleteSale(id);
        final sales = await _salesRepository.getSales();
        return SalesState(
            cart: currentCart, sales: sales, orderId: currentOrderId);
      } catch (e) {
        print('Error in SalesNotifier.deleteSale: $e');
        return SalesState(
          cart: currentCart,
          sales: [], // Use empty list on error
          orderId: currentOrderId,
          error: e.toString(),
        );
      }
    });
  }

  Future<void> getSales() async {
    state = const AsyncLoading();
    final currentCart = state.value?.cart ?? CartModel();
    final currentOrderId = state.value?.orderId;

    state = await AsyncValue.guard(() async {
      try {
        final sales = await _salesRepository.getSales();
        return SalesState(
            cart: currentCart, // Keep the current cart
            sales: sales,
            orderId: currentOrderId); // Keep order ID
      } catch (e) {
        print('Error in SalesNotifier.getSales: $e');
        return SalesState(
          cart: currentCart,
          sales: [], // Use empty list on error
          orderId: currentOrderId,
          error: e.toString(),
        );
      }
    });
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
      );
    });
  }

  Future<void> submitSale(
      double totalAmount, PaymentMethod paymentMethod) async {
    final preAsyncState = state.value;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final currentCart = preAsyncState!.cart;
        final orderIdForRequest = preAsyncState.orderId;

        print('Order ID for request: $orderIdForRequest');
        print('Payment method: $paymentMethod');
        print('Total amount: $totalAmount');
        print('Cart items count: ${currentCart.products.length}');

        final saleRequest = CreateSaleRequestModel(
          orderId: orderIdForRequest,
          saleItems: currentCart.products,
          paymentMethod: paymentMethod,
          totalAmount: totalAmount,
        );

        // Log the request payload for debugging
        print('Sale request: ${jsonEncode(saleRequest.toJson())}');

        // Always create a new sale, removed editing logic
        await _salesRepository.createSale(saleRequest);

        // Update products first, as it might be more reliable
        await ref.read(productProvider.notifier).getProducts();

        // Safely get sales with error handling
        List<SaleModel> sales = [];
        try {
          sales = await _salesRepository.getSales();
        } catch (e) {
          print('Error fetching sales after submit: $e');
          // Continue with empty sales rather than crashing
        }

        return SalesState(
          cart: CartModel(),
          sales: sales,
          orderId: null,
          error: null,
        );
      } catch (e) {
        print('Error in submitSale: $e');
        return SalesState(
          cart: preAsyncState!.cart,
          sales: preAsyncState.sales,
          orderId: preAsyncState.orderId,
          error: e.toString(),
        );
      }
    });
  }
}
