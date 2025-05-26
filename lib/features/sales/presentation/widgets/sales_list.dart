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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enhanced Header
          Container(
            padding: const EdgeInsets.all(20.0),
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(Icons.analytics, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Sales',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Track and manage recent transactions',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon:
                        Icon(Icons.refresh, color: AppColors.primary, size: 20),
                    onPressed: () {
                      ref.refresh(salesProvider.notifier).getSales();
                    },
                  ),
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
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.receipt_long_outlined,
                              size: 48, color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No recent sales found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sales transactions will appear here',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: salesState.sales.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final sale = salesState.sales[index];
                    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
                    final saleDate =
                        DateTime.tryParse(sale.createdAt)?.toLocal();

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ExpansionTile(
                        backgroundColor: Colors.transparent,
                        collapsedBackgroundColor: Colors.transparent,
                        iconColor: AppColors.primary,
                        collapsedIconColor: AppColors.primary,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.1),
                                AppColors.primary.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.receipt_long_outlined,
                              color: AppColors.primary, size: 20),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sale #${sale.id.substring(0, 8)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '₱${sale.totalAmount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.red.withOpacity(0.8)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.delete_outline, size: 16),
                                label: Text('Void',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
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
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  parsePaymentMethod(sale.paymentMethod),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                              if (saleDate != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  dateFormat.format(saleDate),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ],
                          ),
                        ),
                        childrenPadding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16),
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.grey[300]!,
                                  Colors.transparent
                                ],
                              ),
                            ),
                          ),
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.error_outline,
                            color: Colors.red, size: 32),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load sales',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
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
}
