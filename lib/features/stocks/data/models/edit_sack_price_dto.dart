import 'package:falsisters_pos_android/features/stocks/data/models/edit_special_price_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_sack_price_dto.freezed.dart';
part 'edit_sack_price_dto.g.dart';

@freezed
sealed class EditSackPriceDto with _$EditSackPriceDto {
  const factory EditSackPriceDto({
    required String id,
    required double price,
    required EditSpecialPriceDto specialPrice,
  }) = _EditSackPriceDto;

  factory EditSackPriceDto.fromJson(Map<String, dynamic> json) =>
      _$EditSackPriceDtoFromJson(json);
}
