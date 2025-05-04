import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_totals.freezed.dart';
part 'payment_totals.g.dart';

@freezed
sealed class PaymentTotals with _$PaymentTotals {
  const factory PaymentTotals({
    required double cash,
    required double check,
    required double bankTransfer,
  }) = _PaymentTotals;

  factory PaymentTotals.fromJson(Map<String, dynamic> json) =>
      _$PaymentTotalsFromJson(json);
}
