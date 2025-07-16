// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_sale_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TotalSaleItem _$TotalSaleItemFromJson(Map<String, dynamic> json) =>
    _TotalSaleItem(
      id: json['id'] as String,
      saleId: json['saleId'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      product: ProductInfo.fromJson(json['product'] as Map<String, dynamic>),
      priceType: json['priceType'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      isSpecialPrice: json['isSpecialPrice'] as bool,
      isDiscounted: json['isDiscounted'] as bool,
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      saleDate: DateTime.parse(json['saleDate'] as String),
      formattedTime: json['formattedTime'] as String,
      formattedSale: json['formattedSale'] as String,
    );

Map<String, dynamic> _$TotalSaleItemToJson(_TotalSaleItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'saleId': instance.saleId,
      'quantity': instance.quantity,
      'product': instance.product,
      'priceType': instance.priceType,
      'unitPrice': instance.unitPrice,
      'totalAmount': instance.totalAmount,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'isSpecialPrice': instance.isSpecialPrice,
      'isDiscounted': instance.isDiscounted,
      'discountedPrice': instance.discountedPrice,
      'saleDate': instance.saleDate.toIso8601String(),
      'formattedTime': instance.formattedTime,
      'formattedSale': instance.formattedSale,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.CHECK: 'CHECK',
  PaymentMethod.BANK_TRANSFER: 'BANK_TRANSFER',
};
