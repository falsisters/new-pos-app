// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    _CartItemModel(
      product: ProductDto.fromJson(json['product'] as Map<String, dynamic>),
      isGantang: json['isGantang'] as bool?,
      isSpecialPrice: json['isSpecialPrice'] as bool?,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CartItemModelToJson(_CartItemModel instance) =>
    <String, dynamic>{
      'product': instance.product,
      'isGantang': instance.isGantang,
      'isSpecialPrice': instance.isSpecialPrice,
      'price': instance.price,
      'quantity': instance.quantity,
    };
