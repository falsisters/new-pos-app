// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseList _$ExpenseListFromJson(Map<String, dynamic> json) => _ExpenseList(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      cashierId: json['cashierId'] as String?,
      expenseItems: (json['ExpenseItems'] as List<dynamic>)
          .map((e) => ExpenseItems.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$ExpenseListToJson(_ExpenseList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'cashierId': instance.cashierId,
      'ExpenseItems': instance.expenseItems,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
