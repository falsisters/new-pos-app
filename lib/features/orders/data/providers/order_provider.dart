import 'package:falsisters_pos_android/features/orders/data/models/order_state.dart';
import 'package:falsisters_pos_android/features/orders/data/providers/order_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderProvider = AsyncNotifierProvider<OrderNotifier, OrderState>(() {
  return OrderNotifier();
});
