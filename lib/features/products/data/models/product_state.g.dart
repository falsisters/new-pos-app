// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductState _$ProductStateFromJson(Map<String, dynamic> json) =>
    _ProductState(
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ProductStateToJson(_ProductState instance) =>
    <String, dynamic>{
      'products': instance.products,
      'isLoading': instance.isLoading,
      'error': instance.error,
    };
