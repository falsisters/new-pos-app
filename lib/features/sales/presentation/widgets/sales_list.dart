import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_payment_method.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SalesListWidget extends ConsumerWidget {
  final VoidCallback
      onEditSale; // Callback to potentially inform parent (e.g., switch tab)

  const SalesListWidget({super.key, required this.onEditSale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesStateAsync = ref.watch(salesProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14.0),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.history, color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                const Text(
                  'Recent Sales',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.primary),
                  onPressed: () {
                    // ignore: unused_result
                    ref.refresh(salesProvider.notifier).getSales();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: salesStateAsync.when(
              data: (salesState) {
                if (salesState.sales.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'No recent sales found',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: salesState.sales.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    final sale = salesState.sales[index];
                    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
                    final saleDate =
                        DateTime.tryParse(sale.createdAt)?.toLocal();

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        foregroundColor: AppColors.primary,
                        child: const Icon(Icons.receipt),
                      ),
                      title: Text(
                        'Sale ID: ${sale.id.substring(0, 8)}...', // Show partial ID
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Total: ₱${sale.totalAmount.toStringAsFixed(2)}'),
                          Text(
                              'Payment: ${parsePaymentMethod(sale.paymentMethod)}'),
                          if (saleDate != null)
                            Text('Date: ${dateFormat.format(saleDate)}'),
                        ],
                      ),
                      trailing: ElevatedButton.icon(
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () async {
                          await ref
                              .read(salesProvider.notifier)
                              .prepareSaleForEditing(sale);
                          onEditSale(); // Call callback to ensure tab switch if not handled by listener
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      const Text('Failed to load sales',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(error.toString(), textAlign: TextAlign.center),
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
}
