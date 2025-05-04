import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_type.dart';
import 'package:falsisters_pos_android/features/bill_count/data/providers/bill_count_provider.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/widgets/bill_entry_widget.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/dialogs/expense_dialog.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/dialogs/beginning_balance_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class BillCountScreen extends ConsumerStatefulWidget {
  const BillCountScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BillCountScreen> createState() => _BillCountScreenState();
}

class _BillCountScreenState extends ConsumerState<BillCountScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isCalendarVisible = false;
  final currencyFormat = NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadBillCount());
  }

  void _loadBillCount() {
    ref.read(billCountProvider.notifier).loadBillCountForDate(
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        );
  }

  // Create a new bill count for the selected date
  void _createNewBillCount() {
    ref.read(billCountProvider.notifier).createNewBillCount(
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("New bill count created - enter your values and save"),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleCalendar() {
    setState(() {
      _isCalendarVisible = !_isCalendarVisible;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _isCalendarVisible = false;
    });
    _loadBillCount();
  }

  void _showExpenseDialog() {
    final billCountState = ref.read(billCountProvider).value;
    if (billCountState == null || billCountState.billCount == null) return;

    showDialog(
      context: context,
      builder: (context) => ExpenseDialog(
        initialValue: billCountState.billCount!.expenses,
        onSave: (double value) {
          ref.read(billCountProvider.notifier).updateExpenses(value);
          // Do not auto-save, let the user decide when to save
        },
      ),
    );
  }

  void _showBeginningBalanceDialog() {
    final billCountState = ref.read(billCountProvider).value;
    if (billCountState == null || billCountState.billCount == null) return;

    showDialog(
      context: context,
      builder: (context) => BeginningBalanceDialog(
        initialValue: billCountState.billCount!.beginningBalance,
        onSave: (double value) {
          ref.read(billCountProvider.notifier).updateBeginningBalance(value);
          // Do not auto-save, let the user decide when to save
        },
      ),
    );
  }

  void _toggleExpenses() {
    ref.read(billCountProvider.notifier).toggleExpensesVisibility();
    // Do not auto-save, let the user decide when to save
  }

  void _toggleBeginningBalance() {
    ref.read(billCountProvider.notifier).toggleBeginningBalanceVisibility();
    // Do not auto-save, let the user decide when to save
  }

  void _saveBillCount() {
    ref.read(billCountProvider.notifier).saveBillCount(
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Bill count saved successfully"),
        backgroundColor: Colors.lightGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Helper method to get bill amount from billsByType
  int _getBillAmount(Map<String, dynamic> billsByType, String typeName) {
    final value = billsByType[typeName];
    if (value == null) return 0;

    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is double) {
      return value.toInt();
    }

    return 0;
  }

  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.post_add_rounded,
            size: 80,
            color: AppColors.primaryLight,
          ),
          const SizedBox(height: 16),
          const Text(
            "No bill count data for this date",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You can create a new bill count for this date",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _createNewBillCount,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "CREATE NEW BILL COUNT",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _saveBillCount,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, size: 24),
            SizedBox(width: 8),
            Text(
              "SAVE BILL COUNT",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final billCountAsync = ref.watch(billCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bill Count"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: billCountAsync.when(
        data: (billCountState) {
          final billCount = billCountState.billCount;
          if (billCount == null) {
            return _buildNoDataView();
          }

          print("Rendering with billsByType: ${billCount.billsByType}");

          return Column(
            children: [
              // Date selection area
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.primaryLight.withOpacity(0.2),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _toggleCalendar,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('MMMM dd, yyyy')
                                        .format(_selectedDate),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_isCalendarVisible)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.now(),
                          focusedDay: _selectedDate,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDate, day);
                          },
                          onDaySelected: _onDaySelected,
                          headerStyle: HeaderStyle(
                            titleTextStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            formatButtonVisible: false,
                            titleCentered: true,
                            leftChevronIcon: const Icon(
                              Icons.chevron_left,
                              color: AppColors.primary,
                            ),
                            rightChevronIcon: const Icon(
                              Icons.chevron_right,
                              color: AppColors.primary,
                            ),
                          ),
                          calendarStyle: const CalendarStyle(
                            selectedDecoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Bill count details
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Message for new bill count
                        if (billCount.id == null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Creating New Bill Count",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Enter the bill counts for ${DateFormat('MMMM dd, yyyy').format(_selectedDate)} and press SAVE when done.",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Beginning Balance Display
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "BEGINNING BALANCE",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "₱ ${currencyFormat.format(billCount.beginningBalance)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: AppColors.secondary,
                                    onPressed: _showBeginningBalanceDialog,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Bills count entries
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              BillEntryWidget(
                                type: BillType.THOUSAND,
                                initialAmount: _getBillAmount(
                                    billCount.billsByType, "THOUSAND"),
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.THOUSAND,
                                        value,
                                      );
                                },
                              ),
                              BillEntryWidget(
                                type: BillType.FIVE_HUNDRED,
                                initialAmount: _getBillAmount(
                                    billCount.billsByType, "FIVE_HUNDRED"),
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.FIVE_HUNDRED,
                                        value,
                                      );
                                },
                              ),
                              BillEntryWidget(
                                type: BillType.HUNDRED,
                                initialAmount: _getBillAmount(
                                    billCount.billsByType, "HUNDRED"),
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.HUNDRED,
                                        value,
                                      );
                                },
                              ),
                              BillEntryWidget(
                                type: BillType.FIFTY,
                                initialAmount: _getBillAmount(
                                    billCount.billsByType, "FIFTY"),
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.FIFTY,
                                        value,
                                      );
                                },
                              ),
                              BillEntryWidget(
                                type: BillType.TWENTY,
                                initialAmount: _getBillAmount(
                                    billCount.billsByType, "TWENTY"),
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.TWENTY,
                                        value,
                                      );
                                },
                              ),
                              BillEntryWidget(
                                type: BillType.COINS,
                                initialAmount: _getBillAmount(
                                    billCount.billsByType, "COINS"),
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.COINS,
                                        value,
                                      );
                                },
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(thickness: 1),
                              ),

                              // Subtotal before expenses
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      "₱ ${currencyFormat.format(billCount.billsTotal)}",
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Expenses section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: billCount.showExpenses,
                                        onChanged: (_) => _toggleExpenses(),
                                        activeColor: AppColors.accent,
                                      ),
                                      const Text(
                                        "+ EXPENSES",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (billCount.showExpenses)
                                        Text(
                                          "₱ ${currencyFormat.format(billCount.expenses)}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        color: AppColors.accent,
                                        onPressed: _showExpenseDialog,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (billCount.showExpenses)
                                Column(
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Divider(thickness: 1),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 130,
                                          child: Text(
                                            "₱ ${currencyFormat.format(billCount.totalWithExpenses)}",
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        // Beginning Balance to deduct
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: billCount.showBeginningBalance,
                                        onChanged: (_) =>
                                            _toggleBeginningBalance(),
                                        activeColor: AppColors.secondary,
                                      ),
                                      const Text(
                                        "- BEGINNING BALANCE",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (billCount.showBeginningBalance)
                                    Text(
                                      "₱ ${currencyFormat.format(billCount.beginningBalance)}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Final total
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "TOTAL",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                "₱ ${currencyFormat.format(billCount.finalTotal)}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Prominent save button
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                "Error: $error",
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadBillCount,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
