// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_model.freezed.dart';
part 'sale_model.g.dart';

@freezed
sealed class SaleModel with _$SaleModel {
  const factory SaleModel({
    required String id,
    required String cashierId,
    required double totalAmount,
    required PaymentMethod paymentMethod,
    @Default([]) @JsonKey(name: 'SaleItem') List<SaleItem> saleItems,
    required String createdAt,
    required String updatedAt,
  }) = _SaleModel;

  factory SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);
}
