// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TruckModel _$TruckModelFromJson(Map<String, dynamic> json) => _TruckModel(
      products: (json['products'] as List<dynamic>?)
              ?.map((e) =>
                  DeliveryProductDtoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TruckModelToJson(_TruckModel instance) =>
    <String, dynamic>{
      'products': instance.products,
    };
