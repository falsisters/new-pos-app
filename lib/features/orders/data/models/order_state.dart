import 'package:falsisters_pos_android/features/orders/data/models/order_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_state.freezed.dart';
part 'order_state.g.dart';

@freezed
sealed class OrderState with _$OrderState {
  const factory OrderState({
    required List<OrderModel> orders,
    OrderModel? selectedOrder,
    @Default(false) bool isLoading,
    String? error,
  }) = _OrderState;

  factory OrderState.fromJson(Map<String, dynamic> json) =>
      _$OrderStateFromJson(json);
}
