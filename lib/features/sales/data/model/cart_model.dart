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
      if (product.isDiscounted == true && product.discountedPrice != null) {
        return sum + product.discountedPrice!;
      }

      if (product.sackPrice != null) {
        return sum + (product.sackPrice!.price * product.sackPrice!.quantity);
      } else if (product.perKiloPrice != null) {
        return sum +
            (product.perKiloPrice!.price * product.perKiloPrice!.quantity);
      }

      return sum;
    });
  }

  int get itemCount => products.length;
}
