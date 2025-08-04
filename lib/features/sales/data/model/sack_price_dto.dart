import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sack_price_dto.freezed.dart';
part 'sack_price_dto.g.dart';

@freezed
sealed class SackPriceDto with _$SackPriceDto {
  const factory SackPriceDto({
    required String id,
    @DecimalConverter() required Decimal quantity,
    @DecimalConverter() required Decimal price,
    required SackType type,
  }) = _SackPriceDto;

  factory SackPriceDto.fromJson(Map<String, dynamic> json) =>
      _$SackPriceDtoFromJson(json);
}
