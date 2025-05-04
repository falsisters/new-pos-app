import 'package:falsisters_pos_android/features/sales_check/data/model/grouped_sale_detail.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/payment_totals.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'grouped_sales_check_item.freezed.dart';
part 'grouped_sales_check_item.g.dart';

@freezed
sealed class GroupedSalesCheckItem with _$GroupedSalesCheckItem {
  const factory GroupedSalesCheckItem({
    required String productName, // e.g., "Rice 50KG"
    required List<GroupedSaleDetail> items,
    required double totalQuantity,
    required double totalAmount,
    required PaymentTotals paymentTotals,
  }) = _GroupedSalesCheckItem;

  factory GroupedSalesCheckItem.fromJson(Map<String, dynamic> json) =>
      _$GroupedSalesCheckItemFromJson(json);
}
