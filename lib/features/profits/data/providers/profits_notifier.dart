import 'package:falsisters_pos_android/features/profits/data/model/profit_filter_dto.dart';
import 'package:falsisters_pos_android/features/profits/data/model/profits_state.dart';
import 'package:falsisters_pos_android/features/profits/data/repository/profits_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For default date

class ProfitsNotifier extends AsyncNotifier<ProfitsState> {
  final ProfitsRepository _repository = ProfitsRepository();

  @override
  Future<ProfitsState> build() async {
    // Initial fetch with default filters (e.g., today's date)
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final initialFilters = ProfitFilterDto(date: today);
    return _fetchData(initialFilters);
  }

  Future<ProfitsState> _fetchData(ProfitFilterDto filters) async {
    try {
      final profitResponse = await _repository.getProfits(filters);

      return ProfitsState(
        filters: filters,
        profitResponse: profitResponse,
        isLoading: false,
      );
    } catch (e) {
      // Return the error state, preserving existing filters if possible
      final currentState = state.value ?? const ProfitsState();
      return currentState.copyWith(
        error: e.toString(),
        isLoading: false,
        // Clear data on error? Or keep stale data? Decide based on UX preference.
        // profitResponse: null,
      );
    }
  }

  // Method to update filters and trigger a refetch
  Future<void> updateFiltersAndRefetch(ProfitFilterDto filters) async {
    state = const AsyncValue.loading(); // Indicate loading

    // Use AsyncValue.guard to handle potential errors during fetch
    state = await AsyncValue.guard(() async {
      return _fetchData(filters);
    });
  }

  // Optional: Separate refresh method to refetch with current filters
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final currentFilters = state.value?.filters ??
        ProfitFilterDto(date: DateFormat('yyyy-MM-dd').format(DateTime.now()));

    state = await AsyncValue.guard(() async {
      return _fetchData(currentFilters);
    });
  }
}
