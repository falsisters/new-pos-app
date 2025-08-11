// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profit_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfitItem _$ProfitItemFromJson(Map<String, dynamic> json) => _ProfitItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: const DecimalConverter().fromJson(json['quantity']),
      profitPerUnit: const DecimalConverter().fromJson(json['profitPerUnit']),
      totalProfit: const DecimalConverter().fromJson(json['totalProfit']),
      priceType: json['priceType'] as String,
      formattedPriceType: json['formattedPriceType'] as String,
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      isSpecialPrice: json['isSpecialPrice'] as bool,
      saleDate: DateTime.parse(json['saleDate'] as String),
      isAsin: json['isAsin'] as bool,
    );

Map<String, dynamic> _$ProfitItemToJson(_ProfitItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'quantity': const DecimalConverter().toJson(instance.quantity),
      'profitPerUnit': const DecimalConverter().toJson(instance.profitPerUnit),
      'totalProfit': const DecimalConverter().toJson(instance.totalProfit),
      'priceType': instance.priceType,
      'formattedPriceType': instance.formattedPriceType,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'isSpecialPrice': instance.isSpecialPrice,
      'saleDate': instance.saleDate.toIso8601String(),
      'isAsin': instance.isAsin,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.CHECK: 'CHECK',
  PaymentMethod.BANK_TRANSFER: 'BANK_TRANSFER',
};
