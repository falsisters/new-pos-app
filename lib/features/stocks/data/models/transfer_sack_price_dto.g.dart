// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_sack_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferSackPriceDto _$TransferSackPriceDtoFromJson(
        Map<String, dynamic> json) =>
    _TransferSackPriceDto(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      type: $enumDecode(_$SackTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$TransferSackPriceDtoToJson(
        _TransferSackPriceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'type': _$SackTypeEnumMap[instance.type]!,
    };

const _$SackTypeEnumMap = {
  SackType.FIFTY_KG: 'FIFTY_KG',
  SackType.TWENTY_FIVE_KG: 'TWENTY_FIVE_KG',
  SackType.FIVE_KG: 'FIVE_KG',
};
