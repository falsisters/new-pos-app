import 'package:falsisters_pos_android/features/stocks/presentation/widgets/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StocksScreen extends ConsumerWidget {
  const StocksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: const Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              // Header or controls can go here

              // Main content area with product list and truck list
              Expanded(
                child: Row(
                  children: [
                    // Product listing (70% of space)
                    Expanded(
                      flex: 1,
                      child: StockProductList(),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
