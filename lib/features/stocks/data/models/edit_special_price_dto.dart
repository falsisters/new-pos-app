import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_special_price_dto.freezed.dart';
part 'edit_special_price_dto.g.dart';

@freezed
sealed class EditSpecialPriceDto with _$EditSpecialPriceDto {
  const factory EditSpecialPriceDto({
    required String id,
    @DecimalConverter() required Decimal price,
    required int minimumQty,
  }) = _EditSpecialPriceDto;

  factory EditSpecialPriceDto.fromJson(Map<String, dynamic> json) =>
      _$EditSpecialPriceDtoFromJson(json);
}
