import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_per_kilo_price_dto.freezed.dart';
part 'edit_per_kilo_price_dto.g.dart';

@freezed
sealed class EditPerKiloPriceDto with _$EditPerKiloPriceDto {
  const factory EditPerKiloPriceDto({
    required double price,
  }) = _EditPerKiloPriceDto;

  factory EditPerKiloPriceDto.fromJson(Map<String, dynamic> json) =>
      _$EditPerKiloPriceDtoFromJson(json);
}
