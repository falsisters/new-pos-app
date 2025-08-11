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
      totalQuantity: const DecimalConverter().fromJson(json['totalQuantity']),
      totalAmount: const DecimalConverter().fromJson(json['totalAmount']),
      paymentTotals:
          PaymentTotals.fromJson(json['paymentTotals'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GroupedSalesCheckItemToJson(
        _GroupedSalesCheckItem instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'items': instance.items,
      'totalQuantity': const DecimalConverter().toJson(instance.totalQuantity),
      'totalAmount': const DecimalConverter().toJson(instance.totalAmount),
      'paymentTotals': instance.paymentTotals,
    };
