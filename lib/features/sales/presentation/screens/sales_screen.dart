// Generate a stateless widget with a centered tesxt "Sales Screen"
import 'package:falsisters_pos_android/features/sales/presentation/widgets/cart_list.dart';
import 'package:falsisters_pos_android/features/sales/presentation/widgets/product_list.dart';
import 'package:flutter/material.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        // Add padding to the borders

        children: [
          // Header or controls can go here

          // Product listing

          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 7, // 70% of the space
                  child: const ProductList(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3, // 30% of the space
                  child: const CartList(),
                ),
              ],
            ),
          )

          // Cart or order summary could go here
        ],
      ),
    ));
  }
}
