import 'package:falsisters_pos_android/features/expenses/data/models/create_expense_list.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/expense_state.dart';
import 'package:falsisters_pos_android/features/expenses/data/repository/expense_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseNotifier extends AsyncNotifier<ExpenseState> {
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  @override
  Future<ExpenseState> build() async {
    try {
      final expenseLists = await _expenseRepository.getExpenseList();
      if (expenseLists != null) {
        debugPrint(
            "Initial build: loaded ${expenseLists.expenseItems.length} expense items");
        return ExpenseState(
          expenseList: expenseLists,
        );
      } else {
        debugPrint("Initial build: no expense list found");
        return const ExpenseState();
      }
    } catch (e) {
      debugPrint("Error in initial build: ${e.toString()}");
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
        if (expenseLists != null) {
          debugPrint(
              "getExpenseList: loaded ${expenseLists.expenseItems.length} expense items");
          return ExpenseState(
            expenseList: expenseLists,
          );
        } else {
          debugPrint("getExpenseList: no expense list found");
          return const ExpenseState();
        }
      } catch (e) {
        debugPrint("Error in getExpenseList: ${e.toString()}");
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
        if (expenseLists != null) {
          debugPrint(
              "getExpenseListByDate: loaded ${expenseLists.expenseItems.length} expense items");
          return ExpenseState(
            expenseList: expenseLists,
          );
        } else {
          debugPrint("getExpenseListByDate: no expense list found for date");
          return const ExpenseState();
        }
      } catch (e) {
        debugPrint("Error in getExpenseListByDate: ${e.toString()}");
        return ExpenseState(
          expenseList: null,
          error: e.toString(),
        );
      }
    });

    return state.value!;
  }

  Future<void> createExpense(CreateExpenseList expense,
      {DateTime? targetDate}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        debugPrint(
            "Creating expense with ${expense.expenseItems.length} items");

        // Add date to expense if provided
        final expenseWithDate = targetDate != null
            ? CreateExpenseList(
                expenseItems: expense.expenseItems,
                date:
                    '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}',
              )
            : expense;

        final expenseLists =
            await _expenseRepository.createExpense(expenseWithDate);

        if (expenseLists != null) {
          debugPrint(
              "Successfully created expense list with ID: ${expenseLists.id}");
          debugPrint(
              "Returned items count: ${expenseLists.expenseItems.length}");
          return ExpenseState(
            expenseList: expenseLists,
          );
        } else {
          debugPrint("createExpense: server returned null");
          return const ExpenseState();
        }
      } catch (e) {
        debugPrint("Error creating expense: ${e.toString()}");
        return ExpenseState(
          expenseList: null,
          error: e.toString(),
        );
      }
    });
  }

  Future<void> updateExpense(String id, CreateExpenseList expense,
      {DateTime? targetDate}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        debugPrint(
            "Updating expense ID: $id with ${expense.expenseItems.length} items");

        // Add date to expense if provided
        final expenseWithDate = targetDate != null
            ? CreateExpenseList(
                expenseItems: expense.expenseItems,
                date:
                    '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}',
              )
            : expense;

        final expenseLists =
            await _expenseRepository.updateExpense(id, expenseWithDate);

        if (expenseLists != null) {
          debugPrint(
              "Successfully updated expense list with ID: ${expenseLists.id}");
          debugPrint(
              "Returned items count: ${expenseLists.expenseItems.length}");
          return ExpenseState(
            expenseList: expenseLists,
          );
        } else {
          debugPrint("updateExpense: server returned null");
          return const ExpenseState();
        }
      } catch (e) {
        debugPrint("Error updating expense: ${e.toString()}");
        return ExpenseState(
          expenseList: null,
          error: e.toString(),
        );
      }
    });
  }

  Future<void> deleteExpense(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        debugPrint("Deleting expense ID: $id");
        await _expenseRepository.deleteExpense(id);
        debugPrint("Successfully deleted expense");

        // Return empty state after deletion
        return const ExpenseState();
      } catch (e) {
        debugPrint("Error deleting expense: ${e.toString()}");
        return ExpenseState(
          expenseList: null,
          error: e.toString(),
        );
      }
    });
  }
}
