import 'package:falsisters_pos_android/features/orders/data/models/order_model.dart';
import 'package:falsisters_pos_android/features/orders/presentation/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderList extends StatelessWidget {
  final List<OrderModel> orders;

  const OrderList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text('No orders found.'),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text('Customer: ${order.customer.name}'),
            subtitle: Text(
                'Created: ${DateFormat.yMd().add_jm().format(order.createdAt)}\nPrice: PHP ${order.totalPrice.toStringAsFixed(2)}'),
            isThreeLine: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsScreen(orderId: order.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
