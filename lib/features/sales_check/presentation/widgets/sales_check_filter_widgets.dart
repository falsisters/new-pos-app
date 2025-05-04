import 'package:falsisters_pos_android/features/sales_check/data/model/sales_check_filter_dto.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/total_sales_filter_dto.dart';
import 'package:falsisters_pos_android/features/sales_check/data/providers/sales_check_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Define the provider for the SalesCheckNotifier
// Assuming you have defined it somewhere like this:
// final salesCheckProvider = AsyncProvider<SalesCheckNotifier, SalesCheckState>(() {
//   return SalesCheckNotifier();
// });
// If not, define it appropriately in your providers file.

class SalesCheckDateFilter extends ConsumerStatefulWidget {
  const SalesCheckDateFilter({super.key});

  @override
  ConsumerState<SalesCheckDateFilter> createState() =>
      _SalesCheckDateFilterState();
}

class _SalesCheckDateFilterState extends ConsumerState<SalesCheckDateFilter> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize with the current date from the notifier state if available
    final initialDateStr =
        ref.read(salesCheckProvider).value?.groupedSalesFilters?.date;
    if (initialDateStr != null) {
      try {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(initialDateStr);
      } catch (_) {
        _selectedDate = DateTime.now(); // Fallback
      }
    } else {
      _selectedDate = DateTime.now();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000), // Adjust range as needed
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _applyFilters(); // Apply filters immediately after selection or use a separate button
    }
  }

  void _applyFilters() {
    if (_selectedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final groupedFilters = SalesCheckFilterDto(date: formattedDate);
      final totalFilters = TotalSalesFilterDto(date: formattedDate);

      // Call the notifier method to update filters and refetch data
      ref.read(salesCheckProvider.notifier).updateFiltersAndRefetch(
          groupedFilters: groupedFilters, totalFilters: totalFilters);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : 'Select Date';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Date: $displayDate'),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today),
            label: const Text('Change Date'),
          ),
          // Optional: Add a separate "Apply" button if you don't want to apply immediately
          // ElevatedButton(
          //   onPressed: _applyFilters,
          //   child: const Text('Apply Filters'),
          // ),
        ],
      ),
    );
  }
}

// --- How to use in your Sales Check Screen ---
/*
@override
Widget build(BuildContext context, WidgetRef ref) {
  final salesCheckState = ref.watch(salesCheckProvider);

  return Scaffold(
    appBar: AppBar(title: const Text('Sales Check')),
    body: Column(
      children: [
        // Add the filter widget here
        const SalesCheckDateFilter(),

        // Display loading, error, or data based on salesCheckState
        Expanded(
          child: salesCheckState.when(
            data: (state) {
              // Build your list view using state.groupedSales
              // Display state.totalSales somewhere
              return ListView(
                // ... display data ...
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    ),
  );
}
*/
