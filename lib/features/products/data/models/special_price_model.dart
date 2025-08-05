import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'special_price_model.freezed.dart';
part 'special_price_model.g.dart';

@freezed
sealed class SpecialPrice with _$SpecialPrice {
  const factory SpecialPrice({
    required String id,
    @DecimalConverter() required Decimal price,
    required int minimumQty,
    required String sackPriceId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SpecialPrice;

  factory SpecialPrice.fromJson(Map<String, dynamic> json) =>
      _$SpecialPriceFromJson(json);
}
