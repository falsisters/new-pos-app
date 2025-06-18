// ignore_for_file: unused_result

import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sales_state.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:falsisters_pos_android/features/sales/presentation/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartList extends ConsumerWidget {
  const CartList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesState = ref.watch(salesProvider);

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
                  child: Icon(Icons.shopping_cart,
                      color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cart',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
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
                      ref.refresh(salesProvider);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Enhanced Cart Items Count
          salesState.when(
            data: (state) {
              final productCount = state.cart.products.length;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.secondary.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_bag,
                              size: 16, color: AppColors.secondary),
                          const SizedBox(width: 6),
                          Text(
                            '$productCount ${productCount == 1 ? 'item' : 'items'}',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(height: 20),
            ),
            error: (_, __) => const SizedBox(height: 20),
          ),

          // Enhanced Cart List
          Expanded(
            child: salesState.when(
              data: (state) {
                final products = state.cart.products;
                if (products.isEmpty) {
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
                          child: Icon(Icons.shopping_cart_outlined,
                              size: 48, color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add products to get started',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: products.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name and delete button
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.delete_outline,
                                        color: Colors.red[600], size: 20),
                                    onPressed: () {
                                      ref
                                          .read(salesProvider.notifier)
                                          .removeProductFromCart(product);
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Price and quantity info
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.attach_money,
                                          size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Expanded(child: _buildPriceInfo(product)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.inventory,
                                          size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Expanded(
                                          child: _buildQuantityInfo(product)),
                                    ],
                                  ),
                                  if (product.isDiscounted == true &&
                                      product.discountedPrice != null) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.local_offer,
                                              size: 16,
                                              color: AppColors.secondary),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Discounted: ₱${product.discountedPrice!.toStringAsFixed(2)} per ${product.perKiloPrice != null ? 'kg' : 'sack'}',
                                            style: TextStyle(
                                              color: AppColors.secondary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Total for this item
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.accent.withOpacity(0.1),
                                    AppColors.accent.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Item Total:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    '₱${_calculateItemTotal(product)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ],
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
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        'Error loading cart',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Enhanced Summary and checkout section
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[50]!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                top: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Total amount
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Total Amount:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₱${_calculateTotal(salesState)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Enhanced checkout button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        salesState.valueOrNull?.cart.products.isEmpty ?? true
                            ? null
                            : () {
                                final products =
                                    salesState.valueOrNull!.cart.products;
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CheckoutScreen(
                                      products: products,
                                      total: double.parse(
                                          _calculateTotal(salesState)));
                                }));
                              },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      shadowColor: AppColors.secondary.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Proceed to Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(ProductDto product) {
    if (product.perKiloPrice != null) {
      String priceText =
          '₱${product.perKiloPrice!.price.toStringAsFixed(2)}/kg';
      if (product.isDiscounted == true && product.discountedPrice != null) {
        priceText += ' (Original)';
      }
      return Text(
        priceText,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 14,
          decoration:
              (product.isDiscounted == true && product.discountedPrice != null)
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
        ),
      );
    } else if (product.sackPrice != null) {
      String priceText = '₱${product.sackPrice!.price.toStringAsFixed(2)}/sack';
      if (product.isDiscounted == true && product.discountedPrice != null) {
        priceText += ' (Original)';
      }
      return Text(
        priceText,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 14,
          decoration:
              (product.isDiscounted == true && product.discountedPrice != null)
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
        ),
      );
    } else {
      return Text(
        'Price not available',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      );
    }
  }

  Widget _buildQuantityInfo(ProductDto product) {
    if (product.perKiloPrice != null) {
      return Text(
        '${product.perKiloPrice!.quantity.toStringAsFixed(2)} kg',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (product.sackPrice != null) {
      return Text(
        '${product.sackPrice!.quantity} sack(s)',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  String _calculateItemTotal(ProductDto product) {
    if (product.isDiscounted == true && product.discountedPrice != null) {
      // Apply discount per quantity
      double quantity = 1.0;
      if (product.perKiloPrice != null) {
        quantity = product.perKiloPrice!.quantity;
      } else if (product.sackPrice != null) {
        quantity = product.sackPrice!.quantity;
      }
      return (product.discountedPrice! * quantity).toInt().toString();
    }

    double total = 0.0;
    if (product.perKiloPrice != null) {
      total =
          (product.perKiloPrice!.price * product.perKiloPrice!.quantity * 100)
                  .round() /
              100;
    } else if (product.sackPrice != null) {
      total = (product.sackPrice!.price * product.sackPrice!.quantity * 100)
              .round() /
          100;
    }

    return total.toInt().toString();
  }

  String _calculateTotal(AsyncValue<SalesState> salesState) {
    if (salesState.valueOrNull == null) {
      return '0';
    }

    double total = 0.0;
    for (final product in salesState.valueOrNull!.cart.products) {
      if (product.isDiscounted == true && product.discountedPrice != null) {
        // Apply discount per quantity
        double quantity = 1.0;
        if (product.perKiloPrice != null) {
          quantity = product.perKiloPrice!.quantity;
        } else if (product.sackPrice != null) {
          quantity = product.sackPrice!.quantity;
        }
        total += product.discountedPrice! * quantity;
      } else if (product.perKiloPrice != null) {
        double itemTotal =
            (product.perKiloPrice!.price * product.perKiloPrice!.quantity * 100)
                    .round() /
                100;
        total += itemTotal;
      } else if (product.sackPrice != null) {
        double itemTotal =
            (product.sackPrice!.price * product.sackPrice!.quantity * 100)
                    .round() /
                100;
        total += itemTotal;
      }
    }

    return total.toInt().toString();
  }
}
