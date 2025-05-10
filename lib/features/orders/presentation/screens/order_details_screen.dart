import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/app/data/providers/home_provider.dart';
import 'package:falsisters_pos_android/features/orders/data/models/order_item_model.dart';
import 'package:falsisters_pos_android/features/orders/data/models/order_model.dart';
import 'package:falsisters_pos_android/features/orders/data/providers/order_provider.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart'; // For SackType
import 'package:falsisters_pos_android/features/sales/data/model/per_kilo_price_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sack_price_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

const int SALES_SCREEN_INDEX = 0; // Assuming Sales screen is at index 1

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch order details when the screen is initialized
    Future.microtask(
        () => ref.read(orderProvider.notifier).getOrderById(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final OrderModel? order = orderState.value?.selectedOrder;

    if (orderState.isLoading && order == null) {
      return _buildScaffold(
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    if (orderState.hasError && order == null) {
      return _buildScaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.accent.withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading order',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  orderState.error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref
                    .read(orderProvider.notifier)
                    .getOrderById(widget.orderId),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (order == null) {
      return _buildScaffold(
        body: const Center(
          child: Text(
            'Order not found or still loading.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return _buildScaffold(
      title: 'Order #${order.id.substring(0, 8)}',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummaryCard(order),
            const SizedBox(height: 24),
            _buildCustomerInfoCard(order),
            const SizedBox(height: 24),
            _buildOrderItemsSection(order),
            const SizedBox(height: 32),
            _buildActionButtons(order),
          ],
        ),
      ),
    );
  }

  Widget _buildScaffold({Widget? body, String title = 'Order Details'}) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: body,
    );
  }

  Widget _buildOrderSummaryCard(OrderModel order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              Color(0xFF1A3D99)
            ], // Darker shade of primary
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.receipt_long,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${order.id.substring(0, 8)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat.yMMMd().add_jm().format(order.createdAt),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    "PHP ${order.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard(OrderModel order) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: AppColors.secondary),
                const SizedBox(width: 12),
                const Text(
                  "Customer Information",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(
                Icons.account_circle_outlined, "Name", order.customer.name),
            _buildInfoRow(Icons.phone, "Phone", order.customer.phone),
            if (order.customer.address.isNotEmpty)
              _buildInfoRow(Icons.location_on_outlined, "Address",
                  order.customer.address),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              const Icon(Icons.shopping_bag, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                'Order Items (${order.orderItems.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (order.orderItems.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No items in this order.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.orderItems.length,
            itemBuilder: (context, index) {
              final item = order.orderItems[index];
              return _buildOrderItemCard(item, index);
            },
          ),
      ],
    );
  }

  Widget _buildOrderItemCard(OrderItemModel item, int index) {
    final unitPrice = _calculateItemPrice(item);
    final subtotal = unitPrice * item.quantity;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getItemColor(index).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.inventory_2,
                    color: _getItemColor(index),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (item.isSpecialPrice)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Special Price',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildItemDetailColumn('Quantity', '${item.quantity}'),
                  _buildItemDetailColumn(
                    'Unit Price',
                    item.isSpecialPrice
                        ? 'Special'
                        : 'PHP ${unitPrice.toStringAsFixed(2)}',
                  ),
                  _buildItemDetailColumn(
                    'Subtotal',
                    'PHP ${subtotal.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildItemDetailColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getItemColor(int index) {
    List<Color> colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      Colors.teal,
      Colors.purple,
    ];

    return colors[index % colors.length];
  }

  Widget _buildActionButtons(OrderModel order) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Reject Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  shadowColor: Colors.redAccent.withOpacity(0.3),
                ),
                onPressed: () async {
                  await ref.read(orderProvider.notifier).rejectOrder(order.id);
                  ref.read(orderProvider.notifier).refreshOrders();
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle, size: 20),
                label: const Text(
                  'Accept Order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  shadowColor: AppColors.secondary.withOpacity(0.3),
                ),
                onPressed: () {
                  final productDtos = order.orderItems.map((item) {
                    PerKiloPriceDto? perKiloPriceDto;
                    SackPriceDto? sackPriceDto;

                    if (item.perKiloPrice != null &&
                        item.perKiloPriceId != null) {
                      perKiloPriceDto = PerKiloPriceDto(
                        id: item.perKiloPriceId!,
                        quantity: item.quantity,
                        price: item.perKiloPrice!.price,
                      );
                    }

                    if (item.sackPrice != null && item.sackPriceId != null) {
                      sackPriceDto = SackPriceDto(
                        id: item.sackPriceId!,
                        quantity: item.quantity,
                        price: item.sackPrice!.price,
                        type: item.sackPrice!.type,
                      );
                    }

                    final bool isGantang =
                        item.sackPrice?.type == SackType.FIVE_KG;

                    return ProductDto(
                      id: item.productId,
                      name: item.product.name,
                      isGantang: isGantang,
                      isSpecialPrice: item.isSpecialPrice,
                      perKiloPrice: perKiloPriceDto,
                      sackPrice: sackPriceDto,
                    );
                  }).toList();

                  ref
                      .read(salesProvider.notifier)
                      .setCartItems(productDtos, order.id);
                  ref
                      .read(drawerIndexProvider.notifier)
                      .setIndex(SALES_SCREEN_INDEX);

                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateItemPrice(OrderItemModel item) {
    if (item.isSpecialPrice) {
      return 0;
    }
    if (item.sackPrice != null) {
      return item.sackPrice!.price;
    }
    if (item.perKiloPrice != null) {
      return item.perKiloPrice!.price;
    }
    return 0;
  }
}
