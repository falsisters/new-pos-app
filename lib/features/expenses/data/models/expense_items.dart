import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_items.freezed.dart';
part 'expense_items.g.dart';

@freezed
sealed class ExpenseItems with _$ExpenseItems {
  const factory ExpenseItems({
    required String id,
    required String name,
    required double amount,
    required String expenseListId,
    required String createdAt,
    required String updatedAt,
  }) = _ExpenseItems;

  factory ExpenseItems.fromJson(Map<String, dynamic> json) =>
      _$ExpenseItemsFromJson(json);
}
