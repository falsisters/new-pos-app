import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_type.dart';
import 'package:falsisters_pos_android/features/bill_count/data/providers/bill_count_provider.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/widgets/bill_entry_widget.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/dialogs/beginning_balance_dialog.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/widgets/total_cash_widget.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/widgets/initial_count.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/utils/bill_count_formatter.dart';
import 'package:table_calendar/table_calendar.dart';

class BillCountScreen extends ConsumerStatefulWidget {
  const BillCountScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BillCountScreen> createState() => _BillCountScreenState();
}

class _BillCountScreenState extends ConsumerState<BillCountScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isCalendarVisible = false;

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
  void _createNewBillCount() async {
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Creating new bill count..."),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );

    // Create and save the new bill count with zero values
    await ref.read(billCountProvider.notifier).createAndSaveBillCount(
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("New bill count created - you can now enter values"),
        backgroundColor: Colors.lightGreen,
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
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.account_balance_wallet_outlined, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bill Count',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Track daily cash counting',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                          lastDay:
                              DateTime.utc(2030, 12, 31), // Allow future dates
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
                        // Net Cash Widget (shows only total cash from sales)
                        TotalCashWidget(
                          totalCash: billCount.totalCash,
                        ),

                        // Total Expenses Widget (read-only from backend)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.accent,
                                AppColors.accent.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TOTAL EXPENSES",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "(From expense tracking)",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "₱ ${BillCountFormatter.formatCurrency(billCount.totalExpenses)}",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Net Amount (Cash + Expenses) - using backend calculated values
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.secondary,
                                AppColors.secondary.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "NET AMOUNT",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "(Cash - Expenses)",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "₱ ${BillCountFormatter.formatCurrency(billCount.netCash)}",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Beginning Balance Display
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "BEGINNING BALANCE",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "₱ ${BillCountFormatter.formatCurrency(billCount.beginningBalance)}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.edit_rounded),
                                  color: AppColors.secondary,
                                  iconSize: 24,
                                  onPressed: _showBeginningBalanceDialog,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bills count entries
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "BILL COUNT",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
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

                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                height: 1,
                                color: Colors.grey.shade200,
                              ),

                              // Subtotal
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "SUBTOTAL",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    "₱ ${BillCountFormatter.formatCurrency(billCount.billsTotal)}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Beginning Balance to deduct
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: billCount.showBeginningBalance
                                  ? AppColors.secondary.withOpacity(0.3)
                                  : Colors.grey.shade200,
                              width: billCount.showBeginningBalance ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 1.1,
                                child: Checkbox(
                                  value: billCount.showBeginningBalance,
                                  onChanged: (_) => _toggleBeginningBalance(),
                                  activeColor: AppColors.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "SUBTRACT BEGINNING BALANCE",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: billCount.showBeginningBalance
                                        ? AppColors.secondary
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              if (billCount.showBeginningBalance)
                                Text(
                                  "₱ ${BillCountFormatter.formatCurrency(billCount.beginningBalance)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Updated Initial Count breakdown
                        InitialCountWidget(
                          billsSubtotal: billCount.billsTotal,
                          beginningBalance: billCount.beginningBalance,
                          totalSales: billCount
                              .totalCash, // Total Sales is the Net Cash
                          totalExpenses: billCount.totalExpenses,
                        ),

                        // Final total - using backend calculated value

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
