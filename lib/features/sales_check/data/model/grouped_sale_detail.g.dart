// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_sale_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupedSaleDetail _$GroupedSaleDetailFromJson(Map<String, dynamic> json) =>
    _GroupedSaleDetail(
      quantity: const DecimalConverter().fromJson(json['quantity'] as String),
      unitPrice: const DecimalConverter().fromJson(json['unitPrice'] as String),
      totalAmount:
          const DecimalConverter().fromJson(json['totalAmount'] as String),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      isSpecialPrice: json['isSpecialPrice'] as bool,
      isDiscounted: json['isDiscounted'] as bool,
      discountedPrice: const NullableDecimalConverter()
          .fromJson(json['discountedPrice'] as String?),
      formattedSale: json['formattedSale'] as String,
    );

Map<String, dynamic> _$GroupedSaleDetailToJson(_GroupedSaleDetail instance) =>
    <String, dynamic>{
      'quantity': const DecimalConverter().toJson(instance.quantity),
      'unitPrice': const DecimalConverter().toJson(instance.unitPrice),
      'totalAmount': const DecimalConverter().toJson(instance.totalAmount),
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'isSpecialPrice': instance.isSpecialPrice,
      'isDiscounted': instance.isDiscounted,
      'discountedPrice':
          const NullableDecimalConverter().toJson(instance.discountedPrice),
      'formattedSale': instance.formattedSale,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.CHECK: 'CHECK',
  PaymentMethod.BANK_TRANSFER: 'BANK_TRANSFER',
};
