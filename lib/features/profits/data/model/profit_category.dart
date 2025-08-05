import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:falsisters_pos_android/features/profits/data/model/grouped_profit_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profit_category.freezed.dart';
part 'profit_category.g.dart';

@freezed
sealed class ProfitCategory with _$ProfitCategory {
  const factory ProfitCategory({
    required List<GroupedProfitItem> items,
    @DecimalConverter() required Decimal totalProfit,
  }) = _ProfitCategory;

  factory ProfitCategory.fromJson(Map<String, dynamic> json) =>
      _$ProfitCategoryFromJson(json);
}
