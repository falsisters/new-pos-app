// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_special_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditSpecialPriceDto _$EditSpecialPriceDtoFromJson(Map<String, dynamic> json) =>
    _EditSpecialPriceDto(
      id: json['id'] as String,
      price: const DecimalConverter().fromJson(json['price'] as String),
      minimumQty: (json['minimumQty'] as num).toInt(),
    );

Map<String, dynamic> _$EditSpecialPriceDtoToJson(
        _EditSpecialPriceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': const DecimalConverter().toJson(instance.price),
      'minimumQty': instance.minimumQty,
    };
