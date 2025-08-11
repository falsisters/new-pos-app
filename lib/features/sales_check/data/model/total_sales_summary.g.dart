// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_sales_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TotalSalesSummary _$TotalSalesSummaryFromJson(Map<String, dynamic> json) =>
    _TotalSalesSummary(
      totalQuantity: const DecimalConverter().fromJson(json['totalQuantity']),
      totalAmount: const DecimalConverter().fromJson(json['totalAmount']),
      summaryPaymentTotals:
          PaymentTotals.fromJson(json['paymentTotals'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TotalSalesSummaryToJson(_TotalSalesSummary instance) =>
    <String, dynamic>{
      'totalQuantity': const DecimalConverter().toJson(instance.totalQuantity),
      'totalAmount': const DecimalConverter().toJson(instance.totalAmount),
      'paymentTotals': instance.summaryPaymentTotals,
    };
