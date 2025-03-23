// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_sack_price_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliverySackPriceDtoModel _$DeliverySackPriceDtoModelFromJson(
        Map<String, dynamic> json) =>
    _DeliverySackPriceDtoModel(
      id: json['id'] as String,
      type: $enumDecode(_$SackTypeEnumMap, json['type']),
      quantity: (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$DeliverySackPriceDtoModelToJson(
        _DeliverySackPriceDtoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SackTypeEnumMap[instance.type]!,
      'quantity': instance.quantity,
    };

const _$SackTypeEnumMap = {
  SackType.FIFTY_KG: 'FIFTY_KG',
  SackType.TWENTY_FIVE_KG: 'TWENTY_FIVE_KG',
  SackType.FIVE_KG: 'FIVE_KG',
};
