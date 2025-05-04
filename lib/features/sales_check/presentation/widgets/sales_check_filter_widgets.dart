import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/sales_check_filter_dto.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/total_sales_filter_dto.dart';
import 'package:falsisters_pos_android/features/sales_check/data/providers/sales_check_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Provider to track the filter expanded state across the app
final filterExpandedProvider = StateProvider<bool>((ref) => false);

class SalesCheckDateFilter extends ConsumerStatefulWidget {
  const SalesCheckDateFilter({super.key});

  @override
  ConsumerState<SalesCheckDateFilter> createState() =>
      _SalesCheckDateFilterState();
}

class _SalesCheckDateFilterState extends ConsumerState<SalesCheckDateFilter> {
  DateTime? _selectedDate;
  final TextEditingController _productNameController = TextEditingController();
  String _priceType = ''; // SACK or KILO
  String _sackType = ''; // FIFTY_KG, TWENTY_FIVE_KG, or FIVE_KG

  @override
  void initState() {
    super.initState();
    // Initialize with values from provider state
    final currentState = ref.read(salesCheckProvider).value;
    final initialDateStr = currentState?.groupedSalesFilters?.date;

    if (initialDateStr != null) {
      try {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(initialDateStr);
      } catch (_) {
        _selectedDate = DateTime.now(); // Fallback
      }
    } else {
      _selectedDate = DateTime.now();
    }

    // Initialize other filter values if available
    if (currentState?.totalSalesFilters != null) {
      final filters = currentState!.totalSalesFilters!;
      if (filters.productName != null) {
        _productNameController.text = filters.productName!;
      }
      if (filters.priceType != null) {
        _priceType = filters.priceType!;
      }
      if (filters.sackType != null) {
        _sackType = filters.sackType!;
      }
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : 'Select Date';

    // Read the expanded state from the provider
    final isExpanded = ref.watch(filterExpandedProvider);

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with expand/collapse button
          InkWell(
            onTap: () {
              // Toggle the expanded state
              ref.read(filterExpandedProvider.notifier).state = !isExpanded;
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Sales Filters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  // Current date indicator - always visible
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Date: $displayDate',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Expand/collapse icon
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

          // Expanded filter section - only visible when expanded
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  // Date selection row
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Date: $displayDate',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Change Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Product name search
                  TextField(
                    controller: _productNameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      hintText: 'Search by product name',
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                    onSubmitted: (_) => _applyFilters(),
                  ),
                  const SizedBox(height: 16),
                  // Price type and sack type row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Price Type:',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              value: _priceType.isEmpty ? null : _priceType,
                              hint: const Text('Select type'),
                              items: [
                                DropdownMenuItem(
                                    value: 'SACK', child: const Text('Sack')),
                                DropdownMenuItem(
                                    value: 'KILO', child: const Text('Kilo')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _priceType = value ?? '';
                                  // Reset sack type if price type changes
                                  if (_priceType != 'SACK') {
                                    _sackType = '';
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Sack Type:',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              value: _sackType.isEmpty ? null : _sackType,
                              hint: const Text('Select sack'),
                              items: [
                                DropdownMenuItem(
                                    value: 'FIFTY_KG',
                                    child: const Text('50 KG')),
                                DropdownMenuItem(
                                    value: 'TWENTY_FIVE_KG',
                                    child: const Text('25 KG')),
                                DropdownMenuItem(
                                    value: 'FIVE_KG',
                                    child: const Text('5 KG')),
                              ],
                              onChanged: _priceType == 'SACK'
                                  ? (value) {
                                      setState(() {
                                        _sackType = value ?? '';
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _resetFilters,
                        child: const Text('Reset Filters'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _applyFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Apply Filters'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
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
      _applyFilters();
    }
  }

  void _applyFilters() {
    if (_selectedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      // Create filter DTOs with all filter values
      final totalFilters = TotalSalesFilterDto(
        date: formattedDate,
        productName: _productNameController.text.isEmpty
            ? null
            : _productNameController.text,
        priceType: _priceType.isEmpty ? null : _priceType,
        sackType: _priceType != 'SACK' || _sackType.isEmpty ? null : _sackType,
      );

      final groupedFilters = SalesCheckFilterDto(
        date: formattedDate,
        productSearch: _productNameController.text.isEmpty
            ? null
            : _productNameController.text,
        priceType: _priceType.isEmpty ? null : _priceType,
        sackType: _priceType != 'SACK' || _sackType.isEmpty ? null : _sackType,
      );

      // Call the notifier method to update filters and refetch data
      ref.read(salesCheckProvider.notifier).updateFiltersAndRefetch(
          groupedFilters: groupedFilters, totalFilters: totalFilters);

      // Collapse the filter section after applying filters
      ref.read(filterExpandedProvider.notifier).state = false;
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedDate = DateTime.now();
      _productNameController.clear();
      _priceType = '';
      _sackType = '';
    });
    _applyFilters();
  }
}
