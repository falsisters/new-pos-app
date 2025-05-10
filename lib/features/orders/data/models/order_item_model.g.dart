// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    _OrderItemModel(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      productId: json['productId'] as String,
      sackPriceId: json['sackPriceId'] as String?,
      sackPrice: json['SackPrice'] == null
          ? null
          : SackPrice.fromJson(json['SackPrice'] as Map<String, dynamic>),
      perKiloPriceId: json['perKiloPriceId'] as String?,
      perKiloPrice: json['perKiloPrice'] == null
          ? null
          : PerKiloPrice.fromJson(json['perKiloPrice'] as Map<String, dynamic>),
      isSpecialPrice: json['isSpecialPrice'] as bool,
      orderId: json['orderId'] as String,
      product: OrderProduct.fromJson(json['product'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$OrderItemModelToJson(_OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'productId': instance.productId,
      'sackPriceId': instance.sackPriceId,
      'SackPrice': instance.sackPrice,
      'perKiloPriceId': instance.perKiloPriceId,
      'perKiloPrice': instance.perKiloPrice,
      'isSpecialPrice': instance.isSpecialPrice,
      'orderId': instance.orderId,
      'product': instance.product,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
