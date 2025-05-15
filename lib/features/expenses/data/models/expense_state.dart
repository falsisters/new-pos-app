import 'package:falsisters_pos_android/features/expenses/data/models/expense_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_state.freezed.dart';
part 'expense_state.g.dart';

@freezed
sealed class ExpenseState with _$ExpenseState {
  const factory ExpenseState({
    ExpenseList? expenseList, // Made nullable
    @Default(false) bool isLoading,
    String? error,
  }) = _ExpenseState;

  factory ExpenseState.fromJson(Map<String, dynamic> json) =>
      _$ExpenseStateFromJson(json);
}
