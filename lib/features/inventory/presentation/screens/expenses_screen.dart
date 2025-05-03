// ignore_for_file: use_build_context_synchronously
import 'package:falsisters_pos_android/features/inventory/data/providers/inventory_provider.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/expenses_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();

    // Load initial expenses data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(expensesProvider.notifier).getExpensesByDate(null, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final expensesState = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              // First pick start date
              final DateTime? startDate = await showDatePicker(
                context: context,
                initialDate: _selectedStartDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );

              // If start date is selected, pick end date
              if (startDate != null) {
                final DateTime? endDate = await showDatePicker(
                  context: context,
                  initialDate: startDate.add(const Duration(days: 1)),
                  firstDate: startDate,
                  lastDate: DateTime(2030),
                );

                // Create result object using the built-in DateTimeRange class
                final result = endDate != null
                    ? DateTimeRange(start: startDate, end: endDate)
                    : null;

                if (result != null) {
                  setState(() {
                    _selectedStartDate = result.start;
                    _selectedEndDate = result.end;
                  });
                  // Fetch expenses data for selected date range
                  ref
                      .read(expensesProvider.notifier)
                      .getExpensesByDate(_selectedStartDate, _selectedEndDate);
                }
              }
            },
            tooltip: 'Select Date Range',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(expensesProvider.notifier)
                  .getExpensesByDate(_selectedStartDate, _selectedEndDate);
            },
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date filter display
            if (_selectedStartDate != null && _selectedEndDate != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Chip(
                  label: Text(
                    'Showing data from ${_formatDate(_selectedStartDate!)} to ${_formatDate(_selectedEndDate!)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: AppColors.secondary,
                  deleteIcon: const Icon(Icons.close, color: Colors.white),
                  onDeleted: () {
                    setState(() {
                      _selectedStartDate = null;
                      _selectedEndDate = null;
                    });
                    ref
                        .read(expensesProvider.notifier)
                        .getExpensesByDate(null, null);
                  },
                ),
              ),

            // Expenses sheet content
            Expanded(
              child: expensesState.when(
                data: (data) {
                  if (data.error != null) {
                    return Center(
                      child: Text(
                        'Error: ${data.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (data.sheet == null) {
                    return const Center(
                      child: Text('No expenses data available'),
                    );
                  }

                  return ExpensesSheet(
                    sheet: data.sheet!,
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
