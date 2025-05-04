// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_sales_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TotalSalesSummary _$TotalSalesSummaryFromJson(Map<String, dynamic> json) =>
    _TotalSalesSummary(
      totalQuantity: (json['totalQuantity'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      summaryPaymentTotals:
          PaymentTotals.fromJson(json['paymentTotals'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TotalSalesSummaryToJson(_TotalSalesSummary instance) =>
    <String, dynamic>{
      'totalQuantity': instance.totalQuantity,
      'totalAmount': instance.totalAmount,
      'paymentTotals': instance.summaryPaymentTotals,
    };
