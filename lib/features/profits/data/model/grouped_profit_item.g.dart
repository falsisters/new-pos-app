// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_profit_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupedProfitItem _$GroupedProfitItemFromJson(Map<String, dynamic> json) =>
    _GroupedProfitItem(
      productName: json['productName'] as String,
      profitPerUnit:
          const DecimalConverter().fromJson(json['profitPerUnit'] as String),
      totalQuantity:
          const DecimalConverter().fromJson(json['totalQuantity'] as String),
      totalProfit:
          const DecimalConverter().fromJson(json['totalProfit'] as String),
      orders: (json['orders'] as num).toInt(),
      formattedSummary: json['formattedSummary'] as String,
    );

Map<String, dynamic> _$GroupedProfitItemToJson(_GroupedProfitItem instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'profitPerUnit': const DecimalConverter().toJson(instance.profitPerUnit),
      'totalQuantity': const DecimalConverter().toJson(instance.totalQuantity),
      'totalProfit': const DecimalConverter().toJson(instance.totalProfit),
      'orders': instance.orders,
      'formattedSummary': instance.formattedSummary,
    };
