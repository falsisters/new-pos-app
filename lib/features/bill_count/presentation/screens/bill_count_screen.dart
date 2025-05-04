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
          ref.read(billCountProvider.notifier).saveBillCount(
                date: DateFormat('yyyy-MM-dd').format(_selectedDate),
              );
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
          ref.read(billCountProvider.notifier).saveBillCount(
                date: DateFormat('yyyy-MM-dd').format(_selectedDate),
              );
        },
      ),
    );
  }

  void _toggleExpenses() {
    ref.read(billCountProvider.notifier).toggleExpensesVisibility();
    ref.read(billCountProvider.notifier).saveBillCount(
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        );
  }

  void _toggleBeginningBalance() {
    ref.read(billCountProvider.notifier).toggleBeginningBalanceVisibility();
    ref.read(billCountProvider.notifier).saveBillCount(
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ref.read(billCountProvider.notifier).saveBillCount(
                    date: DateFormat('yyyy-MM-dd').format(_selectedDate),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Bill count saved")),
              );
            },
          ),
        ],
      ),
      body: billCountAsync.when(
        data: (billCountState) {
          final billCount = billCountState.billCount;
          if (billCount == null) {
            return const Center(child: Text("No bill count data available"));
          }

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
                                initialAmount: int.tryParse(billCount
                                            .billsByType[BillType.THOUSAND.name]
                                            ?.toString() ??
                                        "0") ??
                                    0,
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.THOUSAND,
                                        value,
                                      );
                                  ref
                                      .read(billCountProvider.notifier)
                                      .saveBillCount(
                                        date: DateFormat('yyyy-MM-dd')
                                            .format(_selectedDate),
                                      );
                                },
                              ),
                              BillEntryWidget(
                                type: BillType.FIVE_HUNDRED,
                                initialAmount: int.tryParse(billCount
                                            .billsByType[
                                                BillType.FIVE_HUNDRED.name]
                                            ?.toString() ??
                                        "0") ??
                                    0,
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.FIVE_HUNDRED,
                                        value,
                                      );
                                  ref
                                      .read(billCountProvider.notifier)
                                      .saveBillCount(
                                        date: DateFormat('yyyy-MM-dd')
                                            .format(_selectedDate),
                                      );
                                },
                              ),
                              BillEntryWidget(
                                type: BillType.HUNDRED,
                                initialAmount: int.tryParse(billCount
                                            .billsByType[BillType.HUNDRED.name]
                                            ?.toString() ??
                                        "0") ??
                                    0,
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.HUNDRED,
                                        value,
                                      );
                                  ref
                                      .read(billCountProvider.notifier)
                                      .saveBillCount(
                                        date: DateFormat('yyyy-MM-dd')
                                            .format(_selectedDate),
                                      );
                                },
                              ),
                              BillEntryWidget(
                                type: BillType.FIFTY,
                                initialAmount: int.tryParse(billCount
                                            .billsByType[BillType.FIFTY.name]
                                            ?.toString() ??
                                        "0") ??
                                    0,
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.FIFTY,
                                        value,
                                      );
                                  ref
                                      .read(billCountProvider.notifier)
                                      .saveBillCount(
                                        date: DateFormat('yyyy-MM-dd')
                                            .format(_selectedDate),
                                      );
                                },
                              ),
                              BillEntryWidget(
                                type: BillType.TWENTY,
                                initialAmount: int.tryParse(billCount
                                            .billsByType[BillType.TWENTY.name]
                                            ?.toString() ??
                                        "0") ??
                                    0,
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.TWENTY,
                                        value,
                                      );
                                  ref
                                      .read(billCountProvider.notifier)
                                      .saveBillCount(
                                        date: DateFormat('yyyy-MM-dd')
                                            .format(_selectedDate),
                                      );
                                },
                              ),
                              BillEntryWidget(
                                type: BillType.COINS,
                                initialAmount: int.tryParse(billCount
                                            .billsByType[BillType.COINS.name]
                                            ?.toString() ??
                                        "0") ??
                                    0,
                                onChanged: (int value) {
                                  ref
                                      .read(billCountProvider.notifier)
                                      .updateBillAmount(
                                        BillType.COINS,
                                        value,
                                      );
                                  ref
                                      .read(billCountProvider.notifier)
                                      .saveBillCount(
                                        date: DateFormat('yyyy-MM-dd')
                                            .format(_selectedDate),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }
}
