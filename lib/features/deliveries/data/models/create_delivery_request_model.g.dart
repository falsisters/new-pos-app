// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_delivery_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateDeliveryRequestModel _$CreateDeliveryRequestModelFromJson(
        Map<String, dynamic> json) =>
    _CreateDeliveryRequestModel(
      driverName: json['driverName'] as String,
      deliveryTimeStart: DateTime.parse(json['deliveryTimeStart'] as String),
      deliveryItems: (json['deliveryItem'] as List<dynamic>)
          .map((e) =>
              DeliveryProductDtoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateDeliveryRequestModelToJson(
        _CreateDeliveryRequestModel instance) =>
    <String, dynamic>{
      'driverName': instance.driverName,
      'deliveryTimeStart': instance.deliveryTimeStart.toIso8601String(),
      'deliveryItem': instance.deliveryItems,
    };
