// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpecialPrice _$SpecialPriceFromJson(Map<String, dynamic> json) =>
    _SpecialPrice(
      id: json['id'] as String,
      price: const DecimalConverter().fromJson(json['price'] as String),
      minimumQty: (json['minimumQty'] as num).toInt(),
      sackPriceId: json['sackPriceId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SpecialPriceToJson(_SpecialPrice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': const DecimalConverter().toJson(instance.price),
      'minimumQty': instance.minimumQty,
      'sackPriceId': instance.sackPriceId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
