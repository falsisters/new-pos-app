import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_payment_method.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_sack_type.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_item.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:falsisters_pos_android/features/auth/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SalesListWidget extends ConsumerStatefulWidget {
  const SalesListWidget({super.key});

  @override
  ConsumerState<SalesListWidget> createState() => _SalesListWidgetState();
}

class _SalesListWidgetState extends ConsumerState<SalesListWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatSackType(SackType? sackType) {
    if (sackType == null) return 'KG';
    String name = parseSackType(sackType);
    return name.isNotEmpty ? name : 'KG Sack';
  }

  String _determineItemQuantityDisplay(SaleItem item) {
    String quantityStr = item.quantity
        .toStringAsFixed((item.quantity % Decimal.one) == Decimal.zero ? 0 : 1);
    String unit;

    if (item.sackPrice != null) {
      unit = _formatSackType(item.sackType);
      return "$quantityStr ${unit}(s)";
    } else if (item.isGantang) {
      return "$quantityStr gantang(s)";
    } else {
      return "$quantityStr kg";
    }
  }

  String _determineItemPriceInfoDisplay(SaleItem item) {
    if (item.discountedPrice != null &&
        (item.isDiscounted || item.isSpecialPrice)) {
      // discountedPrice is now the total, so we need to calculate per-unit price
      Decimal unitPrice = Decimal.zero;
      if (item.quantity > Decimal.zero) {
        unitPrice = (item.discountedPrice! / item.quantity).toDecimal();
      }
      String type = item.isDiscounted ? "Discounted" : "Special";
      if (unitPrice > Decimal.zero)
        return "$type: @ ₱${unitPrice.toStringAsFixed(2)} per ${item.sackPrice != null ? _formatSackType(item.sackType) : item.isGantang ? 'gantang' : 'kg'}";
      return type;
    }
    if (item.sackPrice != null) {
      return "@ ₱${item.sackPrice!.price.toStringAsFixed(2)} per ${_formatSackType(item.sackType)}";
    }
    if (item.perKiloPrice != null) {
      return "@ ₱${item.perKiloPrice!.price.toStringAsFixed(2)} per kg";
    }
    if (item.isGantang) {
      return "Gantang Price";
    }
    return "Price: N/A";
  }

  Decimal _calculateItemSubtotal(SaleItem item) {
    if (item.discountedPrice != null) {
      // discountedPrice is now the total price, use it directly
      return item.discountedPrice!;
    }
    if (item.sackPrice != null) {
      return item.quantity * Decimal.parse(item.sackPrice!.price.toString());
    }
    if (item.perKiloPrice != null) {
      return item.quantity * Decimal.parse(item.perKiloPrice!.price.toString());
    }
    return Decimal.zero;
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final currentDate =
        ref.read(salesProvider).value?.selectedDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != currentDate) {
      await ref.read(salesProvider.notifier).changeSelectedDate(picked);
    }
  }

  Color _getPaymentMethodColor(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.CASH:
        return Colors.green;
      case PaymentMethod.CHECK:
        return Colors.orange;
      case PaymentMethod.BANK_TRANSFER:
        return Colors.blue;
    }
  }

  IconData _getPaymentMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.CASH:
        return Icons.payments;
      case PaymentMethod.CHECK:
        return Icons.receipt;
      case PaymentMethod.BANK_TRANSFER:
        return Icons.account_balance;
    }
  }

  @override
  Widget build(BuildContext context) {
    final salesStateAsync = ref.watch(salesProvider);
    final cashier = ref.watch(cashierProvider);
    final hasVoidPermission = cashier?.permissions.contains('VOID') ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Date Selection and Search Bar Block
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.15),
                  AppColors.primary.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Date Selection
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.calendar_today_rounded,
                            color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Date',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500],
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Consumer(
                              builder: (context, ref, child) {
                                final selectedDate = ref
                                        .watch(salesProvider)
                                        .value
                                        ?.selectedDate ??
                                    DateTime.now();
                                return Text(
                                  DateFormat('EEEE, MMM dd, yyyy')
                                      .format(selectedDate),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.secondary,
                              AppColors.secondary.withOpacity(0.8)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _selectDate(context, ref),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.date_range_rounded,
                                      color: Colors.white, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Change',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.refresh_rounded,
                              color: AppColors.primary, size: 24),
                          onPressed: () =>
                              ref.read(salesProvider.notifier).getSales(),
                          tooltip: 'Refresh sales data',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by Sale ID...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sales List Content
          Expanded(
            child: salesStateAsync.when(
              data: (salesState) {
                final allSales = salesState.sales;

                // Filter sales by search query
                final sales = _searchQuery.isEmpty
                    ? allSales
                    : allSales
                        .where((sale) =>
                            sale.id.toLowerCase().contains(_searchQuery))
                        .toList();

                if (sales.isEmpty) {
                  final selectedDate =
                      salesState.selectedDate ?? DateTime.now();

                  // Show different messages for filtered vs no sales
                  if (_searchQuery.isNotEmpty && allSales.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.search_off_rounded,
                                size: 64, color: Colors.grey[400]),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No Matching Sales',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No sales found matching "$_searchQuery"',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.receipt_long_outlined,
                              size: 64, color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Sales Found',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No transactions recorded on ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: sales.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final sale = sales[index];
                    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
                    final saleDate =
                        DateTime.tryParse(sale.createdAt)?.toLocal();
                    final paymentColor =
                        _getPaymentMethodColor(sale.paymentMethod);
                    final paymentIcon =
                        _getPaymentMethodIcon(sale.paymentMethod);

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          expansionTileTheme: ExpansionTileThemeData(
                            backgroundColor: Colors.transparent,
                            collapsedBackgroundColor: Colors.transparent,
                            iconColor: AppColors.primary,
                            collapsedIconColor: AppColors.primary,
                          ),
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.all(20),
                          childrenPadding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.1),
                                  AppColors.primary.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.receipt_rounded,
                                color: AppColors.primary, size: 24),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Sale #${sale.id.substring(sale.id.length - 8).toUpperCase()}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (hasVoidPermission)
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.red,
                                            Colors.red.withOpacity(0.8)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onTap: () => _showVoidDialog(
                                              context, ref, sale),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                    Icons
                                                        .delete_outline_rounded,
                                                    color: Colors.white,
                                                    size: 16),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Void',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.green.withOpacity(0.2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.attach_money_rounded,
                                            color: Colors.green[700], size: 16),
                                        Text(
                                          '${sale.totalAmount.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: paymentColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: paymentColor.withOpacity(0.2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(paymentIcon,
                                            color: paymentColor, size: 14),
                                        const SizedBox(width: 6),
                                        Text(
                                          parsePaymentMethod(
                                              sale.paymentMethod),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: paymentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (saleDate != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_rounded,
                                        size: 14, color: Colors.grey[500]),
                                    const SizedBox(width: 6),
                                    Text(
                                      dateFormat.format(saleDate),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                          children: [
                            if (sale.saleItems.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    "No items found for this sale",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: sale.saleItems
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    final isLast =
                                        index == sale.saleItems.length - 1;

                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: isLast
                                            ? null
                                            : Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[200]!,
                                                    width: 1),
                                              ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.inventory_2_rounded,
                                              color: AppColors.secondary,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.product.name,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _determineItemQuantityDisplay(
                                                      item),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  _determineItemPriceInfoDisplay(
                                                      item),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "₱${_calculateItemSubtotal(item).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.error_outline_rounded,
                            color: Colors.red, size: 40),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to Load Sales',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVoidDialog(BuildContext context, WidgetRef ref, sale) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              Text('Confirm Void',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          content: Text(
            'Are you sure you want to void Sale ID: ${sale.id.substring(0, 8)}? This action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Void Sale',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await ref.read(salesProvider.notifier).deleteSale(sale.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Sale ${sale.id.substring(0, 8)} voided successfully.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
