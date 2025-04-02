import 'package:falsisters_pos_android/features/kahon/data/providers/sheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/widgets/kahon_sheet.dart';

class KahonScreen extends ConsumerStatefulWidget {
  const KahonScreen({super.key});

  @override
  ConsumerState<KahonScreen> createState() => _KahonScreenState();
}

class _KahonScreenState extends ConsumerState<KahonScreen> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    // Load initial sheet data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sheetNotifierProvider.notifier).getSheetByDate(null, null);
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialDateRange: _selectedStartDate != null && _selectedEndDate != null
          ? DateTimeRange(start: _selectedStartDate!, end: _selectedEndDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked.start;
        _selectedEndDate = picked.end;
      });
      // Fetch sheet data for selected date range
      ref
          .read(sheetNotifierProvider.notifier)
          .getSheetByDate(_selectedStartDate, _selectedEndDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sheetState = ref.watch(sheetNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kahon Sheet'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDateRange(context),
            tooltip: 'Select Date Range',
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
                        .read(sheetNotifierProvider.notifier)
                        .getSheetByDate(null, null);
                  },
                ),
              ),

            // Sheet data
            Expanded(
              child: sheetState.when(
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
                      child: Text('No sheet data available'),
                    );
                  }

                  return KahonSheet(
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
