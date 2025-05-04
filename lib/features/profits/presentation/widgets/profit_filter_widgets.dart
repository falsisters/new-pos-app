import 'package:falsisters_pos_android/features/profits/data/model/profit_filter_dto.dart';
import 'package:falsisters_pos_android/features/profits/data/providers/profits_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProfitFilterWidget extends ConsumerStatefulWidget {
  const ProfitFilterWidget({super.key});

  @override
  ConsumerState<ProfitFilterWidget> createState() => _ProfitFilterWidgetState();
}

class _ProfitFilterWidgetState extends ConsumerState<ProfitFilterWidget> {
  DateTime? _selectedDate;
  String? _selectedPriceType;
  String? _selectedSackType;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    // Initialize with the current date from the notifier state if available
    final profitsState = ref.read(profitsStateNotifierProvider).valueOrNull;
    final initialFilters = profitsState?.filters;

    if (initialFilters?.date != null) {
      try {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(initialFilters!.date!);
      } catch (_) {
        _selectedDate = DateTime.now(); // Fallback
      }
    } else {
      _selectedDate = DateTime.now();
    }

    _selectedPriceType = initialFilters?.priceType;
    _selectedSackType = initialFilters?.sackType;
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
      _applyFilters(); // Apply filters immediately after selection
    }
  }

  void _applyFilters() {
    if (_selectedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      final filters = ProfitFilterDto(
        date: formattedDate,
        priceType: _selectedPriceType,
        sackType: _selectedSackType,
      );

      // Call the notifier method to update filters and refetch data
      ref
          .read(profitsStateNotifierProvider.notifier)
          .updateFiltersAndRefetch(filters);
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : 'Select Date';

    // Active filters summary text for collapsed mode
    final List<String> activeFilters = [];
    if (_selectedDate != null) {
      activeFilters.add("Date: $displayDate");
    }
    if (_selectedPriceType != null) {
      activeFilters
          .add("Type: ${_selectedPriceType == 'SACK' ? 'Sacks' : 'Asin'}");
    }
    if (_selectedSackType != null) {
      final sackTypeMap = {
        'FIFTY_KG': '50KG',
        'TWENTY_FIVE_KG': '25KG',
        'FIVE_KG': '5KG',
      };
      activeFilters
          .add("Sack: ${sackTypeMap[_selectedSackType] ?? _selectedSackType}");
    }

    final activeFilterText = activeFilters.isNotEmpty
        ? activeFilters.join(" | ")
        : "No active filters";

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with expand/collapse button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Profits',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: _toggleExpanded,
                    tooltip: _isExpanded ? 'Collapse' : 'Expand',
                  ),
                ],
              ),

              // Summary text when collapsed
              if (!_isExpanded)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    activeFilterText,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),

              // Full filter controls when expanded
              if (_isExpanded) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Date:'),
                    TextButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(displayDate),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Price Type',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        value: _selectedPriceType,
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All')),
                          DropdownMenuItem(value: 'SACK', child: Text('Sacks')),
                          DropdownMenuItem(value: 'ASIN', child: Text('Asin')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedPriceType = value;
                            // Clear sack type if not viewing sacks
                            if (value != 'SACK') {
                              _selectedSackType = null;
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Sack Type',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        value: _selectedSackType,
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All')),
                          DropdownMenuItem(
                              value: 'FIFTY_KG', child: Text('50KG')),
                          DropdownMenuItem(
                              value: 'TWENTY_FIVE_KG', child: Text('25KG')),
                          DropdownMenuItem(
                              value: 'FIVE_KG', child: Text('5KG')),
                        ],
                        onChanged: _selectedPriceType == 'SACK'
                            ? (value) {
                                setState(() {
                                  _selectedSackType = value;
                                });
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply Filters'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
