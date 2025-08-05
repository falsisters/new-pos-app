import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart'; // For PaymentMethod
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profit_item.freezed.dart';
part 'profit_item.g.dart';

@freezed
sealed class ProfitItem with _$ProfitItem {
  const factory ProfitItem({
    required String id,
    required String productId,
    required String productName,
    @DecimalConverter() required Decimal quantity,
    @DecimalConverter() required Decimal profitPerUnit,
    @DecimalConverter() required Decimal totalProfit,
    required String priceType,
    required String formattedPriceType,
    required PaymentMethod paymentMethod,
    required bool isSpecialPrice,
    required DateTime saleDate,
    required bool isAsin,
  }) = _ProfitItem;

  factory ProfitItem.fromJson(Map<String, dynamic> json) =>
      _$ProfitItemFromJson(json);
}
