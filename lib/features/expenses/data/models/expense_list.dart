// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/expenses/data/models/expense_items.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_list.freezed.dart';
part 'expense_list.g.dart';

@freezed
sealed class ExpenseList with _$ExpenseList {
  const ExpenseList._(); // Add this private constructor
  const factory ExpenseList({
    required int id,
    required String userId,
    @JsonKey(name: 'ExpenseItems') required List<ExpenseItems> expenseItems,
    required String createdAt,
    required String updatedAt,
  }) = _ExpenseList;

  factory ExpenseList.fromJson(Map<String, dynamic> json) =>
      _$ExpenseListFromJson(json);

  double get totalAmount =>
      expenseItems.fold(0.0, (sum, item) => sum + item.amount);
}
