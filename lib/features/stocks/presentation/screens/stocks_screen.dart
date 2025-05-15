import 'package:falsisters_pos_android/features/stocks/presentation/widgets/product_list.dart';
import 'package:falsisters_pos_android/features/stocks/presentation/widgets/transfers_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';

class StocksScreen extends ConsumerStatefulWidget {
  const StocksScreen({super.key});

  @override
  ConsumerState<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends ConsumerState<StocksScreen>
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
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        // Removed title
        elevation: 0,
        // Using just the TabBar as the primary component in the AppBar
        title: TabBar(
          controller: _tabController,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.primaryLight.withOpacity(0.7),
          indicatorColor: AppColors.accent,
          indicatorWeight: 3,
          // Make tabs more prominent since they're the main navigation now
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(
              icon: Icon(Icons.inventory_2_outlined),
              text: "Stock Management",
            ),
            Tab(
              icon: Icon(Icons.history_outlined),
              text: "Transfer History",
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: _tabController,
          children: const [
            // Stock Management Tab
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: StockProductList(),
                ),
              ],
            ),
            // Transfer History Tab
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TransfersList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
