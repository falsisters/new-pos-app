import 'package:freezed_annotation/freezed_annotation.dart';

part 'grouped_profit_item.freezed.dart';
part 'grouped_profit_item.g.dart';

@freezed
sealed class GroupedProfitItem with _$GroupedProfitItem {
  const factory GroupedProfitItem({
    required String productName,
    required double profitPerUnit,
    required double totalQuantity,
    required double totalProfit,
    required int orders,
    required String formattedSummary,
  }) = _GroupedProfitItem;

  factory GroupedProfitItem.fromJson(Map<String, dynamic> json) =>
      _$GroupedProfitItemFromJson(json);
}
