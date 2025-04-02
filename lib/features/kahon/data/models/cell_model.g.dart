// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CellModel _$CellModelFromJson(Map<String, dynamic> json) => _CellModel(
      id: json['id'] as String,
      columnIndex: (json['columnIndex'] as num).toInt(),
      rowId: json['rowId'] as String,
      kahonItemId: json['kahonItemId'] as String?,
      value: json['value'] as String?,
      formula: json['formula'] as String?,
      isCalculated: json['isCalculated'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CellModelToJson(_CellModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'columnIndex': instance.columnIndex,
      'rowId': instance.rowId,
      'kahonItemId': instance.kahonItemId,
      'value': instance.value,
      'formula': instance.formula,
      'isCalculated': instance.isCalculated,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
