import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_per_kilo_price_dto.freezed.dart';
part 'edit_per_kilo_price_dto.g.dart';

@freezed
sealed class EditPerKiloPriceDto with _$EditPerKiloPriceDto {
  const factory EditPerKiloPriceDto({
    @DecimalConverter() required Decimal price,
  }) = _EditPerKiloPriceDto;

  factory EditPerKiloPriceDto.fromJson(Map<String, dynamic> json) =>
      _$EditPerKiloPriceDtoFromJson(json);
}
