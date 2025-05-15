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

class SalesNotifier extends AsyncNotifier<SalesState> {
  final SalesRepository _salesRepository = SalesRepository();

  @override
  Future<SalesState> build() async {
    final sales = await _salesRepository.getSales();
    return SalesState(
        cart: CartModel(), sales: sales, editingSaleId: null, orderId: null);
  }

  Future<void> getSales() async {
    state = const AsyncLoading();
    final currentCart = state.value?.cart ?? CartModel();
    final currentSales = state.value?.sales ?? [];
    final currentEditingId = state.value?.editingSaleId;
    final currentOrderId = state.value?.orderId;

    state = await AsyncValue.guard(() async {
      try {
        final sales = await _salesRepository.getSales();
        return SalesState(
            cart: CartModel(),
            sales: sales,
            editingSaleId: null,
            orderId: null);
      } catch (e) {
        return SalesState(
          cart: currentCart,
          sales: currentSales,
          editingSaleId: currentEditingId,
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
        editingSaleId: null,
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
        editingSaleId: currentState.editingSaleId,
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
        editingSaleId: currentState.editingSaleId,
        orderId: currentState.orderId,
        error: currentState.error,
      );
    });
  }

  Future<void> prepareSaleForEditing(SaleModel sale) async {
    final currentState = state.value!;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final List<ProductDto> cartProducts = [];
      for (var item in sale.saleItems) {
        // Updated condition: check for productId and the product object itself.
        // Assuming Product model has a 'name' field.

        PerKiloPriceDto? perKiloDto;
        SackPriceDto? sackDto;

        if (item.perKiloPriceId != null && item.perKiloPrice != null) {
          perKiloDto = PerKiloPriceDto(
            id: item.perKiloPriceId!,
            price: item.perKiloPrice!.price,
            quantity: item.quantity,
          );
        } else if (item.sackPriceId != null &&
            item.sackPrice != null &&
            item.sackType != null) {
          sackDto = SackPriceDto(
            id: item.sackPriceId!,
            price: item.sackPrice!.price,
            quantity: item.quantity,
            type: item.sackType!,
          );
        }

        cartProducts.add(
          ProductDto(
            id: item.productId,
            name: item.product
                .name, // Use product.name from the embedded Product model
            discountedPrice: item.discountedPrice,
            isDiscounted: item.isDiscounted,
            isGantang: item.isGantang,
            isSpecialPrice: item.isSpecialPrice,
            perKiloPrice: perKiloDto,
            sackPrice: sackDto,
          ),
        );
      }

      final updatedCart = CartModel(products: cartProducts);
      return SalesState(
        cart: updatedCart,
        sales: currentState.sales,
        editingSaleId: sale.id,
        orderId: sale.id,
        error: null,
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
        final editingId = preAsyncState.editingSaleId;
        final orderIdForRequest = preAsyncState.orderId;

        final saleRequest = CreateSaleRequestModel(
          orderId: orderIdForRequest,
          saleItems: currentCart.products,
          paymentMethod: paymentMethod,
          totalAmount: totalAmount,
        );

        if (editingId != null) {
          await _salesRepository.editSale(editingId, saleRequest);
        } else {
          await _salesRepository.createSale(saleRequest);
        }

        await ref.read(productProvider.notifier).getProducts();
        final sales = await _salesRepository.getSales();

        return SalesState(
          cart: CartModel(),
          sales: sales,
          editingSaleId: null,
          orderId: null,
          error: null,
        );
      } catch (e) {
        return SalesState(
          cart: preAsyncState!.cart,
          sales: preAsyncState.sales,
          editingSaleId: preAsyncState.editingSaleId,
          orderId: preAsyncState.orderId,
          error: e.toString(),
        );
      }
    });
  }
}
