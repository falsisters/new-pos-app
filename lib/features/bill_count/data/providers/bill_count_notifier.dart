import 'package:falsisters_pos_android/features/bill_count/data/models/bill_count_model.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_count_state.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_model.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_type.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/create_bill_count_request_model.dart';
import 'package:falsisters_pos_android/features/bill_count/data/repository/bill_count_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BillCountNotifier extends AsyncNotifier<BillCountState> {
  final BillCountRepository _billCountRepository = BillCountRepository();

  @override
  Future<BillCountState> build() async {
    // Initial state with empty bill count
    return const BillCountState();
  }

  // Load bill count data for a specific date (or today if no date provided)
  Future<void> loadBillCountForDate({String? date}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final billCount =
            await _billCountRepository.getBillCountForDate(date: date);

        // If no bill count exists, create an empty one
        if (billCount == null) {
          return const BillCountState(
            billCount: BillCountModel(),
          );
        }

        return BillCountState(billCount: billCount);
      } catch (e) {
        return BillCountState(error: e.toString());
      }
    });
  }

  // Update bill amount
  Future<void> updateBillAmount(BillType type, int amount) async {
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final currentBillCount = currentState.billCount ?? const BillCountModel();

      // Find if bill of this type already exists
      final bills = List<BillModel>.from(currentBillCount.bills);

      // Replace or add the bill with the new amount
      bool found = false;
      for (int i = 0; i < bills.length; i++) {
        if (bills[i].type == type) {
          bills[i] = BillModel(
            id: bills[i].id,
            type: type,
            amount: amount,
            value: amount * type.value,
          );
          found = true;
          break;
        }
      }

      if (!found) {
        bills.add(BillModel(
          type: type,
          amount: amount,
          value: amount * type.value,
        ));
      }

      // Calculate the new total
      final billsTotal = bills.fold<double>(
        0,
        (sum, bill) => sum + (bill.amount * bill.type.value),
      );

      // Calculate totalWithExpenses
      final totalWithExpenses = billsTotal +
          (currentBillCount.showExpenses ? currentBillCount.expenses : 0);

      // Calculate finalTotal
      final finalTotal = totalWithExpenses -
          (currentBillCount.showBeginningBalance
              ? currentBillCount.beginningBalance
              : 0);

      // Create updated bill count
      final updatedBillCount = currentBillCount.copyWith(
        bills: bills,
        billsTotal: billsTotal,
        totalWithExpenses: totalWithExpenses,
        finalTotal: finalTotal,
      );

      return BillCountState(billCount: updatedBillCount);
    });
  }

  // Toggle expenses visibility
  Future<void> toggleExpensesVisibility() async {
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final currentBillCount = currentState.billCount ?? const BillCountModel();

      final showExpenses = !currentBillCount.showExpenses;

      // Update the total with expenses
      final totalWithExpenses = currentBillCount.billsTotal +
          (showExpenses ? currentBillCount.expenses : 0);

      // Update final total
      final finalTotal = totalWithExpenses -
          (currentBillCount.showBeginningBalance
              ? currentBillCount.beginningBalance
              : 0);

      final updatedBillCount = currentBillCount.copyWith(
        showExpenses: showExpenses,
        totalWithExpenses: totalWithExpenses,
        finalTotal: finalTotal,
      );

      return BillCountState(billCount: updatedBillCount);
    });
  }

  // Update expenses value
  Future<void> updateExpenses(double expenses) async {
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final currentBillCount = currentState.billCount ?? const BillCountModel();

      // Update the total with expenses
      final totalWithExpenses = currentBillCount.billsTotal +
          (currentBillCount.showExpenses ? expenses : 0);

      // Update final total
      final finalTotal = totalWithExpenses -
          (currentBillCount.showBeginningBalance
              ? currentBillCount.beginningBalance
              : 0);

      final updatedBillCount = currentBillCount.copyWith(
        expenses: expenses,
        totalWithExpenses: totalWithExpenses,
        finalTotal: finalTotal,
      );

      return BillCountState(billCount: updatedBillCount);
    });
  }

  // Toggle beginning balance visibility
  Future<void> toggleBeginningBalanceVisibility() async {
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final currentBillCount = currentState.billCount ?? const BillCountModel();

      final showBeginningBalance = !currentBillCount.showBeginningBalance;

      // Update final total
      final finalTotal = currentBillCount.totalWithExpenses -
          (showBeginningBalance ? currentBillCount.beginningBalance : 0);

      final updatedBillCount = currentBillCount.copyWith(
        showBeginningBalance: showBeginningBalance,
        finalTotal: finalTotal,
      );

      return BillCountState(billCount: updatedBillCount);
    });
  }

  // Update beginning balance value
  Future<void> updateBeginningBalance(double beginningBalance) async {
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final currentBillCount = currentState.billCount ?? const BillCountModel();

      // Update final total
      final finalTotal = currentBillCount.totalWithExpenses -
          (currentBillCount.showBeginningBalance ? beginningBalance : 0);

      final updatedBillCount = currentBillCount.copyWith(
        beginningBalance: beginningBalance,
        finalTotal: finalTotal,
      );

      return BillCountState(billCount: updatedBillCount);
    });
  }

  // Save current bill count to server
  Future<void> saveBillCount({String? date}) async {
    state = const AsyncLoading();

    final currentState = state.value;

    state = await AsyncValue.guard(() async {
      try {
        if (currentState == null) {
          throw Exception('No current state available');
        }

        final currentBillCount = currentState.billCount;

        if (currentBillCount == null) {
          throw Exception('No bill count data to save');
        }

        final request = CreateBillCountRequestModel(
          date: date,
          expenses: currentBillCount.expenses,
          showExpenses: currentBillCount.showExpenses,
          beginningBalance: currentBillCount.beginningBalance,
          showBeginningBalance: currentBillCount.showBeginningBalance,
          bills: currentBillCount.bills,
        );

        // If we have an ID, update the existing bill count, otherwise create a new one
        final BillCountModel savedBillCount;
        if (currentBillCount.id != null) {
          savedBillCount = await _billCountRepository.updateBillCount(
            currentBillCount.id!,
            request,
          );
        } else {
          savedBillCount =
              await _billCountRepository.createOrUpdateBillCount(request);
        }

        return BillCountState(billCount: savedBillCount);
      } catch (e) {
        return BillCountState(
          billCount: currentState?.billCount,
          error: e.toString(),
        );
      }
    });
  }
}
