import 'package:falsisters_pos_android/features/expenses/data/models/expense_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_state.freezed.dart';

@freezed
sealed class ExpenseState with _$ExpenseState {
  const factory ExpenseState({
    ExpenseList? expenseList,
    @Default(false) bool isLoading,
    String? error,
  }) = _ExpenseState;
}
