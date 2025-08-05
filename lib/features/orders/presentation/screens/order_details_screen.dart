import 'package:decimal/decimal.dart';
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryLighter,
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Loading order details...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
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
      title: 'Order Details',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOrderSummaryCard(order),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildCustomerInfoCard(order),
                        const SizedBox(height: 16),
                        _buildActionButtons(order),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _buildOrderItemsSection(order),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScaffold({Widget? body, String title = 'Order Details'}) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(orderProvider.notifier).getOrderById(widget.orderId),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Order',
          ),
        ],
      ),
      body: body,
    );
  }

  Widget _buildOrderSummaryCard(OrderModel order) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order #${order.id.substring(0, 8)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMd().add_jm().format(order.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "PHP ${order.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard(OrderModel order) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLighter,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.secondary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Customer Info",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
                Icons.account_circle_outlined, "Name", order.customer.name),
            _buildInfoRow(Icons.phone_outlined, "Phone", order.customer.phone),
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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primaryLighter,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              size: 12,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection(OrderModel order) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.accentLighter,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.accent,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Items (${order.orderItems.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: order.orderItems.isEmpty
                ? Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'No items in this order.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    itemCount: order.orderItems.length,
                    itemBuilder: (context, index) {
                      final item = order.orderItems[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                index < order.orderItems.length - 1 ? 8 : 0),
                        child: _buildOrderItemCard(item, index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemCard(OrderItemModel item, int index) {
    final unitPrice = _calculateItemPrice(item);
    final subtotal = unitPrice * Decimal.parse(item.quantity.toString());

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _getItemColor(index).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: _getItemColor(index),
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (item.isSpecialPrice)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.accentLighter,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Special Price',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildItemDetailColumn('Qty', '${item.quantity}'),
                ),
                Container(width: 1, height: 20, color: AppColors.border),
                Expanded(
                  child: _buildItemDetailColumn(
                    'Price',
                    item.isSpecialPrice
                        ? 'Special'
                        : 'PHP ${unitPrice.toStringAsFixed(2)}',
                  ),
                ),
                Container(width: 1, height: 20, color: AppColors.border),
                Expanded(
                  child: _buildItemDetailColumn(
                    'Total',
                    'PHP ${subtotal.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetailColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
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
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check, size: 16),
            label: const Text(
              'Accept Order',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              final productDtos = order.orderItems.map((item) {
                PerKiloPriceDto? perKiloPriceDto;
                SackPriceDto? sackPriceDto;

                if (item.perKiloPrice != null && item.perKiloPriceId != null) {
                  perKiloPriceDto = PerKiloPriceDto(
                    id: item.perKiloPriceId!,
                    quantity: Decimal.parse(item.quantity.toString()),
                    price: item.perKiloPrice!.price,
                  );
                }

                if (item.sackPrice != null && item.sackPriceId != null) {
                  sackPriceDto = SackPriceDto(
                    id: item.sackPriceId!,
                    quantity: Decimal.parse(item.quantity.toString()),
                    price: item.sackPrice!.price,
                    type: item.sackPrice!.type,
                  );
                }

                final bool isGantang = item.sackPrice?.type == SackType.FIVE_KG;

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
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.close, size: 16),
            label: const Text(
              'Reject',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
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
      ],
    );
  }

  Decimal _calculateItemPrice(OrderItemModel item) {
    if (item.isSpecialPrice) {
      return Decimal.zero;
    }
    if (item.sackPrice != null) {
      return item.sackPrice!.price;
    }
    if (item.perKiloPrice != null) {
      return item.perKiloPrice!.price;
    }
    return Decimal.zero;
  }
}
