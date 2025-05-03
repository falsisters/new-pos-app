// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpensesState _$ExpensesStateFromJson(Map<String, dynamic> json) =>
    _ExpensesState(
      sheet: json['sheet'] == null
          ? null
          : InventorySheetModel.fromJson(json['sheet'] as Map<String, dynamic>),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ExpensesStateToJson(_ExpensesState instance) =>
    <String, dynamic>{
      'sheet': instance.sheet,
      'error': instance.error,
    };
