import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_product.freezed.dart';
part 'order_product.g.dart';

@freezed
sealed class OrderProduct with _$OrderProduct {
  const factory OrderProduct({
    required String id,
    required String name,
    required String picture,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OrderProduct;

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);
}
