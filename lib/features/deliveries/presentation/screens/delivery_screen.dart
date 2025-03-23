import 'package:falsisters_pos_android/features/deliveries/presentation/widgets/product_list.dart';
import 'package:falsisters_pos_android/features/deliveries/presentation/widgets/truck_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryScreen extends ConsumerWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Header or controls can go here

            // Main content area with product list and truck list
            Expanded(
              child: Row(
                children: [
                  // Product listing (70% of space)
                  Expanded(
                    flex: 7,
                    child: DeliveryProductList(),
                  ),

                  const SizedBox(width: 8),

                  // Truck list (30% of space)
                  const Expanded(
                    flex: 3,
                    child: TruckList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
