// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_cell_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryCellModel _$InventoryCellModelFromJson(Map<String, dynamic> json) =>
    _InventoryCellModel(
      id: json['id'] as String,
      columnIndex: (json['columnIndex'] as num).toInt(),
      inventoryRowId: json['inventoryRowId'] as String,
      value: json['value'] as String?,
      formula: json['formula'] as String?,
      isCalculated: json['isCalculated'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InventoryCellModelToJson(_InventoryCellModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'columnIndex': instance.columnIndex,
      'inventoryRowId': instance.inventoryRowId,
      'value': instance.value,
      'formula': instance.formula,
      'isCalculated': instance.isCalculated,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
