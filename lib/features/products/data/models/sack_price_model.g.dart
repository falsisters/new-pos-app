// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sack_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SackPrice _$SackPriceFromJson(Map<String, dynamic> json) => _SackPrice(
      id: json['id'] as String,
      price: const DecimalConverter().fromJson(json['price']),
      stock: const DecimalConverter().fromJson(json['stock']),
      profit: const NullableDecimalConverter().fromJson(json['profit']),
      type: $enumDecode(_$SackTypeEnumMap, json['type']),
      productId: json['productId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      specialPrice: json['specialPrice'] == null
          ? null
          : SpecialPrice.fromJson(json['specialPrice'] as Map<String, dynamic>),
      specialPriceId: json['specialPriceId'] as String?,
    );

Map<String, dynamic> _$SackPriceToJson(_SackPrice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': const DecimalConverter().toJson(instance.price),
      'stock': const DecimalConverter().toJson(instance.stock),
      'profit': const NullableDecimalConverter().toJson(instance.profit),
      'type': _$SackTypeEnumMap[instance.type]!,
      'productId': instance.productId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'specialPrice': instance.specialPrice,
      'specialPriceId': instance.specialPriceId,
    };

const _$SackTypeEnumMap = {
  SackType.FIFTY_KG: 'FIFTY_KG',
  SackType.TWENTY_FIVE_KG: 'TWENTY_FIVE_KG',
  SackType.FIVE_KG: 'FIVE_KG',
};
