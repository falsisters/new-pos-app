// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_sales_check_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupedSalesCheckItem _$GroupedSalesCheckItemFromJson(
        Map<String, dynamic> json) =>
    _GroupedSalesCheckItem(
      productName: json['productName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => GroupedSaleDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalQuantity: (json['totalQuantity'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentTotals:
          PaymentTotals.fromJson(json['paymentTotals'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GroupedSalesCheckItemToJson(
        _GroupedSalesCheckItem instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'items': instance.items,
      'totalQuantity': instance.totalQuantity,
      'totalAmount': instance.totalAmount,
      'paymentTotals': instance.paymentTotals,
    };
