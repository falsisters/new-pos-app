import 'package:falsisters_pos_android/features/stocks/data/models/transfer_per_kilo_price_dto.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/transfer_sack_price_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_product_dto.freezed.dart';
part 'transfer_product_dto.g.dart';

@freezed
sealed class TransferProductDto with _$TransferProductDto {
  const factory TransferProductDto({
    required String id,
    TransferPerKiloPriceDto? perKiloPrice,
    TransferSackPriceDto? sackPrice,
  }) = _TransferProductDto;

  factory TransferProductDto.fromJson(Map<String, dynamic> json) =>
      _$TransferProductDtoFromJson(json);
}
