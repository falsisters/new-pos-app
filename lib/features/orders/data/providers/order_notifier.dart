import 'package:falsisters_pos_android/features/orders/data/models/order_state.dart';
import 'package:falsisters_pos_android/features/orders/data/repository/order_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderNotifier extends AsyncNotifier<OrderState> {
  final OrderRepository _orderRepository = OrderRepository();

  @override
  Future<OrderState> build() async {
    try {
      final orders = await _orderRepository.getOrders();
      return OrderState(
        orders: orders,
      );
    } catch (e) {
      if (kDebugMode) {
        print('OrderNotifier.build: Error loading orders: $e');
      }
      // Return empty order state rather than throwing during build, let UI handle
      return const OrderState(
        orders: [],
        error: 'Failed to load orders. Please try refreshing.',
      );
    }
  }

  Future<void> rejectOrder(String orderId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final order = await _orderRepository.rejectOrder(orderId);
        if (kDebugMode) {
          print('OrderNotifier.rejectOrder: Order rejected: $order');
        }
        return OrderState(
          orders: state.value?.orders ?? [],
          selectedOrder: null,
          error: null,
        );
      } catch (e) {
        return OrderState(
          orders: state.value?.orders ?? [],
          selectedOrder: null,
          error: e.toString(),
        );
      }
    });
  }

  // Renamed from getOrders for clarity when used as a refresh/retry action
  Future<void> refreshOrders() async {
    if (kDebugMode) {
      print('OrderNotifier.refreshOrders: Starting refresh');
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final orders = await _orderRepository.getOrders();

        if (kDebugMode) {
          print(
              'OrderNotifier.refreshOrders: Refreshed ${orders.length} orders');
        }

        // When refreshing the list, clear any previously selected order and error.
        return OrderState(orders: orders, selectedOrder: null, error: null);
      } catch (e) {
        if (kDebugMode) {
          print('OrderNotifier.refreshOrders: Error: $e');
        }
        return OrderState(orders: [], error: e.toString());
      }
    });
  }

  Future<void> getOrderById(String orderId) async {
    // Preserve the current list of orders while loading details for one order.
    final previousStateValue = state.value;

    // Set state to loading, but keep previous data if available
    if (previousStateValue != null) {
      state = AsyncLoading<OrderState>()
          .copyWithPrevious(AsyncData(previousStateValue));
    } else {
      state = const AsyncLoading<OrderState>();
    }

    try {
      final order = await _orderRepository.getOrderById(orderId);
      // If successful, update the state with the new selected order,
      // keeping the existing list of orders.
      state = AsyncData(
        (previousStateValue ?? const OrderState(orders: [])).copyWith(
          selectedOrder: order,
          isLoading: false, // Explicitly set isLoading to false
          error: null, // Clear any previous error
        ),
      );
    } catch (e, s) {
      // If an error occurs, update the state to reflect the error,
      // but still keep the existing list of orders.
      state =
          AsyncError(e, s).copyWithPrevious(state) as AsyncValue<OrderState>;
      // Optionally, update the OrderState within AsyncData to hold the error message
      // while still showing old data if that's desired for your UI.
      // For now, AsyncError is standard.
      // If you want to show the old list + an error message for the detail view:
      // state = AsyncData(
      //   (previousStateValue ?? const OrderState(orders: [])).copyWith(
      //     selectedOrder: null,
      //     isLoading: false,
      //     error: e.toString(),
      //   ),
      // );
    }
  }
}
