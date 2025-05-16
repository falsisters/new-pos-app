import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/stocks/presentation/widgets/edit_price_form.dart';
import 'package:falsisters_pos_android/features/stocks/presentation/widgets/transfer_stock_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductEditingScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductEditingScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductEditingScreen> createState() =>
      _ProductEditingScreenState();
}

class _ProductEditingScreenState extends ConsumerState<ProductEditingScreen>
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
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text("Edit Product"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Reduced padding
          child: Column(
            children: [
              // Product info card
              Card(
                elevation: 3, // Reduced elevation
                shadowColor: AppColors.primary.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Reduced radius
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Reduced padding
                  child: Row(
                    children: [
                      Container(
                        width: 60, // Reduced size
                        height: 60, // Reduced size
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(8), // Reduced radius
                        ),
                        child: widget.product.picture ==
                                "https://placehold.co/800x800?text=Product"
                            ? Icon(
                                Icons.inventory_2_outlined,
                                size: 30, // Reduced icon size
                                color: AppColors.primary,
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(8), // Reduced radius
                                child: Image.network(
                                  widget.product.picture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12), // Reduced spacing
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 18, // Reduced font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2), // Reduced spacing
                            Text(
                              'Product ID: ${widget.product.id}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12, // Reduced font size
                              ),
                            ),
                            const SizedBox(height: 2), // Reduced spacing
                            Text(
                              'Last Updated: ${widget.product.updatedAt.toLocal().toString().split('.')[0]}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 10, // Reduced font size
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16), // Reduced spacing

              // Tab controller section
              Expanded(
                child: Card(
                  elevation: 2, // Reduced elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Reduced radius
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: Colors.grey.shade600,
                        indicatorColor: AppColors.accent,
                        indicatorWeight: 2.5, // Slightly reduced weight
                        labelStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500), // Reduced font size
                        unselectedLabelStyle:
                            const TextStyle(fontSize: 13), // Reduced font size
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.attach_money,
                                size: 20), // Reduced icon size
                            text: "Edit Price",
                          ),
                          Tab(
                            icon: Icon(Icons.swap_horiz,
                                size: 20), // Reduced icon size
                            text: "Transfer Stock",
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Edit Price Content
                            SingleChildScrollView(
                              child: EditPriceForm(
                                product: widget.product,
                              ),
                            ),

                            // Transfer Stock Content
                            SingleChildScrollView(
                              child: TransferStockForm(
                                product: widget.product,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
