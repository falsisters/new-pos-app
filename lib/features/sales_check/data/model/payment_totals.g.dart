// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_totals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentTotals _$PaymentTotalsFromJson(Map<String, dynamic> json) =>
    _PaymentTotals(
      cash: const DecimalConverter().fromJson(json['cash'] as String),
      check: const DecimalConverter().fromJson(json['check'] as String),
      bankTransfer:
          const DecimalConverter().fromJson(json['bankTransfer'] as String),
    );

Map<String, dynamic> _$PaymentTotalsToJson(_PaymentTotals instance) =>
    <String, dynamic>{
      'cash': const DecimalConverter().toJson(instance.cash),
      'check': const DecimalConverter().toJson(instance.check),
      'bankTransfer': const DecimalConverter().toJson(instance.bankTransfer),
    };
