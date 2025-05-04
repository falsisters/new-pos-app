// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_totals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentTotals _$PaymentTotalsFromJson(Map<String, dynamic> json) =>
    _PaymentTotals(
      cash: (json['cash'] as num).toDouble(),
      check: (json['check'] as num).toDouble(),
      bankTransfer: (json['bankTransfer'] as num).toDouble(),
    );

Map<String, dynamic> _$PaymentTotalsToJson(_PaymentTotals instance) =>
    <String, dynamic>{
      'cash': instance.cash,
      'check': instance.check,
      'bankTransfer': instance.bankTransfer,
    };
