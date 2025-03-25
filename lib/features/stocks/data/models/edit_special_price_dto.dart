import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_special_price_dto.freezed.dart';
part 'edit_special_price_dto.g.dart';

@freezed
sealed class EditSpecialPriceDto with _$EditSpecialPriceDto {
  const factory EditSpecialPriceDto({
    required String id,
    required double price,
    required int minimumQty,
  }) = _EditSpecialPriceDto;

  factory EditSpecialPriceDto.fromJson(Map<String, dynamic> json) =>
      _$EditSpecialPriceDtoFromJson(json);
}
