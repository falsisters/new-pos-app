import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:falsisters_pos_android/features/products/data/models/special_price_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sack_price_model.freezed.dart';
part 'sack_price_model.g.dart';

@freezed
sealed class SackPrice with _$SackPrice {
  const factory SackPrice({
    required String id,
    @DecimalConverter() required Decimal price,
    @DecimalConverter() required Decimal stock,
    required SackType type,
    required String productId,
    required DateTime createdAt,
    required DateTime updatedAt,
    SpecialPrice? specialPrice,
    String? specialPriceId,
  }) = _SackPrice;

  factory SackPrice.fromJson(Map<String, dynamic> json) =>
      _$SackPriceFromJson(json);
}
