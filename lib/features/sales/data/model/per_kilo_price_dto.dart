import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'per_kilo_price_dto.freezed.dart';
part 'per_kilo_price_dto.g.dart';

@freezed
sealed class PerKiloPriceDto with _$PerKiloPriceDto {
  const factory PerKiloPriceDto({
    required String id,
    @DecimalConverter() required Decimal quantity,
    @DecimalConverter() required Decimal price,
  }) = _PerKiloPriceDto;

  factory PerKiloPriceDto.fromJson(Map<String, dynamic> json) =>
      _$PerKiloPriceDtoFromJson(json);
}
