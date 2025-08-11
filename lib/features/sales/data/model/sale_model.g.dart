// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleModel _$SaleModelFromJson(Map<String, dynamic> json) => _SaleModel(
      id: json['id'] as String,
      cashierId: json['cashierId'] as String,
      totalAmount: const DecimalConverter().fromJson(json['totalAmount']),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      saleItems: (json['SaleItem'] as List<dynamic>?)
              ?.map((e) => SaleItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SaleModelToJson(_SaleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cashierId': instance.cashierId,
      'totalAmount': const DecimalConverter().toJson(instance.totalAmount),
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'SaleItem': instance.saleItems,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'metadata': instance.metadata,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.CHECK: 'CHECK',
  PaymentMethod.BANK_TRANSFER: 'BANK_TRANSFER',
};
