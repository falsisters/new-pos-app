// ignore_for_file: invalid_annotation_target, constant_identifier_names

import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_sale_request_model.freezed.dart';
part 'create_sale_request_model.g.dart';

enum PaymentMethod { CASH, CHECK, BANK_TRANSFER }

enum SackType {
  FIFTY_KG,
  TWENTY_FIVE_KG,
  FIVE_KG,
}

@freezed
sealed class CreateSaleRequestModel with _$CreateSaleRequestModel {
  const factory CreateSaleRequestModel({
    String? orderId,
    @DecimalConverter() required Decimal totalAmount,
    required PaymentMethod paymentMethod,
    @JsonKey(name: 'saleItem') required List<ProductDto> saleItems,
    @NullableDecimalConverter() Decimal? changeAmount,
    String? cashierId,
    String? cashierName,
    Map<String, dynamic>? metadata,
  }) = _CreateSaleRequestModel;

  factory CreateSaleRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateSaleRequestModelFromJson(json);
}
