// Create a cart list to show the products in the cart

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
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              border: Border(
                bottom: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.shopping_cart, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: salesState.when(
              data: (state) {
                final products = state.cart.products;
                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: _buildPriceInfo(product),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ref
                              .read(salesProvider.notifier)
                              .removeProductFromCart(
                                product,
                              );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 8),
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
                        fontSize: 18,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
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
                        borderRadius: BorderRadius.circular(8),
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
          'Price per kilo: ₱${product.perKiloPrice!.price * product.perKiloPrice!.quantity}');
    } else if (product.sackPrice != null) {
      return Text(
          'Sack price: ₱${product.sackPrice!.quantity * product.sackPrice!.price}');
    } else {
      return const Text('Price not available');
    }
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
        total += product.sackPrice!.quantity * product.sackPrice!.price;
      }
    }
    return total.toStringAsFixed(2);
  }
}
