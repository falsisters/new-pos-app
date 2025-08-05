import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_totals.freezed.dart';
part 'payment_totals.g.dart';

@freezed
sealed class PaymentTotals with _$PaymentTotals {
  const factory PaymentTotals({
    @DecimalConverter() required Decimal cash,
    @DecimalConverter() required Decimal check,
    @DecimalConverter() required Decimal bankTransfer,
  }) = _PaymentTotals;

  factory PaymentTotals.fromJson(Map<String, dynamic> json) =>
      _$PaymentTotalsFromJson(json);
}
