// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sheet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SheetState _$SheetStateFromJson(Map<String, dynamic> json) => _SheetState(
      sheet: json['sheet'] == null
          ? null
          : SheetModel.fromJson(json['sheet'] as Map<String, dynamic>),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$SheetStateToJson(_SheetState instance) =>
    <String, dynamic>{
      'sheet': instance.sheet,
      'error': instance.error,
    };
