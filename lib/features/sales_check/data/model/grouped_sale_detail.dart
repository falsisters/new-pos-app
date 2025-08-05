import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'grouped_sale_detail.freezed.dart';
part 'grouped_sale_detail.g.dart';

@freezed
sealed class GroupedSaleDetail with _$GroupedSaleDetail {
  const factory GroupedSaleDetail({
    @DecimalConverter() required Decimal quantity,
    @DecimalConverter() required Decimal unitPrice,
    @DecimalConverter() required Decimal totalAmount,
    required PaymentMethod paymentMethod,
    required bool isSpecialPrice,
    required bool isDiscounted, // Add this field
    @NullableDecimalConverter()
    Decimal? discountedPrice, // Add this field for discounted unit price
    required String
        formattedSale, // e.g., "1 Rice 50KG = 2500 (CHECK) (special price)"
  }) = _GroupedSaleDetail;

  factory GroupedSaleDetail.fromJson(Map<String, dynamic> json) =>
      _$GroupedSaleDetailFromJson(json);
}
