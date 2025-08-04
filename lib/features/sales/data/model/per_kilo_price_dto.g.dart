// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'per_kilo_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PerKiloPriceDto _$PerKiloPriceDtoFromJson(Map<String, dynamic> json) =>
    _PerKiloPriceDto(
      id: json['id'] as String,
      quantity: const DecimalConverter().fromJson(json['quantity'] as String),
      price: const DecimalConverter().fromJson(json['price'] as String),
    );

Map<String, dynamic> _$PerKiloPriceDtoToJson(_PerKiloPriceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': const DecimalConverter().toJson(instance.quantity),
      'price': const DecimalConverter().toJson(instance.price),
    };
