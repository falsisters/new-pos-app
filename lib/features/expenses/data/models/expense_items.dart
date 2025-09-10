import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_items.freezed.dart';
part 'expense_items.g.dart';

@freezed
sealed class ExpenseItems with _$ExpenseItems {
  const factory ExpenseItems({
    required String id,
    required String name,
    @DecimalConverter() required Decimal amount,
    required String expenseListId,
    required String createdAt,
    required String updatedAt,
  }) = _ExpenseItems;

  factory ExpenseItems.fromJson(Map<String, dynamic> json) =>
      _$ExpenseItemsFromJson(json);
}
