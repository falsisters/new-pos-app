// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_sheet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventorySheetModel _$InventorySheetModelFromJson(Map<String, dynamic> json) =>
    _InventorySheetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      inventoryId: json['inventoryId'] as String,
      columns: (json['columns'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      rows: (json['Rows'] as List<dynamic>?)
              ?.map(
                  (e) => InventoryRowModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$InventorySheetModelToJson(
        _InventorySheetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'inventoryId': instance.inventoryId,
      'columns': instance.columns,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'Rows': instance.rows,
    };
