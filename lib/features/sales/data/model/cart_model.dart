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
  double get totalAmount {
    // Define ceiling rounding function with improved precision
    double ceilRoundPrice(double value) {
      if (value.isNaN || value.isInfinite) return 0.0;
      if (value < 0) return 0.0;

      // Fix precision loss by converting to string first, then parsing back
      final valueStr = value.toStringAsFixed(10);
      final preciseValue = double.parse(valueStr);

      // Use proper rounding to avoid floating point precision issues
      final centsValue = (preciseValue * 100.0).round();
      final ceiledCents =
          ((centsValue + 99) ~/ 100) * 100; // Ceiling to next cent

      return ceiledCents / 100.0;
    }

    double grandTotal = products.fold(0.0, (sum, product) {
      double itemTotal = 0.0;

      if (product.isDiscounted == true && product.discountedPrice != null) {
        double quantity = 1.0;
        if (product.perKiloPrice != null) {
          quantity = product.perKiloPrice!.quantity;
        } else if (product.sackPrice != null) {
          quantity = product.sackPrice!.quantity;
        }
        // Use ceiling-rounded discount price
        final ceiledDiscountPrice = ceilRoundPrice(product.discountedPrice!);
        itemTotal = ceiledDiscountPrice * quantity;
      } else if (product.sackPrice != null) {
        // Use ceiling-rounded unit price
        final ceiledUnitPrice = ceilRoundPrice(product.sackPrice!.price);
        itemTotal = ceiledUnitPrice * product.sackPrice!.quantity;
      } else if (product.perKiloPrice != null) {
        // Use ceiling-rounded unit price
        final ceiledUnitPrice = ceilRoundPrice(product.perKiloPrice!.price);
        itemTotal = ceiledUnitPrice * product.perKiloPrice!.quantity;
      }

      // Apply ceiling rounding to each item's total before adding to sum
      final ceiledItemTotal = ceilRoundPrice(itemTotal);
      return sum + ceiledItemTotal;
    });

    // Apply ceiling rounding to the final grand total
    return ceilRoundPrice(grandTotal);
  }

  int get itemCount => products.length;
}
