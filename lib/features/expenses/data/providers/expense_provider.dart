import 'package:falsisters_pos_android/features/expenses/data/models/expense_state.dart';
import 'package:falsisters_pos_android/features/expenses/data/providers/expense_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseProvider =
    AsyncNotifierProvider<ExpenseNotifier, ExpenseState>(() {
  return ExpenseNotifier();
});
