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
          // Header
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
                const Icon(Icons.shopping_cart,
                    color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                const Text(
                  'Cart',
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
                    ref.refresh(salesProvider);
                  },
                ),
              ],
            ),
          ),

          // Cart Items Count
          salesState.when(
            data: (state) {
              final productCount = state.cart.products.length;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$productCount ${productCount == 1 ? 'item' : 'items'} in cart',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(height: 20),
            ),
            error: (_, __) => const SizedBox(height: 20),
          ),

          // Cart List
          Expanded(
            child: salesState.when(
              data: (state) {
                final products = state.cart.products;
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'Your cart is empty',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  itemCount: products.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        title: Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            _buildPriceInfo(product),
                            const SizedBox(height: 2),
                            _buildQuantityInfo(product),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₱${_calculateItemTotal(product)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Remove Item'),
                                    content: Text(
                                        'Remove ${product.name} from cart?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('CANCEL'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          ref
                                              .read(salesProvider.notifier)
                                              .removeProductFromCart(product);
                                        },
                                        child: const Text('REMOVE'),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
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
                        style: const TextStyle(
                          color: Colors.grey,
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

          // Summary and checkout section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: const Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '₱${_calculateTotal(salesState)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
      return Text(
        'Price: ₱${product.perKiloPrice!.price.toStringAsFixed(2)}/kg',
        style: TextStyle(
          color: Colors.grey[700],
        ),
      );
    } else if (product.sackPrice != null) {
      return Text(
        'Price: ₱${product.sackPrice!.price.toStringAsFixed(2)}/sack',
        style: TextStyle(
          color: Colors.grey[700],
        ),
      );
    } else {
      return Text(
        'Price not available',
        style: TextStyle(
          color: Colors.grey[700],
          fontStyle: FontStyle.italic,
        ),
      );
    }
  }

  Widget _buildQuantityInfo(ProductDto product) {
    if (product.perKiloPrice != null) {
      return Text(
        'Quantity: ${product.perKiloPrice!.quantity.toStringAsFixed(2)} kg',
        style: TextStyle(
          color: Colors.grey[700],
        ),
      );
    } else if (product.sackPrice != null) {
      return Text(
        'Quantity: ${product.sackPrice!.quantity} sack(s)',
        style: TextStyle(
          color: Colors.grey[700],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  String _calculateItemTotal(ProductDto product) {
    double total = 0.0;
    if (product.perKiloPrice != null) {
      total = product.perKiloPrice!.price * product.perKiloPrice!.quantity;
    } else if (product.sackPrice != null) {
      total = product.sackPrice!.price * product.sackPrice!.quantity;
    }
    // Truncate the decimal part
    return total.toInt().toString();
  }

  String _calculateTotal(AsyncValue<SalesState> salesState) {
    if (salesState.valueOrNull == null) {
      return '0.00';
    }

    double total = 0.0;
    for (final product in salesState.valueOrNull!.cart.products) {
      if (product.perKiloPrice != null) {
        total += product.perKiloPrice!.price * product.perKiloPrice!.quantity;
      } else if (product.sackPrice != null) {
        total += product.sackPrice!.price * product.sackPrice!.quantity;
      }
    }
    return total.toInt().toString();
  }
}
