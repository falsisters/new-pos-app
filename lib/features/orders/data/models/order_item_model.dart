// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/orders/data/models/order_product.dart';
import 'package:falsisters_pos_android/features/products/data/models/per_kilo_price_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/sack_price_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
sealed class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String id,
    required double quantity,
    required String productId,
    String? sackPriceId,
    @JsonKey(name: 'SackPrice') SackPrice? sackPrice,
    String? perKiloPriceId,
    PerKiloPrice? perKiloPrice,
    required bool isSpecialPrice,
    required String orderId,
    required OrderProduct product,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
}
