// ignore_for_file: invalid_annotation_target

import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart'; // Reusing PaymentMethod enum
import 'package:falsisters_pos_android/features/sales_check/data/model/sale_item_check.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_check.freezed.dart';
part 'sales_check.g.dart';

@freezed
sealed class SalesCheck with _$SalesCheck {
  const factory SalesCheck({
    required String id,
    required String cashierId,
    @DecimalConverter() required Decimal totalAmount,
    required PaymentMethod paymentMethod,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? orderId, // Added to align with Sale schema's optional link to Order
    @JsonKey(name: 'SaleItem') // Match Prisma relation name if needed
    required List<SaleItemCheck> saleItems,
  }) = _SalesCheck;

  factory SalesCheck.fromJson(Map<String, dynamic> json) =>
      _$SalesCheckFromJson(json);
}
