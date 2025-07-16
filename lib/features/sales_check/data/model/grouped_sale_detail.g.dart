// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_sale_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupedSaleDetail _$GroupedSaleDetailFromJson(Map<String, dynamic> json) =>
    _GroupedSaleDetail(
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      isSpecialPrice: json['isSpecialPrice'] as bool,
      isDiscounted: json['isDiscounted'] as bool,
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      formattedSale: json['formattedSale'] as String,
    );

Map<String, dynamic> _$GroupedSaleDetailToJson(_GroupedSaleDetail instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'totalAmount': instance.totalAmount,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'isSpecialPrice': instance.isSpecialPrice,
      'isDiscounted': instance.isDiscounted,
      'discountedPrice': instance.discountedPrice,
      'formattedSale': instance.formattedSale,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.CHECK: 'CHECK',
  PaymentMethod.BANK_TRANSFER: 'BANK_TRANSFER',
};
