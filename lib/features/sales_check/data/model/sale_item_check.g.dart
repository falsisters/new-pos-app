// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_item_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleItemCheck _$SaleItemCheckFromJson(Map<String, dynamic> json) =>
    _SaleItemCheck(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      productId: json['productId'] as String,
      saleId: json['saleId'] as String,
      isGantang: json['isGantang'] as bool? ?? false,
      isSpecialPrice: json['isSpecialPrice'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SaleItemCheckToJson(_SaleItemCheck instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'productId': instance.productId,
      'saleId': instance.saleId,
      'isGantang': instance.isGantang,
      'isSpecialPrice': instance.isSpecialPrice,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
