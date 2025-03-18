import 'package:freezed_annotation/freezed_annotation.dart';

part 'per_kilo_price_dto.freezed.dart';
part 'per_kilo_price_dto.g.dart';

@freezed
sealed class PerKiloPriceDto with _$PerKiloPriceDto {
  const factory PerKiloPriceDto({
    required String id,
    required double quantity,
    required double price,
  }) = _PerKiloPriceDto;

  factory PerKiloPriceDto.fromJson(Map<String, dynamic> json) =>
      _$PerKiloPriceDtoFromJson(json);
}
