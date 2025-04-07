import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:falsisters_pos_android/features/inventory/data/providers/inventory_provider.dart';
import 'package:falsisters_pos_android/features/inventory/presentation/widgets/inventory_sheet.dart';
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

class _KahonScreenState extends ConsumerState<KahonScreen>
    with SingleTickerProviderStateMixin {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load initial sheet data for both tabs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sheetNotifierProvider.notifier).getSheetByDate(null, null);
      ref.read(inventoryProvider.notifier).getInventoryByDate(null, null);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sheetState = ref.watch(sheetNotifierProvider);
    final inventoryState = ref.watch(inventoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kahon Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final result = await showBoardDateTimeMultiPicker(
                context: context,
                pickerType: DateTimePickerType.datetime,
              );

              if (result != null) {
                setState(() {
                  _selectedStartDate = result.start;
                  _selectedEndDate = result.end;
                });
                // Fetch sheet data for selected date range for both tabs
                ref
                    .read(sheetNotifierProvider.notifier)
                    .getSheetByDate(_selectedStartDate, _selectedEndDate);

                ref.read(inventoryProvider.notifier).getInventoryByDate(
                      _selectedStartDate,
                      _selectedEndDate,
                    );
              }
            },
            tooltip: 'Select Date Range',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'KAHON SHEET', icon: Icon(Icons.table_chart)),
            Tab(text: 'INVENTORY', icon: Icon(Icons.inventory)),
          ],
        ),
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
                    ref
                        .read(inventoryProvider.notifier)
                        .getInventoryByDate(null, null);
                  },
                ),
              ),

            // Sheet data with tabs
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Kahon Sheet Tab
                  sheetState.when(
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

                  // Inventory Sheet Tab
                  inventoryState.when(
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
                          child: Text('No inventory data available'),
                        );
                      }

                      return InventorySheet(
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
                ],
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
