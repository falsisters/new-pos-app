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
      appBar: AppBar(
        title: const Text('Sales Check'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          // Integrate the date filter widget
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: SalesCheckDateFilter(),
          ),
          // Add a divider for better visual separation
          const Divider(height: 1, thickness: 1),
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
                        const Icon(Icons.receipt_long,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No sales data found for the selected filters.',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[700],
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
                        _SectionHeader(title: 'Sales Grouped by Product'),
                        const SizedBox(height: 10),
                        if (groupedData.isEmpty)
                          const Text('No grouped sales data.')
                        else
                          ...groupedData.map((group) {
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      group.productName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ...group.items
                                        .map((item) => _FormattedSaleRow(
                                              formattedSale: item.formattedSale,
                                            )),
                                    const _Divider(),
                                    _TotalsRow(
                                      label: group.totalQuantity
                                          .toStringAsFixed(0),
                                      amount: group.totalAmount,
                                      numberFormat: numberFormat,
                                      isBold: true,
                                    ),
                                    if (group.paymentTotals.check > 0)
                                      _TotalsRow(
                                        label: 'CHECK',
                                        amount: group.paymentTotals.check,
                                        numberFormat: numberFormat,
                                      ),
                                    if (group.paymentTotals.bankTransfer > 0)
                                      _TotalsRow(
                                        label: 'TRANSFER',
                                        amount:
                                            group.paymentTotals.bankTransfer,
                                        numberFormat: numberFormat,
                                      ),
                                    if ((group.paymentTotals.check > 0 ||
                                            group.paymentTotals.bankTransfer >
                                                0) &&
                                        group.paymentTotals.cash > 0) ...[
                                      const _Divider(indent: 10),
                                      _TotalsRow(
                                        label: 'CASH',
                                        amount: group.paymentTotals.cash,
                                        numberFormat: numberFormat,
                                        isBold: true,
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            );
                          }),
                        const SizedBox(height: 20),
                        _SectionHeader(title: 'Total Sales (Chronological)'),
                        const SizedBox(height: 10),
                        if (totalData.items.isEmpty)
                          const Text('No chronological sales data.')
                        else
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...totalData.items
                                      .map((item) => _FormattedSaleRow(
                                            formattedSale: item.formattedSale,
                                            time: item.formattedTime,
                                          )),
                                  const _Divider(),
                                  _TotalsRow(
                                    label: totalData.summary.totalQuantity
                                        .toStringAsFixed(0),
                                    amount: totalData.summary.totalAmount,
                                    numberFormat: numberFormat,
                                    isBold: true,
                                  ),
                                  if (totalData
                                          .summary.summaryPaymentTotals.check >
                                      0)
                                    _TotalsRow(
                                      label: 'CHECKS',
                                      amount: totalData
                                          .summary.summaryPaymentTotals.check,
                                      numberFormat: numberFormat,
                                    ),
                                  if (totalData.summary.summaryPaymentTotals
                                          .bankTransfer >
                                      0)
                                    _TotalsRow(
                                      label: 'TRANSFER',
                                      amount: totalData.summary
                                          .summaryPaymentTotals.bankTransfer,
                                      numberFormat: numberFormat,
                                    ),
                                  if ((totalData.summary.summaryPaymentTotals
                                                  .check >
                                              0 ||
                                          totalData.summary.summaryPaymentTotals
                                                  .bankTransfer >
                                              0) &&
                                      totalData.summary.summaryPaymentTotals
                                              .cash >
                                          0) ...[
                                    const _Divider(indent: 10),
                                    _TotalsRow(
                                      label: 'CASH',
                                      amount: totalData
                                          .summary.summaryPaymentTotals.cash,
                                      numberFormat: numberFormat,
                                      isBold: true,
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        // Add a summary card for grand totals
                        Card(
                          color: AppColors.primary.withOpacity(0.1),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'GRAND TOTAL',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  numberFormat
                                      .format(totalData.summary.totalAmount),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          if (time != null)
            Text('$time ', style: const TextStyle(fontSize: 12)),
          Expanded(
            child: Text(formattedSale),
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

  const _TotalsRow({
    required this.label,
    required this.amount,
    required this.numberFormat,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(label, textAlign: TextAlign.right)),
          const SizedBox(width: 10),
          const Spacer(flex: 3),
          Expanded(
            flex: 2,
            child: Text(
              numberFormat.format(amount),
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final double indent;
  const _Divider({this.indent = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 50.0 + indent, right: 80.0),
      child: const Divider(
        height: 10,
        thickness: 1,
        color: Colors.grey,
      ),
    );
  }
}
