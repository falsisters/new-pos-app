// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalesState _$SalesStateFromJson(Map<String, dynamic> json) => _SalesState(
      cart: CartModel.fromJson(json['cart'] as Map<String, dynamic>),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$SalesStateToJson(_SalesState instance) =>
    <String, dynamic>{
      'cart': instance.cart,
      'error': instance.error,
    };
