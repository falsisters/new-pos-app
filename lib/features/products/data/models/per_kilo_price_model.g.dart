// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'per_kilo_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PerKiloPrice _$PerKiloPriceFromJson(Map<String, dynamic> json) =>
    _PerKiloPrice(
      id: json['id'] as String,
      price: const DecimalConverter().fromJson(json['price'] as String),
      stock: const DecimalConverter().fromJson(json['stock'] as String),
      productId: json['productId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PerKiloPriceToJson(_PerKiloPrice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': const DecimalConverter().toJson(instance.price),
      'stock': const DecimalConverter().toJson(instance.stock),
      'productId': instance.productId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
