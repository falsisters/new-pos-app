// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_row_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryRowModel _$InventoryRowModelFromJson(Map<String, dynamic> json) =>
    _InventoryRowModel(
      id: json['id'] as String,
      rowIndex: (json['rowIndex'] as num).toInt(),
      inventorySheetId: json['inventorySheetId'] as String,
      isItemRow: json['isItemRow'] as bool,
      itemId: json['itemId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      cells: (json['Cells'] as List<dynamic>?)
              ?.map(
                  (e) => InventoryCellModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$InventoryRowModelToJson(_InventoryRowModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rowIndex': instance.rowIndex,
      'inventorySheetId': instance.inventorySheetId,
      'isItemRow': instance.isItemRow,
      'itemId': instance.itemId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'Cells': instance.cells,
    };
