import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_per_kilo_price_dto.g.dart';
part 'transfer_per_kilo_price_dto.freezed.dart';

@freezed
sealed class TransferPerKiloPriceDto with _$TransferPerKiloPriceDto {
  const factory TransferPerKiloPriceDto({
    required String id,
    @DecimalConverter() required Decimal quantity,
  }) = _TransferPerKiloPriceDto;

  factory TransferPerKiloPriceDto.fromJson(Map<String, dynamic> json) =>
      _$TransferPerKiloPriceDtoFromJson(json);
}
