// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_product_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryProductDtoModel _$DeliveryProductDtoModelFromJson(
        Map<String, dynamic> json) =>
    _DeliveryProductDtoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      perKiloPrice: json['perKiloPrice'] == null
          ? null
          : DeliveryPerKiloPriceDtoModel.fromJson(
              json['perKiloPrice'] as Map<String, dynamic>),
      sackPrice: json['sackPrice'] == null
          ? null
          : DeliverySackPriceDtoModel.fromJson(
              json['sackPrice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeliveryProductDtoModelToJson(
        _DeliveryProductDtoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'perKiloPrice': instance.perKiloPrice,
      'sackPrice': instance.sackPrice,
    };
