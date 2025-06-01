import 'package:falsisters_pos_android/features/bill_count/data/models/bill_count_model.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_count_state.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_model.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_type.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/create_bill_count_request_model.dart';
import 'package:falsisters_pos_android/features/bill_count/data/repository/bill_count_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

        // If no bill count exists, return null to show the creation UI
        if (billCount == null) {
          return const BillCountState(billCount: null);
        }

        print("Loaded bill count: ${billCount.toJson()}");
        return BillCountState(billCount: billCount);
      } catch (e) {
        print("Error loading bill count: $e");
        return BillCountState(error: e.toString());
      }
    });
  }

  // Create a new bill count for a specific date
  Future<void> createNewBillCount({String? date}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        // Parse the date or use today
        DateTime billDate;
        if (date != null) {
          try {
            billDate = DateFormat('yyyy-MM-dd').parse(date);
          } catch (e) {
            billDate = DateTime.now();
          }
        } else {
          billDate = DateTime.now();
        }

        // Initialize empty billsByType with all bill types
        final Map<String, dynamic> emptyBillsByType = {};
        for (var type in BillType.values) {
          emptyBillsByType[type.name] = 0;
        }

        // Create an empty bill count model
        final newBillCount = BillCountModel(
          date: billDate,
          bills: [],
          billsByType: emptyBillsByType,
          billsTotal: 0,
          totalWithExpenses: 0,
          finalTotal: 0,
        );

        return BillCountState(billCount: newBillCount);
      } catch (e) {
        return BillCountState(error: e.toString());
      }
    });
  }

  // Create and save a new bill count for a specific date with zero values
  Future<void> createAndSaveBillCount({String? date}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        // Parse the date or use today
        DateTime billDate;
        if (date != null) {
          try {
            billDate = DateFormat('yyyy-MM-dd').parse(date);
          } catch (e) {
            billDate = DateTime.now();
          }
        } else {
          billDate = DateTime.now();
        }

        final formattedDate = DateFormat('yyyy-MM-dd').format(billDate);

        // Create bills list with zero values for all types
        final billsList = <BillModel>[];
        for (var billType in BillType.values) {
          billsList.add(BillModel(
            type: billType,
            amount: 0,
            value: 0.0,
          ));
        }

        // Create the request model with all zero values
        final request = CreateBillCountRequestModel(
          date: formattedDate,
          startingAmount: 0.0,
          expenses: 0.0,
          showExpenses: false,
          beginningBalance: 0.0,
          showBeginningBalance: false,
          bills: billsList,
        );

        print(
            "Creating new bill count with zero values for date: $formattedDate");

        // Save to server immediately
        final savedBillCount =
            await _billCountRepository.createOrUpdateBillCount(request);

        print("Bill count created successfully with ID: ${savedBillCount.id}");
        print("Server returned totalCash: ${savedBillCount.totalCash}");

        return BillCountState(billCount: savedBillCount);
      } catch (e) {
        print("Error creating and saving bill count: $e");
        return BillCountState(error: e.toString());
      }
    });
  }

  // Update bill amount - only update local state
  Future<void> updateBillAmount(BillType type, int amount) async {
    final currentState = state.value!;
    final currentBillCount = currentState.billCount ?? const BillCountModel();

    print("Updating bill amount for ${type.name} to $amount");

    // Make a copy of the current bills list
    final bills = List<BillModel>.from(currentBillCount.bills);

    // Create a copy of the billsByType map for modification
    final Map<String, dynamic> updatedBillsByType =
        Map<String, dynamic>.from(currentBillCount.billsByType);

    // Update the billsByType map directly - only update the specific type
    updatedBillsByType[type.name] = amount;

    // Find and update the existing bill or add a new one if needed
    bool found = false;
    for (int i = 0; i < bills.length; i++) {
      if (bills[i].type == type) {
        bills[i] = BillModel(
          id: bills[i].id,
          type: type,
          amount: amount,
          value: (amount * type.value).toDouble(),
        );
        found = true;
        break;
      }
    }

    // Add a new bill if not found
    if (!found) {
      bills.add(BillModel(
        type: type,
        amount: amount,
        value: (amount * type.value).toDouble(),
      ));
    }

    // Make sure all bill types are represented in the bills list
    for (var billType in BillType.values) {
      bool typeExists = bills.any((bill) => bill.type == billType);
      if (!typeExists) {
        // Add the missing bill type with amount from billsByType
        int typeAmount = _getIntValue(updatedBillsByType[billType.name]);
        bills.add(BillModel(
          type: billType,
          amount: typeAmount,
          value: (typeAmount * billType.value).toDouble(),
        ));
      }
    }

    // Recalculate totals using the billsByType map values
    double billsTotal = 0;
    for (var billType in BillType.values) {
      final typeAmount = _getIntValue(updatedBillsByType[billType.name]);
      billsTotal += typeAmount * billType.value;
    }

    // Calculate totalWithExpenses
    final totalWithExpenses = billsTotal +
        (currentBillCount.showExpenses ? currentBillCount.expenses : 0);

    // Calculate finalTotal
    final finalTotal = totalWithExpenses -
        (currentBillCount.showBeginningBalance
            ? currentBillCount.beginningBalance
            : 0);

    // Log the bills array for debugging
    print(
        "Updated bills array: ${bills.map((b) => '${b.type.name}:${b.amount}').join(', ')}");

    // Create updated bill count with all the correct values
    final updatedBillCount = currentBillCount.copyWith(
      bills: bills,
      billsByType: updatedBillsByType,
      billsTotal: billsTotal,
      totalWithExpenses: totalWithExpenses,
      finalTotal: finalTotal,
    );

    print("Updated bill count: ${updatedBillCount.toJson()}");
    print("Updated billsByType: ${updatedBillCount.billsByType}");

    // Update local state immediately without async loading
    state = AsyncValue.data(BillCountState(billCount: updatedBillCount));
  }

  // Helper to get int value from various types
  int _getIntValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  // Toggle expenses visibility - only update local state
  Future<void> toggleExpensesVisibility() async {
    final currentState = state.value!;
    final currentBillCount = currentState.billCount ?? const BillCountModel();

    final showExpenses = !currentBillCount.showExpenses;
    print("Toggling expenses visibility to: $showExpenses");

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

    // Update local state immediately without async loading
    state = AsyncValue.data(BillCountState(billCount: updatedBillCount));
  }

  // Update expenses value - only update local state
  Future<void> updateExpenses(double expenses) async {
    final currentState = state.value!;
    final currentBillCount = currentState.billCount ?? const BillCountModel();

    print("Updating expenses to: $expenses");

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

    // Update local state immediately without async loading
    state = AsyncValue.data(BillCountState(billCount: updatedBillCount));
  }

  // Toggle beginning balance visibility - only update local state
  Future<void> toggleBeginningBalanceVisibility() async {
    final currentState = state.value!;
    final currentBillCount = currentState.billCount ?? const BillCountModel();

    final showBeginningBalance = !currentBillCount.showBeginningBalance;
    print("Toggling beginning balance visibility to: $showBeginningBalance");

    // Update final total
    final finalTotal = currentBillCount.totalWithExpenses -
        (showBeginningBalance ? currentBillCount.beginningBalance : 0);

    final updatedBillCount = currentBillCount.copyWith(
      showBeginningBalance: showBeginningBalance,
      finalTotal: finalTotal,
    );

    // Update local state immediately without async loading
    state = AsyncValue.data(BillCountState(billCount: updatedBillCount));
  }

  // Update beginning balance value - only update local state
  Future<void> updateBeginningBalance(double beginningBalance) async {
    final currentState = state.value!;
    final currentBillCount = currentState.billCount ?? const BillCountModel();

    print("Updating beginning balance to: $beginningBalance");

    // Update final total
    final finalTotal = currentBillCount.totalWithExpenses -
        (currentBillCount.showBeginningBalance ? beginningBalance : 0);

    final updatedBillCount = currentBillCount.copyWith(
      beginningBalance: beginningBalance,
      finalTotal: finalTotal,
    );

    // Update local state immediately without async loading
    state = AsyncValue.data(BillCountState(billCount: updatedBillCount));
  }

  // Update total cash value - only update local state
  Future<void> updateTotalCash(double totalCash) async {
    final currentState = state.value!;
    final currentBillCount = currentState.billCount ?? const BillCountModel();

    print("Updating total cash to: $totalCash");

    final updatedBillCount = currentBillCount.copyWith(
      totalCash: totalCash,
    );

    // Update local state immediately without async loading
    state = AsyncValue.data(BillCountState(billCount: updatedBillCount));
  }

  // Update starting amount (total cash) - only update local state
  Future<void> updateStartingAmount(double startingAmount) async {
    final currentState = state.value!;
    final currentBillCount = currentState.billCount ?? const BillCountModel();

    print("Updating starting amount to: $startingAmount");

    final updatedBillCount = currentBillCount.copyWith(
      startingAmount: startingAmount,
      totalCash: startingAmount, // Also update totalCash to match
    );

    // Update local state immediately without async loading
    state = AsyncValue.data(BillCountState(billCount: updatedBillCount));
  }

  // Save current bill count to server
  Future<void> saveBillCount({String? date}) async {
    state = const AsyncLoading();

    final currentState = state.value;
    if (currentState == null) {
      state = AsyncValue.error(
        'No current state available',
        StackTrace.current,
      );
      return;
    }

    state = await AsyncValue.guard(() async {
      try {
        final currentBillCount = currentState.billCount;

        if (currentBillCount == null) {
          throw Exception('No bill count data to save');
        }

        // Create a complete list of bills from billsByType map
        final billsList = <BillModel>[];

        // Debug log the current bills and billsByType
        print(
            "Current billsByType before request: ${currentBillCount.billsByType}");
        print(
            "Current bills before request: ${currentBillCount.bills.map((b) => '${b.type.name}:${b.amount}').join(', ')}");

        // Include ALL bill types in the request, using billsByType as source of truth
        BillType.values.forEach((billType) {
          // Get amount from billsByType
          final amount =
              _getIntValue(currentBillCount.billsByType[billType.name]);

          // Find existing bill ID for this type
          String? billId;
          for (var bill in currentBillCount.bills) {
            if (bill.type == billType) {
              billId = bill.id;
              break;
            }
          }

          // Add bill to request (with ID if exists)
          billsList.add(BillModel(
            id: billId,
            type: billType,
            amount: amount,
            value: (amount * billType.value).toDouble(),
          ));
        });

        // Log the complete bill list being sent
        print(
            "Bills being sent to server: ${billsList.map((b) => '${b.type.name}:${b.amount}:ID=${b.id}').join(', ')}");

        final formattedDate = date ??
            DateFormat('yyyy-MM-dd')
                .format(currentBillCount.date ?? DateTime.now());

        // Create the request model with ALL bills including startingAmount
        final request = CreateBillCountRequestModel(
          date: formattedDate,
          startingAmount: currentBillCount.startingAmount,
          expenses: currentBillCount.expenses,
          showExpenses: currentBillCount.showExpenses,
          beginningBalance: currentBillCount.beginningBalance,
          showBeginningBalance: currentBillCount.showBeginningBalance,
          bills: billsList, // All bills, including zeros
        );

        print(
            "Request payload includes startingAmount: ${request.startingAmount}");

        // Choose between update and create based on ID presence
        final BillCountModel savedBillCount;
        if (currentBillCount.id != null && currentBillCount.id!.isNotEmpty) {
          print("Updating existing bill count with ID: ${currentBillCount.id}");
          savedBillCount = await _billCountRepository.updateBillCount(
            currentBillCount.id!,
            request,
          );
        } else {
          print("Creating new bill count");
          savedBillCount =
              await _billCountRepository.createOrUpdateBillCount(request);
        }

        print("Bill count saved successfully: ${savedBillCount.id}");
        return BillCountState(billCount: savedBillCount);
      } catch (e) {
        print("Error saving bill count: $e");
        return BillCountState(
          billCount: currentState.billCount,
          error: e.toString(),
        );
      }
    });
  }
}
