// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_expense_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateExpenseList _$CreateExpenseListFromJson(Map<String, dynamic> json) =>
    _CreateExpenseList(
      expenseItems: (json['expenseItems'] as List<dynamic>)
          .map((e) => ExpenseItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: json['date'] as String?,
    );

Map<String, dynamic> _$CreateExpenseListToJson(_CreateExpenseList instance) =>
    <String, dynamic>{
      'expenseItems': instance.expenseItems,
      'date': instance.date,
    };
