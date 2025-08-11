// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalesCheck _$SalesCheckFromJson(Map<String, dynamic> json) => _SalesCheck(
      id: json['id'] as String,
      cashierId: json['cashierId'] as String,
      totalAmount: const DecimalConverter().fromJson(json['totalAmount']),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      orderId: json['orderId'] as String?,
      saleItems: (json['SaleItem'] as List<dynamic>)
          .map((e) => SaleItemCheck.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SalesCheckToJson(_SalesCheck instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cashierId': instance.cashierId,
      'totalAmount': const DecimalConverter().toJson(instance.totalAmount),
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'orderId': instance.orderId,
      'SaleItem': instance.saleItems,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.CHECK: 'CHECK',
  PaymentMethod.BANK_TRANSFER: 'BANK_TRANSFER',
};
