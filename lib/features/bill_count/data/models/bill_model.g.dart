// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillModel _$BillModelFromJson(Map<String, dynamic> json) => _BillModel(
      id: json['id'] as String?,
      type: $enumDecode(_$BillTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toInt(),
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$BillModelToJson(_BillModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$BillTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'value': instance.value,
    };

const _$BillTypeEnumMap = {
  BillType.THOUSAND: 'THOUSAND',
  BillType.FIVE_HUNDRED: 'FIVE_HUNDRED',
  BillType.HUNDRED: 'HUNDRED',
  BillType.FIFTY: 'FIFTY',
  BillType.TWENTY: 'TWENTY',
  BillType.COINS: 'COINS',
};
