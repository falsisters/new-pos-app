// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleItem _$SaleItemFromJson(Map<String, dynamic> json) => _SaleItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: const DecimalConverter().fromJson(json['quantity']),
      price: const NullableDecimalConverter().fromJson(json['price']),
      discountedPrice:
          const NullableDecimalConverter().fromJson(json['discountedPrice']),
      sackPrice: json['SackPrice'] == null
          ? null
          : SackPrice.fromJson(json['SackPrice'] as Map<String, dynamic>),
      sackPriceId: json['sackPriceId'] as String?,
      sackType: $enumDecodeNullable(_$SackTypeEnumMap, json['sackType']),
      perKiloPrice: json['perKiloPrice'] == null
          ? null
          : PerKiloPrice.fromJson(json['perKiloPrice'] as Map<String, dynamic>),
      perKiloPriceId: json['perKiloPriceId'] as String?,
      saleId: json['saleId'] as String,
      isGantang: json['isGantang'] as bool,
      isSpecialPrice: json['isSpecialPrice'] as bool,
      isDiscounted: json['isDiscounted'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$SaleItemToJson(_SaleItem instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'product': instance.product,
      'quantity': const DecimalConverter().toJson(instance.quantity),
      'price': const NullableDecimalConverter().toJson(instance.price),
      'discountedPrice':
          const NullableDecimalConverter().toJson(instance.discountedPrice),
      'SackPrice': instance.sackPrice,
      'sackPriceId': instance.sackPriceId,
      'sackType': _$SackTypeEnumMap[instance.sackType],
      'perKiloPrice': instance.perKiloPrice,
      'perKiloPriceId': instance.perKiloPriceId,
      'saleId': instance.saleId,
      'isGantang': instance.isGantang,
      'isSpecialPrice': instance.isSpecialPrice,
      'isDiscounted': instance.isDiscounted,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$SackTypeEnumMap = {
  SackType.FIFTY_KG: 'FIFTY_KG',
  SackType.TWENTY_FIVE_KG: 'TWENTY_FIVE_KG',
  SackType.FIVE_KG: 'FIVE_KG',
};
