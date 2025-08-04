// ignore_for_file: unused_result

import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sales_state.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:falsisters_pos_android/features/sales/presentation/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/features/sales/presentation/widgets/pending_sales_indicator.dart';
import 'package:intl/intl.dart';

class CartList extends ConsumerStatefulWidget {
  const CartList({
    super.key,
  });

  @override
  ConsumerState<CartList> createState() => _CartListState();
}

class _CartListState extends ConsumerState<CartList> {
  final FocusNode _focusNode = FocusNode();
  bool _isNavigating = false; // Track navigation state

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _proceedToCheckout() {
    if (_isNavigating || !mounted) {
      debugPrint(
          'Cart List - Navigation already in progress or widget not mounted');
      return;
    }

    final salesState = ref.read(salesProvider);
    try {
      if (salesState.valueOrNull?.cart.products.isEmpty ?? true) return;

      setState(() {
        _isNavigating = true;
      });

      final products = salesState.valueOrNull!.cart.products;

      // Calculate ceiling-rounded total here
      double ceilingTotal = 0.0;
      for (final product in products) {
        ceilingTotal += double.parse(_calculateItemTotal(product));
      }

      // Apply final ceiling rounding to the grand total
      final preciseGrandTotal = double.parse(ceilingTotal.toStringAsFixed(10));
      final finalCeiledTotal = (preciseGrandTotal * 100).ceil() / 100.0;

      // Use push instead of pushAndRemoveUntil to allow proper back navigation
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            products: products,
            total: finalCeiledTotal, // Pass ceiling-rounded total
          ),
        ),
      )
          .then((_) {
        // Reset navigation state when returning from checkout
        if (mounted) {
          setState(() {
            _isNavigating = false;
          });
        }
      });
    } catch (e) {
      debugPrint('Error in proceedToCheckout: $e');
      // Reset navigation state on error
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error proceeding to checkout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Safety checks to prevent interference from disposed widgets or navigation states
    if (!mounted || _isNavigating) {
      debugPrint(
          'Cart List - Key event ignored: mounted=$mounted, navigating=$_isNavigating');
      return KeyEventResult.ignored;
    }

    final salesState = ref.read(salesProvider);
    try {
      // Only handle key down events to prevent double triggering
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.enter) {
        debugPrint('Cart List - Key pressed: ${event.logicalKey}');
        // Check if cart is not empty before proceeding
        if (salesState.valueOrNull?.cart.products.isNotEmpty == true) {
          debugPrint('Cart List - Enter pressed, proceeding to checkout');
          // Use synchronous call to prevent async race conditions
          _proceedToCheckout();
          return KeyEventResult.handled;
        } else {
          debugPrint('Cart List - Enter pressed but cart is empty');
        }
      }
    } catch (e) {
      debugPrint('Error in keyboard handler: $e');
      // Don't rethrow to prevent crashes
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final salesState = ref.watch(salesProvider);

    return Focus(
      focusNode: _focusNode,
      autofocus: !_isNavigating, // Don't autofocus during navigation
      onKeyEvent: _handleKeyEvent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
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
                  // Add pending sales indicator
                  salesState.when(
                    data: (state) => PendingSalesIndicator(
                      pendingSales: state.pendingSales,
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.refresh,
                          color: AppColors.primary, size: 20),
                      onPressed: () {
                        ref.refresh(salesProvider);
                      },
                    ),
                  ),
                ],
              ),
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
                            padding: const EdgeInsets.all(16),
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
                                        Expanded(
                                            child: _buildPriceInfo(product)),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.local_offer,
                                                size: 16,
                                                color: AppColors.secondary),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Discount: ₱${NumberFormat('#,##0.00').format(product.discountedPrice!)} per ${product.perKiloPrice != null ? 'kg' : 'sack'}',
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
                                      'Total:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Text(
                                      '₱${NumberFormat('#,##0').format(double.parse(_calculateItemTotal(product)))}',
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
                              'Total:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '₱${NumberFormat('#,##0').format(double.parse(_calculateTotal(salesState)))}',
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
                              : _proceedToCheckout,
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
                            'Checkout ',
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
      ),
    );
  }

  Widget _buildPriceInfo(ProductDto product) {
    if (product.perKiloPrice != null) {
      String priceText =
          '₱${NumberFormat('#,##0.00').format(product.perKiloPrice!.price)}/kg';
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
      String priceText =
          '₱${NumberFormat('#,##0.00').format(product.sackPrice!.price)}/sack';
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
    // Define ceiling rounding function with improved precision
    double ceilRoundPrice(double value) {
      if (value.isNaN || value.isInfinite) return 0.0;
      if (value < 0) return 0.0;

      // Fix precision loss by converting to string first, then parsing back
      final valueStr = value.toStringAsFixed(10);
      final preciseValue = double.parse(valueStr);

      // Use proper rounding to avoid floating point precision issues
      final centsValue = (preciseValue * 100.0).round();
      final ceiledCents =
          ((centsValue + 99) ~/ 100) * 100; // Ceiling to next cent

      return ceiledCents / 100.0;
    }

    if (product.isDiscounted == true && product.discountedPrice != null) {
      // Apply ceiling-rounded discount per quantity
      double quantity = 1.0;
      if (product.perKiloPrice != null) {
        quantity = product.perKiloPrice!.quantity;
      } else if (product.sackPrice != null) {
        quantity = product.sackPrice!.quantity;
      }

      // Use ceiling-rounded discount price
      final ceiledDiscountPrice = ceilRoundPrice(product.discountedPrice!);
      final total = ceiledDiscountPrice * quantity;
      return ceilRoundPrice(total).toString();
    }

    double total = 0.0;
    if (product.perKiloPrice != null) {
      // Use ceiling-rounded unit price
      final ceiledUnitPrice = ceilRoundPrice(product.perKiloPrice!.price);
      total = ceiledUnitPrice * product.perKiloPrice!.quantity;
    } else if (product.sackPrice != null) {
      // Use ceiling-rounded unit price
      final ceiledUnitPrice = ceilRoundPrice(product.sackPrice!.price);
      total = ceiledUnitPrice * product.sackPrice!.quantity;
    }

    return ceilRoundPrice(total).toString();
  }

  String _calculateTotal(AsyncValue<SalesState> salesState) {
    if (salesState.valueOrNull == null) {
      return '0';
    }

    // Define ceiling rounding function with improved precision
    double ceilRoundPrice(double value) {
      if (value.isNaN || value.isInfinite) return 0.0;
      if (value < 0) return 0.0;

      // Fix precision loss by converting to string first, then parsing back
      final valueStr = value.toStringAsFixed(10);
      final preciseValue = double.parse(valueStr);

      // Use proper rounding to avoid floating point precision issues
      final centsValue = (preciseValue * 100.0).round();
      final ceiledCents =
          ((centsValue + 99) ~/ 100) * 100; // Ceiling to next cent

      return ceiledCents / 100.0;
    }

    double total = 0.0;
    for (final product in salesState.valueOrNull!.cart.products) {
      // Calculate each item's ceiling-rounded total and add to grand total
      total += double.parse(_calculateItemTotal(product));
    }

    // Apply ceiling rounding to the final grand total
    return ceilRoundPrice(total).toString();
  }
}
