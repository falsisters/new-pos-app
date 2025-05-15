// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseItems _$ExpenseItemsFromJson(Map<String, dynamic> json) =>
    _ExpenseItems(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      expenseListId: json['expenseListId'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$ExpenseItemsToJson(_ExpenseItems instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'expenseListId': instance.expenseListId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
