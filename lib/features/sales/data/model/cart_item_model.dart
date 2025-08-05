import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:decimal/decimal.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
sealed class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    required ProductDto product,
    bool? isGantang,
    bool? isSpecialPrice,
    required Decimal price,
    required Decimal quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  // Add utility methods for printing calculations
  Decimal get totalPrice {
    final total = price * quantity;
    // Apply ceiling rounding with improved precision handling
    return (Decimal.fromInt(
                (total * Decimal.fromInt(100)).ceil().toBigInt().toInt()) /
            Decimal.fromInt(100))
        .toDecimal();
  }

  String get displayQuantity {
    if (product.perKiloPrice != null) {
      return '${product.perKiloPrice!.quantity.toStringAsFixed(2)} kg';
    } else if (product.sackPrice != null) {
      return '${product.sackPrice!.quantity.toBigInt().toInt()} sack${product.sackPrice!.quantity > Decimal.one ? "s" : ""}';
    }
    return '${quantity.toBigInt()} pcs';
  }

  String get unitPriceDisplay {
    // Apply ceiling rounding to unit price display with improved precision
    final ceiledPrice =
        (price * Decimal.fromInt(100)).ceil() / Decimal.fromInt(100);
    return '₱${ceiledPrice.toDouble().toStringAsFixed(2)}';
  }

  String get totalPriceDisplay {
    return '₱${totalPrice.toStringAsFixed(2)}';
  }
}
