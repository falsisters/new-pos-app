// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_profit_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupedProfitItem _$GroupedProfitItemFromJson(Map<String, dynamic> json) =>
    _GroupedProfitItem(
      productName: json['productName'] as String,
      profitPerUnit: (json['profitPerUnit'] as num).toDouble(),
      totalQuantity: (json['totalQuantity'] as num).toDouble(),
      totalProfit: (json['totalProfit'] as num).toDouble(),
      orders: (json['orders'] as num).toInt(),
      formattedSummary: json['formattedSummary'] as String,
    );

Map<String, dynamic> _$GroupedProfitItemToJson(_GroupedProfitItem instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'profitPerUnit': instance.profitPerUnit,
      'totalQuantity': instance.totalQuantity,
      'totalProfit': instance.totalProfit,
      'orders': instance.orders,
      'formattedSummary': instance.formattedSummary,
    };
