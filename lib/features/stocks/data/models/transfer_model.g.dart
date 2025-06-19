// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferModel _$TransferModelFromJson(Map<String, dynamic> json) =>
    _TransferModel(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      name: json['name'] as String,
      type: $enumDecode(_$TransferTypeEnumMap, json['type']),
      cashierId: json['cashierId'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$TransferModelToJson(_TransferModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'name': instance.name,
      'type': _$TransferTypeEnumMap[instance.type]!,
      'cashierId': instance.cashierId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$TransferTypeEnumMap = {
  TransferType.KAHON: 'KAHON',
  TransferType.OWN_CONSUMPTION: 'OWN_CONSUMPTION',
  TransferType.RETURN_TO_WAREHOUSE: 'RETURN_TO_WAREHOUSE',
  TransferType.REPACK: 'REPACK',
};
