// ignore_for_file: invalid_annotation_target

import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/payment_totals.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'total_sales_summary.freezed.dart';
part 'total_sales_summary.g.dart';

@unfreezed // Use unfreezed to allow adding custom toJson easily
sealed class TotalSalesSummary with _$TotalSalesSummary {
  factory TotalSalesSummary({
    @DecimalConverter() required Decimal totalQuantity,
    @DecimalConverter() required Decimal totalAmount,
    // Use JsonKey to handle the nested structure during serialization/deserialization
    @JsonKey(name: 'paymentTotals') required PaymentTotals summaryPaymentTotals,
  }) = _TotalSalesSummary;

  factory TotalSalesSummary.fromJson(Map<String, dynamic> json) =>
      _$TotalSalesSummaryFromJson(json);

  // No need for custom toJson if using @JsonKey correctly with build_runner
  // Map<String, dynamic> toJson() => _$TotalSalesSummaryToJson(this); // Rely on generated toJson
}
