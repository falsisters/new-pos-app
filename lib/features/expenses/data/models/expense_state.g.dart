// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseState _$ExpenseStateFromJson(Map<String, dynamic> json) =>
    _ExpenseState(
      expenseList: json['expenseList'] == null
          ? null
          : ExpenseList.fromJson(json['expenseList'] as Map<String, dynamic>),
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ExpenseStateToJson(_ExpenseState instance) =>
    <String, dynamic>{
      'expenseList': instance.expenseList,
      'isLoading': instance.isLoading,
      'error': instance.error,
    };
