// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sack_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SackPriceDto _$SackPriceDtoFromJson(Map<String, dynamic> json) =>
    _SackPriceDto(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      type: $enumDecode(_$SackTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$SackPriceDtoToJson(_SackPriceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'price': instance.price,
      'type': _$SackTypeEnumMap[instance.type]!,
    };

const _$SackTypeEnumMap = {
  SackType.FIFTY_KG: 'FIFTY_KG',
  SackType.TWENTY_FIVE_KG: 'TWENTY_FIVE_KG',
  SackType.FIVE_KG: 'FIVE_KG',
};
