// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TruckItemModel _$TruckItemModelFromJson(Map<String, dynamic> json) =>
    _TruckItemModel(
      product: DeliveryProductDtoModel.fromJson(
          json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TruckItemModelToJson(_TruckItemModel instance) =>
    <String, dynamic>{
      'product': instance.product,
    };
