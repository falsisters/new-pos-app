import 'package:falsisters_pos_android/features/sales_check/data/model/grouped_sales_check_item.dart'; // Updated import
import 'package:falsisters_pos_android/features/sales_check/data/model/sales_check_filter_dto.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/total_sales_check.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/total_sales_filter_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_check_state.freezed.dart';

@freezed
sealed class SalesCheckState with _$SalesCheckState {
  const factory SalesCheckState({
    // Filters
    SalesCheckFilterDto? groupedSalesFilters,
    TotalSalesFilterDto? totalSalesFilters,

    // Results
    List<GroupedSalesCheckItem>? groupedSales,
    TotalSalesCheck? totalSales,

    // Status
    String? error,
    @Default(false) bool isLoading,
  }) = _SalesCheckState;
}
