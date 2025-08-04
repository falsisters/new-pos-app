import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

@freezed
sealed class CartModel with _$CartModel {
  const CartModel._();

  const factory CartModel({
    @Default([]) List<ProductDto> products,
  }) = _CartModel;

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  // Add utility methods for calculations with improved ceiling rounding
  Decimal get totalAmount {
    Decimal grandTotal = Decimal.zero;

    for (final product in products) {
      Decimal itemTotal = Decimal.zero;
      Decimal quantity = Decimal.one;

      if (product.perKiloPrice != null) {
        quantity = product.perKiloPrice!.quantity;
      } else if (product.sackPrice != null) {
        quantity = product.sackPrice!.quantity;
      }

      if (product.isDiscounted == true && product.discountedPrice != null) {
        itemTotal =
            Decimal.parse(product.discountedPrice!.toString()) * quantity;
      } else if (product.sackPrice != null) {
        itemTotal = product.sackPrice!.price * quantity;
      } else if (product.perKiloPrice != null) {
        itemTotal = product.perKiloPrice!.price * quantity;
      }

      grandTotal += itemTotal;
    }

    // The backend likely handles rounding, so we send the precise value.
    // If frontend rounding is needed, it should be done at the display layer.
    return grandTotal;
  }

  int get itemCount => products.length;
}
