// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_item_check.freezed.dart';
part 'sale_item_check.g.dart';

@freezed
sealed class SaleItemCheck with _$SaleItemCheck {
  const factory SaleItemCheck({
    required String id,
    required double quantity,
    required String productId,
    // Consider adding ProductDto product if the backend endpoint includes it
    // required ProductDto product,
    required String saleId,
    @Default(false) bool isGantang,
    @Default(false) bool isSpecialPrice,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SaleItemCheck;

  factory SaleItemCheck.fromJson(Map<String, dynamic> json) =>
      _$SaleItemCheckFromJson(json);
}
