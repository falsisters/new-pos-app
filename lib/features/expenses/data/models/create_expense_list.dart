import 'package:falsisters_pos_android/features/expenses/data/models/expense_item_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_expense_list.freezed.dart';
part 'create_expense_list.g.dart';

@freezed
sealed class CreateExpenseList with _$CreateExpenseList {
  const factory CreateExpenseList({
    required List<ExpenseItemDto> expenseItems,
    String? date, // Optional date field for backend
  }) = _CreateExpenseList;

  factory CreateExpenseList.fromJson(Map<String, dynamic> json) =>
      _$CreateExpenseListFromJson(json);
}
