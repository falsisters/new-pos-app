// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_item_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleItemCheck _$SaleItemCheckFromJson(Map<String, dynamic> json) =>
    _SaleItemCheck(
      id: json['id'] as String,
      quantity: const DecimalConverter().fromJson(json['quantity'] as String),
      productId: json['productId'] as String,
      sackPriceId: json['sackPriceId'] as String?,
      perKiloPriceId: json['perKiloPriceId'] as String?,
      sackType: json['sackType'] as String?,
      saleId: json['saleId'] as String,
      isGantang: json['isGantang'] as bool? ?? false,
      isSpecialPrice: json['isSpecialPrice'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SaleItemCheckToJson(_SaleItemCheck instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': const DecimalConverter().toJson(instance.quantity),
      'productId': instance.productId,
      'sackPriceId': instance.sackPriceId,
      'perKiloPriceId': instance.perKiloPriceId,
      'sackType': instance.sackType,
      'saleId': instance.saleId,
      'isGantang': instance.isGantang,
      'isSpecialPrice': instance.isSpecialPrice,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
