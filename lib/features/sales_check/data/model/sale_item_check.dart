// ignore_for_file: invalid_annotation_target
import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_item_check.freezed.dart';
part 'sale_item_check.g.dart';

@freezed
sealed class SaleItemCheck with _$SaleItemCheck {
  const factory SaleItemCheck({
    required String id,
    @DecimalConverter() required Decimal quantity,
    required String productId,
    // Consider adding ProductDto product if the backend endpoint includes it
    // required ProductDto product,
    String? sackPriceId, // Added to align with SaleItem schema
    String? perKiloPriceId, // Added to align with SaleItem schema
    String?
        sackType, // Added to align with SaleItem schema (e.g., "FIFTY_KG", "TWENTY_FIVE_KG", "FIVE_KG")
    required String saleId,
    @Default(false) bool isGantang,
    @Default(false) bool isSpecialPrice,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SaleItemCheck;

  factory SaleItemCheck.fromJson(Map<String, dynamic> json) =>
      _$SaleItemCheckFromJson(json);
}
