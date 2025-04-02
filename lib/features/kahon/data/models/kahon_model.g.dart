// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kahon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KahonModel _$KahonModelFromJson(Map<String, dynamic> json) => _KahonModel(
      id: json['id'] as String,
      name: json['name'] as String,
      cashierId: json['cashierId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      kahonItems: (json['KahonItems'] as List<dynamic>?)
              ?.map((e) => KahonItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      sheets: (json['Sheets'] as List<dynamic>?)
              ?.map((e) => SheetModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$KahonModelToJson(_KahonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cashierId': instance.cashierId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'KahonItems': instance.kahonItems,
      'Sheets': instance.sheets,
    };
