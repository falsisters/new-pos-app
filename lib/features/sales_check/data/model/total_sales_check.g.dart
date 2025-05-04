// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_sales_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TotalSalesCheck _$TotalSalesCheckFromJson(Map<String, dynamic> json) =>
    _TotalSalesCheck(
      items: (json['items'] as List<dynamic>)
          .map((e) => TotalSaleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary:
          TotalSalesSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TotalSalesCheckToJson(_TotalSalesCheck instance) =>
    <String, dynamic>{
      'items': instance.items,
      'summary': instance.summary,
    };
