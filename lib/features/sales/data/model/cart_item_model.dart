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
    required double price,
    required int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  // Add utility methods for printing calculations
  double get totalPrice {
    final total = price * quantity;
    // Apply ceiling rounding with improved precision handling
    final totalStr = total.toStringAsFixed(10); // Extra precision
    final preciseTotal = double.parse(totalStr);
    return (preciseTotal * 100).ceil() / 100.0;
  }

  String get displayQuantity {
    if (product.perKiloPrice != null) {
      return '${product.perKiloPrice!.quantity.toStringAsFixed(2)} kg';
    } else if (product.sackPrice != null) {
      return '${product.sackPrice!.quantity.toBigInt().toInt()} sack${product.sackPrice!.quantity > Decimal.fromInt(1) ? "s" : ""}';
    }
    return '$quantity pcs';
  }

  String get unitPriceDisplay {
    // Apply ceiling rounding to unit price display with improved precision
    final priceStr = price.toStringAsFixed(10); // Extra precision
    final precisePrice = double.parse(priceStr);
    final ceiledPrice = (precisePrice * 100).ceil() / 100.0;
    return '₱${ceiledPrice.toStringAsFixed(2)}';
  }

  String get totalPriceDisplay {
    return '₱${totalPrice.toStringAsFixed(2)}';
  }
}
