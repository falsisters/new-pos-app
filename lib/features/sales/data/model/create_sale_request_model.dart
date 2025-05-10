// ignore_for_file: invalid_annotation_target, constant_identifier_names

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
    required double totalAmount,
    required PaymentMethod paymentMethod,
    @JsonKey(name: 'saleItem') required List<ProductDto> saleItems,
  }) = _CreateSaleRequestModel;

  factory CreateSaleRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateSaleRequestModelFromJson(json);
}
