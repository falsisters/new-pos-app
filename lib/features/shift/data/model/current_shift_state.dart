import 'package:falsisters_pos_android/features/shift/data/model/shift_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_shift_state.freezed.dart';
part 'current_shift_state.g.dart';

@freezed
sealed class CurrentShiftState with _$CurrentShiftState {
  const factory CurrentShiftState({
    ShiftModel? shift,
    @Default(false) bool isShiftActive,
    String? error,
  }) = _CurrentShiftState;

  factory CurrentShiftState.fromJson(Map<String, dynamic> json) =>
      _$CurrentShiftStateFromJson(json);
}
