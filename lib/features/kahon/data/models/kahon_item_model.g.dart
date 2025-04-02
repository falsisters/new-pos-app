// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kahon_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KahonItemModel _$KahonItemModelFromJson(Map<String, dynamic> json) =>
    _KahonItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      kahonId: json['kahonId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      cells: (json['Cells'] as List<dynamic>?)
              ?.map((e) => CellModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$KahonItemModelToJson(_KahonItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'kahonId': instance.kahonId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'Cells': instance.cells,
    };
