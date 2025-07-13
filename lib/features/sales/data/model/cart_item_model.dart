import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
sealed class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    required ProductDto product,
    bool? isGantang,
    bool? isSpecialPrice,
    required double price,
    required int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  // Add utility methods for printing calculations
  double get totalPrice => price * quantity;

  String get displayQuantity {
    if (product.perKiloPrice != null) {
      return '${product.perKiloPrice!.quantity.toStringAsFixed(2)} kg';
    } else if (product.sackPrice != null) {
      return '${product.sackPrice!.quantity.toInt()} sack${product.sackPrice!.quantity > 1 ? "s" : ""}';
    }
    return '$quantity pcs';
  }

  String get unitPriceDisplay {
    return '₱${price.toStringAsFixed(2)}';
  }

  String get totalPriceDisplay {
    return '₱${totalPrice.toStringAsFixed(2)}';
  }
}
