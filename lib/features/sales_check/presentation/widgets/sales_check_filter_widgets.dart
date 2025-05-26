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

class _SalesCheckDateFilterState extends ConsumerState<SalesCheckDateFilter>
    with SingleTickerProviderStateMixin {
  DateTime? _selectedDate;
  final TextEditingController _productNameController = TextEditingController();
  String _priceType = '';
  String _sackType = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize with values from provider state
    final salesStateValue = ref.read(salesCheckProvider).value;
    final gFilters = salesStateValue?.groupedSalesFilters;
    final tFilters = salesStateValue?.totalSalesFilters;

    // Initialize Date
    final initialDateStr = gFilters?.date ?? tFilters?.date;
    if (initialDateStr != null) {
      _selectedDate =
          DateFormat('yyyy-MM-dd').tryParse(initialDateStr) ?? DateTime.now();
    } else {
      _selectedDate = DateTime.now();
    }

    // Initialize other fields
    _productNameController.text =
        tFilters?.productName ?? gFilters?.productSearch ?? '';
    _priceType = tFilters?.priceType ?? gFilters?.priceType ?? '';
    _sackType = tFilters?.sackType ?? gFilters?.sackType ?? '';

    if (_priceType != 'SACK') {
      _sackType = '';
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = _selectedDate != null
        ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
        : 'Select Date';

    final isExpanded = ref.watch(filterExpandedProvider);

    // Control animation based on expanded state
    if (isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.primary.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with enhanced styling
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ref.read(filterExpandedProvider.notifier).state = !isExpanded;
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Filter icon with background
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title and subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sales Filters',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tap to ${isExpanded ? 'collapse' : 'expand'} options',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Current date chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.primary.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            displayDate,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Animated expand/collapse icon
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.expand_more,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expanded filter section with animation
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildExpandedContent(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elegant divider
          Container(
            height: 1,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.primary.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Date selection section
          _buildFilterSection(
            title: 'Date Selection',
            icon: Icons.date_range,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.event, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('EEEE, MMMM dd, yyyy')
                              .format(_selectedDate!),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStyledButton(
                    onPressed: () => _selectDate(context),
                    label: 'Change',
                    icon: Icons.edit_calendar,
                    isPrimary: false,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Product search section
          _buildFilterSection(
            title: 'Product Search',
            icon: Icons.search,
            child: TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                hintText: 'Search by product name...',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.search, color: AppColors.primary, size: 20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              onSubmitted: (_) => _applyFilters(),
            ),
          ),

          const SizedBox(height: 20),

          // Filter options section
          _buildFilterSection(
            title: 'Filter Options',
            icon: Icons.tune,
            child: Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Price Type',
                    value: _priceType.isEmpty ? null : _priceType,
                    hint: 'Select type',
                    items: const [
                      DropdownMenuItem(value: 'SACK', child: Text('Sack')),
                      DropdownMenuItem(value: 'KILO', child: Text('Kilo')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _priceType = value ?? '';
                        if (_priceType != 'SACK') {
                          _sackType = '';
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Sack Type',
                    value: _sackType.isEmpty ? null : _sackType,
                    hint: 'Select sack',
                    items: const [
                      DropdownMenuItem(value: 'FIFTY_KG', child: Text('50 KG')),
                      DropdownMenuItem(
                          value: 'TWENTY_FIVE_KG', child: Text('25 KG')),
                      DropdownMenuItem(value: 'FIVE_KG', child: Text('5 KG')),
                    ],
                    onChanged: _priceType == 'SACK'
                        ? (value) {
                            setState(() {
                              _sackType = value ?? '';
                            });
                          }
                        : null,
                    isEnabled: _priceType == 'SACK',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _buildStyledButton(
                  onPressed: _resetFilters,
                  label: 'Reset Filters',
                  icon: Icons.refresh,
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildStyledButton(
                  onPressed: _applyFilters,
                  label: 'Apply Filters',
                  icon: Icons.check,
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?>? onChanged,
    bool isEnabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: isEnabled ? Colors.grey[50] : Colors.grey[100],
          ),
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey[500])),
          items: items,
          onChanged: isEnabled ? onChanged : null,
          icon: Icon(
            Icons.arrow_drop_down,
            color: isEnabled ? AppColors.primary : Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildStyledButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required bool isPrimary,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primary : Colors.grey[100],
          foregroundColor: isPrimary ? Colors.white : Colors.grey[700],
          elevation: isPrimary ? 2 : 0,
          shadowColor: isPrimary ? AppColors.primary.withOpacity(0.3) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: Colors.grey[300]!),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
          ),
          child: child!,
        );
      },
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

      ref.read(salesCheckProvider.notifier).updateFiltersAndRefetch(
          groupedFilters: groupedFilters, totalFilters: totalFilters);

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
