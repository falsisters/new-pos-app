// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalesState _$SalesStateFromJson(Map<String, dynamic> json) => _SalesState(
      cart: CartModel.fromJson(json['cart'] as Map<String, dynamic>),
      sales: (json['sales'] as List<dynamic>)
          .map((e) => SaleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderId: json['orderId'] as String?,
      error: json['error'] as String?,
      selectedDate: json['selectedDate'] == null
          ? null
          : DateTime.parse(json['selectedDate'] as String),
    );

Map<String, dynamic> _$SalesStateToJson(_SalesState instance) =>
    <String, dynamic>{
      'cart': instance.cart,
      'sales': instance.sales,
      'orderId': instance.orderId,
      'error': instance.error,
      'selectedDate': instance.selectedDate?.toIso8601String(),
    };
