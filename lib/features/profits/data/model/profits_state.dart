import 'package:falsisters_pos_android/features/profits/data/model/profit_filter_dto.dart';
import 'package:falsisters_pos_android/features/profits/data/model/profit_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profits_state.freezed.dart';

@freezed
sealed class ProfitsState with _$ProfitsState {
  const factory ProfitsState({
    // Filter
    ProfitFilterDto? filters,

    // Result
    ProfitResponse? profitResponse,

    // Status
    String? error,
    @Default(false) bool isLoading,
  }) = _ProfitsState;
}
