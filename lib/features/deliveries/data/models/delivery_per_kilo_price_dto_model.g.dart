// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_per_kilo_price_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryPerKiloPriceDtoModel _$DeliveryPerKiloPriceDtoModelFromJson(
        Map<String, dynamic> json) =>
    _DeliveryPerKiloPriceDtoModel(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$DeliveryPerKiloPriceDtoModelToJson(
        _DeliveryPerKiloPriceDtoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
    };
