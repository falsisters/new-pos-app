import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:falsisters_pos_android/features/sales/presentation/widgets/cart_list.dart';
import 'package:falsisters_pos_android/features/sales/presentation/widgets/product_list.dart';
import 'package:falsisters_pos_android/features/sales/presentation/widgets/sales_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Removed title
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        // Using just the TabBar as the primary component in the AppBar
        // This maximizes the space for content
        title: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.secondary,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white.withOpacity(0.7),
          tabs: const [
            Tab(icon: Icon(Icons.storefront), text: 'Products & Cart'),
            Tab(icon: Icon(Icons.receipt_long), text: 'Recent Sales'),
          ],
          // Make tabs more prominent since they're the main navigation now
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          indicatorWeight: 3.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Products & Cart View
            Row(
              children: [
                const Expanded(
                  flex: 7, // 70% of the space
                  child: ProductList(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3, // 30% of the space
                  child: CartList(),
                ),
              ],
            ),
            // Sales List View
            const SalesListWidget(),
          ],
        ),
      ),
    );
  }
}
