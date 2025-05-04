// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfitResponse _$ProfitResponseFromJson(Map<String, dynamic> json) =>
    _ProfitResponse(
      sacks: ProfitCategory.fromJson(json['sacks'] as Map<String, dynamic>),
      asin: ProfitCategory.fromJson(json['asin'] as Map<String, dynamic>),
      overallTotal: (json['overallTotal'] as num).toDouble(),
      items: (json['rawItems'] as List<dynamic>)
          .map((e) => ProfitItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfitResponseToJson(_ProfitResponse instance) =>
    <String, dynamic>{
      'sacks': instance.sacks,
      'asin': instance.asin,
      'overallTotal': instance.overallTotal,
      'rawItems': instance.items,
    };
