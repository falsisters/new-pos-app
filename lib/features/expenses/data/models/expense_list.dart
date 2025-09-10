import 'package:falsisters_pos_android/features/expenses/data/models/expense_items.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_list.freezed.dart';

@freezed
sealed class ExpenseList with _$ExpenseList {
  const factory ExpenseList({
    required String id,
    String? userId,
    String? cashierId,
    required String createdAt,
    required String updatedAt,
    required List<ExpenseItems> expenseItems,
  }) = _ExpenseList;

  factory ExpenseList.fromJson(Map<String, dynamic> json) {
    // Handle the ExpenseItems key from server response
    final expenseItemsJson = json['ExpenseItems'] as List<dynamic>? ?? [];

    return ExpenseList(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      cashierId: json['cashierId'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      expenseItems: expenseItemsJson
          .map((item) => ExpenseItems.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
