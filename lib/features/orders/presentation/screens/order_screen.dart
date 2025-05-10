import 'package:falsisters_pos_android/features/orders/data/providers/order_provider.dart';
import 'package:falsisters_pos_android/features/orders/presentation/widgets/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: orderState.when(
        data: (data) => RefreshIndicator(
            onRefresh: () => ref.read(orderProvider.notifier).refreshOrders(),
            child: OrderList(orders: data.orders)),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () =>
                    ref.read(orderProvider.notifier).refreshOrders(),
                child: const Text('Retry'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
