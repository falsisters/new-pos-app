// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'row_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RowModel _$RowModelFromJson(Map<String, dynamic> json) => _RowModel(
      id: json['id'] as String,
      rowIndex: (json['rowIndex'] as num).toInt(),
      sheetId: json['sheetId'] as String,
      isItemRow: json['isItemRow'] as bool,
      itemId: json['itemId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      cells: (json['Cells'] as List<dynamic>?)
              ?.map((e) => CellModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RowModelToJson(_RowModel instance) => <String, dynamic>{
      'id': instance.id,
      'rowIndex': instance.rowIndex,
      'sheetId': instance.sheetId,
      'isItemRow': instance.isItemRow,
      'itemId': instance.itemId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'Cells': instance.cells,
    };
