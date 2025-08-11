// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_sale_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TotalSaleItem _$TotalSaleItemFromJson(Map<String, dynamic> json) =>
    _TotalSaleItem(
      id: json['id'] as String,
      saleId: json['saleId'] as String,
      quantity: const DecimalConverter().fromJson(json['quantity']),
      product: ProductInfo.fromJson(json['product'] as Map<String, dynamic>),
      priceType: json['priceType'] as String,
      unitPrice: const DecimalConverter().fromJson(json['unitPrice']),
      totalAmount: const DecimalConverter().fromJson(json['totalAmount']),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      isSpecialPrice: json['isSpecialPrice'] as bool,
      isDiscounted: json['isDiscounted'] as bool,
      discountedPrice:
          const NullableDecimalConverter().fromJson(json['discountedPrice']),
      saleDate: DateTime.parse(json['saleDate'] as String),
      formattedTime: json['formattedTime'] as String,
      formattedSale: json['formattedSale'] as String,
    );

Map<String, dynamic> _$TotalSaleItemToJson(_TotalSaleItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'saleId': instance.saleId,
      'quantity': const DecimalConverter().toJson(instance.quantity),
      'product': instance.product,
      'priceType': instance.priceType,
      'unitPrice': const DecimalConverter().toJson(instance.unitPrice),
      'totalAmount': const DecimalConverter().toJson(instance.totalAmount),
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'isSpecialPrice': instance.isSpecialPrice,
      'isDiscounted': instance.isDiscounted,
      'discountedPrice':
          const NullableDecimalConverter().toJson(instance.discountedPrice),
      'saleDate': instance.saleDate.toIso8601String(),
      'formattedTime': instance.formattedTime,
      'formattedSale': instance.formattedSale,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.CHECK: 'CHECK',
  PaymentMethod.BANK_TRANSFER: 'BANK_TRANSFER',
};
