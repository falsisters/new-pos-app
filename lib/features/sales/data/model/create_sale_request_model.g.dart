// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_sale_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateSaleRequestModel _$CreateSaleRequestModelFromJson(
        Map<String, dynamic> json) =>
    _CreateSaleRequestModel(
      orderId: json['orderId'] as String?,
      totalAmount:
          const DecimalConverter().fromJson(json['totalAmount'] as String),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      saleItems: (json['saleItem'] as List<dynamic>)
          .map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      changeAmount: const NullableDecimalConverter()
          .fromJson(json['changeAmount'] as String?),
      cashierId: json['cashierId'] as String?,
      cashierName: json['cashierName'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CreateSaleRequestModelToJson(
        _CreateSaleRequestModel instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'totalAmount': const DecimalConverter().toJson(instance.totalAmount),
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'saleItem': instance.saleItems,
      'changeAmount':
          const NullableDecimalConverter().toJson(instance.changeAmount),
      'cashierId': instance.cashierId,
      'cashierName': instance.cashierName,
      'metadata': instance.metadata,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.CHECK: 'CHECK',
  PaymentMethod.BANK_TRANSFER: 'BANK_TRANSFER',
};
