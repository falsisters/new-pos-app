// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_sale_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateSaleRequestModel _$CreateSaleRequestModelFromJson(
        Map<String, dynamic> json) =>
    _CreateSaleRequestModel(
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      saleItems: (json['saleItem'] as List<dynamic>)
          .map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateSaleRequestModelToJson(
        _CreateSaleRequestModel instance) =>
    <String, dynamic>{
      'totalAmount': instance.totalAmount,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'saleItem': instance.saleItems,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.CHECK: 'CHECK',
  PaymentMethod.BANK_TRANSFER: 'BANK_TRANSFER',
};
