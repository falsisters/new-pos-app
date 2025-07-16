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

  // Add utility methods for calculations
  double get totalAmount {
    return products.fold(0.0, (sum, product) {
      double itemTotal = 0.0;

      if (product.isDiscounted == true && product.discountedPrice != null) {
        itemTotal = product.discountedPrice!;
      } else if (product.sackPrice != null) {
        itemTotal = product.sackPrice!.price * product.sackPrice!.quantity;
      } else if (product.perKiloPrice != null) {
        itemTotal =
            product.perKiloPrice!.price * product.perKiloPrice!.quantity;
      }

      // Apply ceiling rounding to each item's total before adding to sum
      return sum + ((itemTotal * 100).ceil() / 100.0);
    });
  }

  int get itemCount => products.length;
}
