import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/sales_check/data/providers/sales_check_provider.dart';
import 'package:falsisters_pos_android/features/sales_check/presentation/widgets/sales_check_filter_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SalesCheckScreen extends ConsumerWidget {
  const SalesCheckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesState = ref.watch(salesCheckProvider);
    final numberFormat = NumberFormat("#,##0.00", "en_US");

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Sales Check'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter widget
          Container(
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: SalesCheckDateFilter(),
            ),
          ),
          // Subtle separator
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          Expanded(
            child: salesState.when(
              data: (state) {
                if (state.error != null) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.groupedSales == null || state.totalSales == null) {
                  return const Center(child: Text('Loading sales data...'));
                }
                if (state.groupedSales!.isEmpty &&
                    state.totalSales!.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No sales data found for the selected filters.',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                final groupedData = state.groupedSales!;
                final totalData = state.totalSales!;

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(salesCheckProvider.notifier).refresh(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SWITCHED ORDER: Total Sales first
                        _SectionHeader(title: 'Total Sales (Chronological)'),
                        const SizedBox(height: 12),
                        if (totalData.items.isEmpty)
                          _EmptyStateCard(
                              message: 'No chronological sales data.')
                        else
                          Card(
                            elevation: 3,
                            shadowColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                // Header with better styling
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Time column header
                                      SizedBox(
                                        width: 60,
                                        child: Text(
                                          'Time',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Colors.grey[700],
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      // Product & Details column header
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          'Product & Details',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Colors.grey[700],
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      // Sales column header
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          'Sales',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Colors.grey[700],
                                            letterSpacing: 0.5,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Content
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      // Sales items
                                      ...totalData.items
                                          .map((item) => _FormattedSaleRow(
                                                formattedSale:
                                                    item.formattedSale,
                                                time: item.formattedTime,
                                              )),
                                      const SizedBox(height: 8),
                                      _StyledDivider(),
                                      const SizedBox(height: 8),
                                      _TotalsRow(
                                        label: totalData.summary.totalQuantity
                                            .toStringAsFixed(0),
                                        amount: totalData.summary.totalAmount,
                                        numberFormat: numberFormat,
                                        isBold: true,
                                        isGrandTotal: true,
                                      ),
                                      if (totalData.summary.summaryPaymentTotals
                                              .check >
                                          0)
                                        _TotalsRow(
                                          label: 'CHECK',
                                          amount: totalData.summary
                                              .summaryPaymentTotals.check,
                                          numberFormat: numberFormat,
                                        ),
                                      if (totalData.summary.summaryPaymentTotals
                                              .bankTransfer >
                                          0)
                                        _TotalsRow(
                                          label: 'TRANSFER',
                                          amount: totalData
                                              .summary
                                              .summaryPaymentTotals
                                              .bankTransfer,
                                          numberFormat: numberFormat,
                                        ),
                                      if ((totalData
                                                      .summary
                                                      .summaryPaymentTotals
                                                      .check >
                                                  0 ||
                                              totalData
                                                      .summary
                                                      .summaryPaymentTotals
                                                      .bankTransfer >
                                                  0) &&
                                          totalData.summary.summaryPaymentTotals
                                                  .cash >
                                              0) ...[
                                        const SizedBox(height: 4),
                                        _StyledDivider(isSubdivider: true),
                                        const SizedBox(height: 4),
                                        _TotalsRow(
                                          label: 'CASH',
                                          amount: totalData.summary
                                              .summaryPaymentTotals.cash,
                                          numberFormat: numberFormat,
                                          isBold: true,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),

                        // Sales Grouped by Product (second)
                        _SectionHeader(title: 'Sales Grouped by Product'),
                        const SizedBox(height: 12),
                        if (groupedData.isEmpty)
                          _EmptyStateCard(message: 'No grouped sales data.')
                        else
                          ...groupedData.map((group) {
                            return Card(
                              elevation: 3,
                              shadowColor: Colors.black12,
                              margin: const EdgeInsets.only(bottom: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  // Product header
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primary.withOpacity(0.1),
                                          AppColors.primary.withOpacity(0.05),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          color: AppColors.primary,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          group.productName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Column headers
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                    ),
                                    child: Row(
                                      children: [
                                        // Qty column header
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            'Qty',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                              letterSpacing: 0.5,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Product & Type column header
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Product & Type',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        // Amount column header
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            'Amount',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                              letterSpacing: 0.5,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Content
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        // Sales rows
                                        ...group.items
                                            .map((item) => _FormattedSaleRow(
                                                  formattedSale:
                                                      item.formattedSale,
                                                )),
                                        const SizedBox(height: 8),
                                        _StyledDivider(),
                                        const SizedBox(height: 8),
                                        _TotalsRow(
                                          label: group.totalQuantity
                                              .toStringAsFixed(0),
                                          amount: group.totalAmount,
                                          numberFormat: numberFormat,
                                          isBold: true,
                                          isGrandTotal: true,
                                        ),
                                        if (group.paymentTotals.check > 0)
                                          _TotalsRow(
                                            label: 'CHECK',
                                            amount: group.paymentTotals.check,
                                            numberFormat: numberFormat,
                                          ),
                                        if (group.paymentTotals.bankTransfer >
                                            0)
                                          _TotalsRow(
                                            label: 'TRANSFER',
                                            amount: group
                                                .paymentTotals.bankTransfer,
                                            numberFormat: numberFormat,
                                          ),
                                        if ((group.paymentTotals.check > 0 ||
                                                group.paymentTotals
                                                        .bankTransfer >
                                                    0) &&
                                            group.paymentTotals.cash > 0) ...[
                                          const SizedBox(height: 4),
                                          _StyledDivider(isSubdivider: true),
                                          const SizedBox(height: 4),
                                          _TotalsRow(
                                            label: 'CASH',
                                            amount: group.paymentTotals.cash,
                                            numberFormat: numberFormat,
                                            isBold: true,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                        const SizedBox(height: 20),

                        // Grand total summary card
                        Card(
                          elevation: 6,
                          shadowColor: AppColors.primary.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.1),
                                  AppColors.primary.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'GRAND TOTAL',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                            letterSpacing: 1.2,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '₱${numberFormat.format(totalData.summary.totalAmount)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Failed to load sales: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(salesCheckProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            title.contains('Total') ? Icons.timeline : Icons.category,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final String message;

  const _EmptyStateCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormattedSaleRow extends StatelessWidget {
  final String formattedSale;
  final String? time;

  const _FormattedSaleRow({
    required this.formattedSale,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    // Extract quantity part from the formattedSale if possible
    final parts = formattedSale.split(' ');
    String quantity = '';
    String remainingText = formattedSale;

    // Try to extract quantity if it's a number at the beginning
    if (parts.isNotEmpty) {
      if (RegExp(r'^\d+(\.\d+)?$').hasMatch(parts[0])) {
        quantity = parts[0];
        remainingText = parts.sublist(1).join(' ');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display time if provided (for chronological view)
          if (time != null)
            SizedBox(
              width: 60,
              child: Text(
                time!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // If we have a quantity (extracted from formattedSale)
          if (quantity.isNotEmpty)
            SizedBox(
              width: 80,
              child: Text(
                quantity,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ),

          // Add spacing between quantity and description
          if (quantity.isNotEmpty) const SizedBox(width: 16),

          // Show the remaining text (without quantity if extracted)
          Expanded(
            flex: 4,
            child: Text(
              quantity.isEmpty ? formattedSale : remainingText,
              style: const TextStyle(
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  final String label;
  final double amount;
  final NumberFormat numberFormat;
  final bool isBold;
  final bool isGrandTotal;

  const _TotalsRow({
    required this.label,
    required this.amount,
    required this.numberFormat,
    this.isBold = false,
    this.isGrandTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          // Align with the quantity column
          SizedBox(
            width: 80,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: isGrandTotal
                    ? AppColors.primary
                    : isBold
                        ? Colors.grey[800]
                        : Colors.grey[700],
                fontSize: isBold ? 15 : 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Spacer(flex: 4),
          // Amount value
          SizedBox(
            width: 100,
            child: Text(
              numberFormat.format(amount),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: isGrandTotal
                    ? AppColors.primary
                    : isBold
                        ? Colors.grey[800]
                        : Colors.grey[700],
                fontSize: isBold ? 15 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StyledDivider extends StatelessWidget {
  final bool isSubdivider;
  const _StyledDivider({this.isSubdivider = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: isSubdivider ? 40.0 : 80.0,
        right: isSubdivider ? 40.0 : 100.0,
      ),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.grey[300]!,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
