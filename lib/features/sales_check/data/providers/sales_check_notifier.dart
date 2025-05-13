import 'package:falsisters_pos_android/features/sales_check/data/model/grouped_sales_check_item.dart'; // Updated import
import 'package:falsisters_pos_android/features/sales_check/data/model/sales_check_filter_dto.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/sales_check_state.dart';
import 'package:falsisters_pos_android/features/sales_check/data/model/total_sales_check.dart'; // Updated import
import 'package:falsisters_pos_android/features/sales_check/data/model/total_sales_filter_dto.dart';
import 'package:falsisters_pos_android/features/sales_check/data/repository/sales_check_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For default date

class SalesCheckNotifier extends AsyncNotifier<SalesCheckState> {
  final SalesCheckRepository _repository = SalesCheckRepository();

  @override
  Future<SalesCheckState> build() async {
    // Initial fetch with default filters (e.g., today's date)
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final initialGroupedFilters = SalesCheckFilterDto(
        date: today, isDiscounted: null); // isDiscounted defaults to null
    final initialTotalFilters = TotalSalesFilterDto(
        date: today, isDiscounted: null); // isDiscounted defaults to null
    return _fetchData(initialGroupedFilters, initialTotalFilters);
  }

  Future<SalesCheckState> _fetchData(SalesCheckFilterDto groupedFilters,
      TotalSalesFilterDto totalFilters) async {
    try {
      // Fetch both sets of data concurrently
      final results = await Future.wait([
        _repository.getGroupedSales(groupedFilters),
        _repository.getTotalSales(totalFilters),
      ]);

      final groupedSales =
          results[0] as List<GroupedSalesCheckItem>; // Use updated class name
      final totalSales =
          results[1] as TotalSalesCheck; // Use updated class name

      return SalesCheckState(
        groupedSalesFilters: groupedFilters,
        totalSalesFilters: totalFilters,
        groupedSales: groupedSales,
        totalSales: totalSales,
        isLoading: false,
      );
    } catch (e) {
      // Return the error state, preserving existing filters if possible
      final currentState = state.value ?? const SalesCheckState();
      return currentState.copyWith(
        error: e.toString(),
        isLoading: false,
        // Clear data on error? Or keep stale data? Decide based on UX preference.
        // groupedSales: null,
        // totalSales: null,
      );
    }
  }

  // Method to update filters and trigger a refetch
  Future<void> updateFiltersAndRefetch({
    SalesCheckFilterDto? groupedFilters,
    TotalSalesFilterDto? totalFilters,
    // No need to add isDiscounted directly here, as it's part of the DTOs
  }) async {
    state = const AsyncValue.loading(); // Indicate loading

    // Use existing filters if new ones aren't provided
    // The DTOs passed will now potentially include the isDiscounted field
    final currentGroupedFilters = groupedFilters ??
        state.value?.groupedSalesFilters ??
        SalesCheckFilterDto(
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            isDiscounted: null);
    final currentTotalFilters = totalFilters ??
        state.value?.totalSalesFilters ??
        TotalSalesFilterDto(
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            isDiscounted: null);

    // Use AsyncValue.guard to handle potential errors during fetch
    state = await AsyncValue.guard(() async {
      return _fetchData(currentGroupedFilters, currentTotalFilters);
    });
  }

  // Optional: Separate refresh method to refetch with current filters
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final currentGroupedFilters = state.value?.groupedSalesFilters ??
        SalesCheckFilterDto(
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            isDiscounted: null);
    final currentTotalFilters = state.value?.totalSalesFilters ??
        TotalSalesFilterDto(
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            isDiscounted: null);
    state = await AsyncValue.guard(() async {
      return _fetchData(currentGroupedFilters, currentTotalFilters);
    });
  }
}
