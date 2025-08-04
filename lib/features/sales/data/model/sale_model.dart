// ignore_for_file: invalid_annotation_target

import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
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
    @DecimalConverter() required Decimal totalAmount,
    required PaymentMethod paymentMethod,
    @Default([]) @JsonKey(name: 'SaleItem') List<SaleItem> saleItems,
    required String createdAt,
    required String updatedAt,
    Map<String, dynamic>? metadata,
  }) = _SaleModel;

  factory SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);
}
