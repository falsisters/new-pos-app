import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expenses_state.freezed.dart';
part 'expenses_state.g.dart';

@freezed
sealed class ExpensesState with _$ExpensesState {
  const factory ExpensesState({
    InventorySheetModel? sheet,
    String? error,
  }) = _ExpensesState;

  factory ExpensesState.fromJson(Map<String, dynamic> json) =>
      _$ExpensesStateFromJson(json);
}
