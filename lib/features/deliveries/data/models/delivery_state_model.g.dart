// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryStateModel _$DeliveryStateModelFromJson(Map<String, dynamic> json) =>
    _DeliveryStateModel(
      truck: TruckModel.fromJson(json['truck'] as Map<String, dynamic>),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$DeliveryStateModelToJson(_DeliveryStateModel instance) =>
    <String, dynamic>{
      'truck': instance.truck,
      'error': instance.error,
    };
