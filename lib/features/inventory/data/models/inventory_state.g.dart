// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryState _$InventoryStateFromJson(Map<String, dynamic> json) =>
    _InventoryState(
      sheet: json['sheet'] == null
          ? null
          : InventorySheetModel.fromJson(json['sheet'] as Map<String, dynamic>),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$InventoryStateToJson(_InventoryState instance) =>
    <String, dynamic>{
      'sheet': instance.sheet,
      'error': instance.error,
    };
