import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_sack_price_dto.freezed.dart';
part 'transfer_sack_price_dto.g.dart';

@freezed
sealed class TransferSackPriceDto with _$TransferSackPriceDto {
  const factory TransferSackPriceDto(
      {required String id,
      required int quantity,
      required SackType type}) = _TransferSackPriceDto;

  factory TransferSackPriceDto.fromJson(Map<String, dynamic> json) =>
      _$TransferSackPriceDtoFromJson(json);
}
