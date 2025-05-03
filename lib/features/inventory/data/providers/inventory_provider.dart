import 'package:falsisters_pos_android/features/inventory/data/models/expenses_state.dart';
import 'package:falsisters_pos_android/features/inventory/data/models/inventory_state.dart';
import 'package:falsisters_pos_android/features/inventory/data/providers/expenses_notifier.dart';
import 'package:falsisters_pos_android/features/inventory/data/providers/inventory_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final inventoryProvider =
    AsyncNotifierProvider<InventoryNotifier, InventoryState>(
  () => InventoryNotifier(),
);

final expensesProvider = AsyncNotifierProvider<ExpensesNotifier, ExpensesState>(
  () => ExpensesNotifier(),
);
