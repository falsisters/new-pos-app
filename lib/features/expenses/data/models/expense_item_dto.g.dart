// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpenseItemDto _$ExpenseItemDtoFromJson(Map<String, dynamic> json) =>
    _ExpenseItemDto(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ExpenseItemDtoToJson(_ExpenseItemDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
    };
