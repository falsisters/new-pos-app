import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:falsisters_pos_android/features/sales/data/model/per_kilo_price_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sack_price_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_dto.freezed.dart';
part 'product_dto.g.dart';

@freezed
sealed class ProductDto with _$ProductDto {
  const factory ProductDto({
    required String id,
    required String name,
    @NullableDecimalConverter() Decimal? price,
    @NullableDecimalConverter() Decimal? discountedPrice,
    bool? isDiscounted,
    bool? isGantang,
    bool? isSpecialPrice,
    PerKiloPriceDto? perKiloPrice,
    SackPriceDto? sackPrice,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);
}
