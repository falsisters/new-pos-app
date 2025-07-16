// ignore_for_file: unused_result

import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_product_dto_model.dart';
import 'package:falsisters_pos_android/features/deliveries/data/providers/delivery_provider.dart';
import 'package:falsisters_pos_android/features/deliveries/presentation/screens/confirm_delivery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TruckList extends ConsumerWidget {
  const TruckList({
    super.key,
  });

  void _handleConfirmDelivery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfirmDeliveryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryState = ref.watch(deliveryProvider);

    return Focus(
      autofocus: false,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          // Only trigger if there are items in the truck
          final state = deliveryState.valueOrNull;
          if (state != null && state.truck.products.isNotEmpty) {
            _handleConfirmDelivery(context);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Container(
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
            // Modern Header
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.15),
                    AppColors.secondary.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondary,
                          AppColors.secondary.withOpacity(0.8)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(Icons.local_shipping_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Truck',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
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
                          color: AppColors.secondary, size: 24),
                      onPressed: () {
                        ref.refresh(deliveryProvider);
                      },
                      tooltip: 'Refresh truck data',
                    ),
                  ),
                ],
              ),
            ),

            // Truck Items Count
            deliveryState.when(
              data: (state) {
                final productCount = state.truck.products.length;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: AppColors.secondary.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inventory_2_rounded,
                                size: 18, color: AppColors.secondary),
                            const SizedBox(width: 8),
                            Text(
                              '$productCount item${productCount != 1 ? 's' : ''} loaded',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
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

            // Truck List
            Expanded(
              child: deliveryState.when(
                data: (state) {
                  final products = state.truck.products;
                  if (products.isEmpty) {
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
                            child: Icon(Icons.local_shipping_outlined,
                                size: 64, color: Colors.grey[400]),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Truck is Empty',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add products from the list to start loading',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    itemCount: products.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.inventory_2_rounded,
                                    color: AppColors.primary, size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    _buildQuantityInfo(product),
                                  ],
                                ),
                              ),
                              // Delete button
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      ref
                                          .read(deliveryProvider.notifier)
                                          .removeProductFromTruck(product);

                                      // Show success message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(Icons.check_circle_rounded,
                                                  color: Colors.white,
                                                  size: 20),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  '${product.name} removed from truck',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                  ),
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
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
                error: (error, stackTrace) => Center(
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
                          'Failed to Load Truck',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Error: $error',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Summary section
            deliveryState.when(
              data: (state) {
                final products = state.truck.products;
                if (products.isEmpty) return const SizedBox.shrink();

                return Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[50]!,
                        Colors.white,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border(
                      top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Items',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            '${products.length}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _handleConfirmDelivery(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shadowColor: AppColors.secondary.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_rounded, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Confirm Delivery',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityInfo(DeliveryProductDtoModel product) {
    if (product.sackPrice != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.scale_rounded, color: Colors.blue, size: 12),
            const SizedBox(width: 4),
            Text(
              '${product.sackPrice!.quantity.toStringAsFixed(0)} ${product.sackPrice!.quantity == 1 ? 'sack' : 'sacks'}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );
    } else if (product.perKiloPrice != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.scale_rounded, color: Colors.green, size: 12),
            const SizedBox(width: 4),
            Text(
              '${product.perKiloPrice!.quantity.toStringAsFixed(1)} kg',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    } else {
      return Text(
        'No quantity information',
        style: TextStyle(
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
          fontSize: 12,
        ),
      );
    }
  }
}
