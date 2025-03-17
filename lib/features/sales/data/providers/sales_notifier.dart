import 'package:falsisters_pos_android/features/sales/data/model/cart_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sales_state.dart';
import 'package:falsisters_pos_android/features/sales/data/repository/sales_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesNotifier extends AsyncNotifier<SalesState> {
  final SalesRepository _salesRepository = SalesRepository();

  @override
  Future<SalesState> build() async {
    return SalesState(cart: CartModel());
  }

  Future<void> addProductToCart(ProductDto product) async {
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final currentCart = currentState.cart;

      // Create new cart with the added product
      final updatedCart = CartModel(
        products: [...currentCart.products, product],
      );

      return SalesState(cart: updatedCart);
    });
  }

  // This will be used when submitting the sale to the server
  Future<void> createSale(
      double totalAmount, PaymentMethod paymentMethod) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final currentCart = state.value!.cart;
        await _salesRepository.createSale(CreateSaleRequestModel(
            saleItems: currentCart.products,
            paymentMethod: paymentMethod,
            totalAmount: totalAmount));

        // After successful creation, clear the cart
        return SalesState(cart: CartModel());
      } catch (e) {
        return SalesState(
          cart: state.value!.cart,
          error: e.toString(),
        );
      }
    });
  }
}
