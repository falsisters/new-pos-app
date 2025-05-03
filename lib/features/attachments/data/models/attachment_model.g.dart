// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttachmentModel _$AttachmentModelFromJson(Map<String, dynamic> json) =>
    _AttachmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      type: $enumDecode(_$AttachmentTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$AttachmentModelToJson(_AttachmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'type': _$AttachmentTypeEnumMap[instance.type]!,
    };

const _$AttachmentTypeEnumMap = {
  AttachmentType.EXPENSE_RECEIPT: 'EXPENSE_RECEIPT',
  AttachmentType.CHECKS_AND_BANK_TRANSFER: 'CHECKS_AND_BANK_TRANSFER',
  AttachmentType.INVENTORIES: 'INVENTORIES',
  AttachmentType.SUPPORTING_DOCUMENTS: 'SUPPORTING_DOCUMENTS',
};
