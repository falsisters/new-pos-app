// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfitCategory _$ProfitCategoryFromJson(Map<String, dynamic> json) =>
    _ProfitCategory(
      items: (json['items'] as List<dynamic>)
          .map((e) => GroupedProfitItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalProfit: (json['totalProfit'] as num).toDouble(),
    );

Map<String, dynamic> _$ProfitCategoryToJson(_ProfitCategory instance) =>
    <String, dynamic>{
      'items': instance.items,
      'totalProfit': instance.totalProfit,
    };
