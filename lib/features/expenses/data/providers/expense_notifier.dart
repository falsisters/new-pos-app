import 'package:falsisters_pos_android/features/expenses/data/models/create_expense_list.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/expense_state.dart';
import 'package:falsisters_pos_android/features/expenses/data/repository/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseNotifier extends AsyncNotifier<ExpenseState> {
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  @override
  Future<ExpenseState> build() async {
    try {
      final expenseLists = await _expenseRepository.getExpenseList();
      return ExpenseState(
        expenseList: expenseLists,
      );
    } catch (e) {
      return ExpenseState(
        expenseList: null,
        error: e.toString(),
      );
    }
  }

  Future<ExpenseState> getExpenseList() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final expenseLists = await _expenseRepository.getExpenseList();

        return ExpenseState(
          expenseList: expenseLists,
        );
      } catch (e) {
        return ExpenseState(
          expenseList: null,
          error: e.toString(),
        );
      }
    });

    return state.value!;
  }

  Future<ExpenseState> getExpenseListByDate(DateTime date) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final expenseLists =
            await _expenseRepository.getExpenseListByDate(date);

        return ExpenseState(
          expenseList: expenseLists,
        );
      } catch (e) {
        return ExpenseState(
          expenseList: null,
          error: e.toString(),
        );
      }
    });

    return state.value!;
  }

  Future<ExpenseState> createExpense(CreateExpenseList expense) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final expenseLists = await _expenseRepository.createExpense(expense);

        return ExpenseState(
          expenseList: expenseLists,
        );
      } catch (e) {
        return ExpenseState(
          expenseList: null,
          error: e.toString(),
        );
      }
    });

    return state.value!;
  }

  Future<ExpenseState> updateExpense(
      String id, CreateExpenseList expense) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final expenseLists =
            await _expenseRepository.updateExpense(id, expense);

        return ExpenseState(
          expenseList: expenseLists,
        );
      } catch (e) {
        return ExpenseState(
          expenseList: null,
          error: e.toString(),
        );
      }
    });

    return state.value!;
  }
}
