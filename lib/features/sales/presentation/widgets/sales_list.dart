import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_payment_method.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_sack_type.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_item.dart'; // Added for SaleItem type
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart'; // Added for SackType enum
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SalesListWidget extends ConsumerWidget {
  const SalesListWidget({super.key});

  String _formatSackType(SackType? sackType) {
    if (sackType == null) return 'KG';
    String name = parseSackType(sackType);
    return name.isNotEmpty ? name : 'KG Sack';
  }

  String _determineItemQuantityDisplay(SaleItem item) {
    String quantityStr =
        item.quantity.toStringAsFixed(item.quantity % 1 == 0 ? 0 : 1);
    String unit;

    if (item.sackPrice != null) {
      unit = _formatSackType(item.sackType);
      return "Qty: $quantityStr ${unit}(s)";
    } else if (item.isGantang) {
      return "Qty: $quantityStr gantang(s)";
    } else {
      return "Qty: $quantityStr kg";
    }
  }

  String _determineItemPriceInfoDisplay(SaleItem item) {
    if (item.discountedPrice != null &&
        (item.isDiscounted || item.isSpecialPrice)) {
      double unitPrice = 0;
      if (item.quantity > 0) {
        unitPrice = item.discountedPrice! / item.quantity;
      }
      String type = item.isDiscounted ? "Discounted" : "Special";
      if (unitPrice > 0) return "$type: @ ₱${unitPrice.toStringAsFixed(2)}";
      return type;
    }
    if (item.sackPrice != null) {
      return "Price: @ ₱${item.sackPrice!.price.toStringAsFixed(2)} per ${_formatSackType(item.sackType)}";
    }
    if (item.perKiloPrice != null) {
      return "Price: @ ₱${item.perKiloPrice!.price.toStringAsFixed(2)} per kg";
    }
    if (item.isGantang) {
      return "Gantang Price";
    }
    return "Price: N/A";
  }

  double _calculateItemSubtotal(SaleItem item) {
    if (item.discountedPrice != null) {
      return item.discountedPrice!;
    }
    if (item.sackPrice != null) {
      return item.quantity * item.sackPrice!.price;
    }
    if (item.perKiloPrice != null) {
      return item.quantity * item.perKiloPrice!.price;
    }
    return 0.0;
  }

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
                final sales = salesState.sales;
                if (sales == null || sales.isEmpty) {
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
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final sale = salesState.sales[index];
                    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
                    final saleDate =
                        DateTime.tryParse(sale.createdAt)?.toLocal();

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                            color: AppColors.primary.withOpacity(0.5),
                            width: 0.5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ExpansionTile(
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: Colors.white,
                        iconColor: AppColors.primary,
                        collapsedIconColor: AppColors.primary,
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          foregroundColor: AppColors.primary,
                          child: const Icon(Icons.receipt_long_outlined),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sale ID: ${sale.id.substring(0, 8)}...',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    'Total: ₱${sale.totalAmount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.delete_outline, size: 16),
                              label: const Text('Void'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.redAccent.withOpacity(0.8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                textStyle: const TextStyle(fontSize: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Confirm Void'),
                                      content: Text(
                                          'Are you sure you want to void Sale ID: ${sale.id.substring(0, 8)}...? This action cannot be undone.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.red),
                                          child: const Text('Void Sale'),
                                          onPressed: () async {
                                            Navigator.of(dialogContext).pop();
                                            // ignore: unused_result
                                            await ref
                                                .read(salesProvider.notifier)
                                                .deleteSale(sale.id);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Sale ${sale.id.substring(0, 8)} voided successfully.')),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment: ${parsePaymentMethod(sale.paymentMethod)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (saleDate != null)
                                Text(
                                  'Date: ${dateFormat.format(saleDate)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                        ),
                        childrenPadding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 8),
                        children: <Widget>[
                          const Divider(height: 1),
                          if (sale.saleItems.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                  child: Text(
                                "No items found for this sale.",
                                style: TextStyle(color: Colors.grey),
                              )),
                            )
                          else
                            ...sale.saleItems.map((item) {
                              String itemName = item.product.name;
                              String itemQuantityStr =
                                  _determineItemQuantityDisplay(item);
                              String itemPriceInfoStr =
                                  _determineItemPriceInfoDisplay(item);
                              String itemSubtotalStr =
                                  "₱${_calculateItemSubtotal(item).toStringAsFixed(2)}";

                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0),
                                leading: Icon(Icons.shopping_basket_outlined,
                                    color: AppColors.secondary, size: 20),
                                title: Text(itemName,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(itemQuantityStr,
                                        style: const TextStyle(fontSize: 12)),
                                    Text(itemPriceInfoStr,
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                                trailing: Text(itemSubtotalStr,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary)),
                              );
                            }).toList(),
                        ],
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
