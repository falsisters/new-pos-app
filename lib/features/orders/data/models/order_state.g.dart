// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderState _$OrderStateFromJson(Map<String, dynamic> json) => _OrderState(
      orders: (json['orders'] as List<dynamic>)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedOrder: json['selectedOrder'] == null
          ? null
          : OrderModel.fromJson(json['selectedOrder'] as Map<String, dynamic>),
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$OrderStateToJson(_OrderState instance) =>
    <String, dynamic>{
      'orders': instance.orders,
      'selectedOrder': instance.selectedOrder,
      'isLoading': instance.isLoading,
      'error': instance.error,
    };
