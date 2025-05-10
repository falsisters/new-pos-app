// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => _OrderModel(
      id: json['id'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      userId: json['userId'] as String,
      customer:
          CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
      customerId: json['customerId'] as String,
      status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
          OrderStatus.pending,
      saleId: json['saleId'] as String?,
      orderItems: (json['OrderItem'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$OrderModelToJson(_OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'totalPrice': instance.totalPrice,
      'userId': instance.userId,
      'customer': instance.customer,
      'customerId': instance.customerId,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'saleId': instance.saleId,
      'OrderItem': instance.orderItems,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'PENDING',
  OrderStatus.completed: 'COMPLETED',
  OrderStatus.cancelled: 'CANCELLED',
};
