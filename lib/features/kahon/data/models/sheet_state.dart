import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sheet_state.freezed.dart';
part 'sheet_state.g.dart';

@freezed
sealed class SheetState with _$SheetState {
  const factory SheetState({
    SheetModel? sheet,
    String? error,
  }) = _SheetState;

  factory SheetState.fromJson(Map<String, dynamic> json) =>
      _$SheetStateFromJson(json);
}
