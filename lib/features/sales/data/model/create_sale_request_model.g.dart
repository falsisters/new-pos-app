// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_sale_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateSaleRequestModel _$CreateSaleRequestModelFromJson(
        Map<String, dynamic> json) =>
    _CreateSaleRequestModel(
      orderId: json['orderId'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      saleItems: (json['saleItem'] as List<dynamic>)
          .map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      changeAmount: (json['changeAmount'] as num?)?.toDouble(),
      cashierId: json['cashierId'] as String?,
      cashierName: json['cashierName'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CreateSaleRequestModelToJson(
        _CreateSaleRequestModel instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'totalAmount': instance.totalAmount,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'saleItem': instance.saleItems,
      'changeAmount': instance.changeAmount,
      'cashierId': instance.cashierId,
      'cashierName': instance.cashierName,
      'metadata': instance.metadata,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.CHECK: 'CHECK',
  PaymentMethod.BANK_TRANSFER: 'BANK_TRANSFER',
};
