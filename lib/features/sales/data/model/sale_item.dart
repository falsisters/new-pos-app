// ignore_for_file: invalid_annotation_target

import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:falsisters_pos_android/features/products/data/models/per_kilo_price_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/sack_price_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_item.freezed.dart';
part 'sale_item.g.dart';

@freezed
sealed class SaleItem with _$SaleItem {
  const factory SaleItem({
    required String id,
    required String productId,
    required Product product,
    @DecimalConverter() required Decimal quantity,
    @NullableDecimalConverter() Decimal? price,
    @NullableDecimalConverter() Decimal? discountedPrice,
    @JsonKey(name: 'SackPrice') SackPrice? sackPrice,
    String? sackPriceId,
    SackType? sackType,
    PerKiloPrice? perKiloPrice,
    String? perKiloPriceId,
    required String saleId,
    required bool isGantang,
    required bool isSpecialPrice,
    required bool isDiscounted,
    required String createdAt,
    required String updatedAt,
  }) = _SaleItem;

  factory SaleItem.fromJson(Map<String, dynamic> json) =>
      _$SaleItemFromJson(json);
}
