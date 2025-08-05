import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'grouped_profit_item.freezed.dart';
part 'grouped_profit_item.g.dart';

@freezed
sealed class GroupedProfitItem with _$GroupedProfitItem {
  const factory GroupedProfitItem({
    required String productName,
    @DecimalConverter() required Decimal profitPerUnit,
    @DecimalConverter() required Decimal totalQuantity,
    @DecimalConverter() required Decimal totalProfit,
    required int orders,
    required String formattedSummary,
  }) = _GroupedProfitItem;

  factory GroupedProfitItem.fromJson(Map<String, dynamic> json) =>
      _$GroupedProfitItemFromJson(json);
}
