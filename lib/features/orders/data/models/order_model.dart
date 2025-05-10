// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/orders/data/models/customer_model.dart';
import 'package:falsisters_pos_android/features/orders/data/models/order_item_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

enum OrderStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled
}

@freezed
sealed class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required double totalPrice,
    required String userId,
    required CustomerModel customer,
    required String customerId,
    @JsonKey(defaultValue: OrderStatus.pending) required OrderStatus status,
    String? saleId,
    @JsonKey(name: 'OrderItem') @Default([]) List<OrderItemModel> orderItems,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
