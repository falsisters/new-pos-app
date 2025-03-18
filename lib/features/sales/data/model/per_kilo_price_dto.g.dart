// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'per_kilo_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PerKiloPriceDto _$PerKiloPriceDtoFromJson(Map<String, dynamic> json) =>
    _PerKiloPriceDto(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PerKiloPriceDtoToJson(_PerKiloPriceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'price': instance.price,
    };
