import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/orders/data/models/order_item_model.dart';
import 'package:falsisters_pos_android/features/orders/data/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
    final order = orderState.value?.selectedOrder;

    if (orderState.isLoading && order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (orderState.hasError && order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${orderState.error}'),
              ElevatedButton(
                onPressed: () => ref
                    .read(orderProvider.notifier)
                    .getOrderById(widget.orderId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('Order not found or still loading.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id.substring(0, 8)}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Order ID:', order.id),
            _buildDetailRow('Customer Name:', order.customer.name),
            _buildDetailRow('Customer Phone:', order.customer.phone),
            if (order.customer.address.isNotEmpty)
              _buildDetailRow('Customer Address:', order.customer.address),
            _buildDetailRow(
                'Total Price:', 'PHP ${order.totalPrice.toStringAsFixed(2)}'),
            _buildDetailRow('Created At:',
                DateFormat.yMMMEd().add_jm().format(order.createdAt)),
            _buildDetailRow('Updated At:',
                DateFormat.yMMMEd().add_jm().format(order.updatedAt)),
            const SizedBox(height: 20),
            Text('Order Items:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (order.orderItems.isEmpty)
              const Text('No items in this order.')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.orderItems.length,
                itemBuilder: (context, index) {
                  final item = order.orderItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.name,
                              style: Theme.of(context).textTheme.titleMedium),
                          _buildDetailRow(
                              'Quantity:', item.quantity.toString()),
                          _buildDetailRow('Unit Price:',
                              'PHP ${item.isSpecialPrice ? 'N/A (Special)' : _calculateItemPrice(item).toStringAsFixed(2)}'),
                          _buildDetailRow('Subtotal:',
                              'PHP ${(_calculateItemPrice(item) * item.quantity).toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  // TODO: Implement accept order functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Accept Order functionality pending.')),
                  );
                },
                child: const Text('Accept Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  double _calculateItemPrice(OrderItemModel item) {
    if (item.isSpecialPrice) {
      // For special prices, we might not have a per kilo or sack price directly
      // This logic might need adjustment based on how special prices are handled
      // For now, assuming special price means the price is embedded or calculated differently.
      // If item.product.price should be used for special price, adjust here.
      // Placeholder: if special price has its own value on item, use it.
      // Otherwise, it might be part of a more complex calculation not evident here.
      return 0; // Or determine special price based on other fields if available
    }
    if (item.sackPrice != null) {
      return item.sackPrice!.price;
    }
    if (item.perKiloPrice != null) {
      return item.perKiloPrice!.price;
    }
    // Fallback to product base price if available and not special price
    // Ensure ProductModel has a 'price' field.
    return 0; // Assuming ProductModel has a 'price' field
  }
}
