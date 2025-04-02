// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sheet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SheetModel _$SheetModelFromJson(Map<String, dynamic> json) => _SheetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      kahonId: json['kahonId'] as String,
      columns: (json['columns'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      rows: (json['Rows'] as List<dynamic>?)
              ?.map((e) => RowModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SheetModelToJson(_SheetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kahonId': instance.kahonId,
      'columns': instance.columns,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'Rows': instance.rows,
    };
