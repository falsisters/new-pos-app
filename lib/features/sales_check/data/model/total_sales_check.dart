import 'package:falsisters_pos_android/features/sales_check/data/model/total_sale_item.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/total_sales_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'total_sales_check.freezed.dart';
part 'total_sales_check.g.dart';

@freezed
sealed class TotalSalesCheck with _$TotalSalesCheck {
  const factory TotalSalesCheck({
    required List<TotalSaleItem> items,
    required TotalSalesSummary summary,
  }) = _TotalSalesCheck;

  factory TotalSalesCheck.fromJson(Map<String, dynamic> json) =>
      _$TotalSalesCheckFromJson(json);
}
