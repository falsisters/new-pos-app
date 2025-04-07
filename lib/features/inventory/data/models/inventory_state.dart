import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_state.freezed.dart';
part 'inventory_state.g.dart';

@freezed
sealed class InventoryState with _$InventoryState {
  const factory InventoryState({
    InventorySheetModel? sheet,
    String? error,
  }) = _InventoryState;

  factory InventoryState.fromJson(Map<String, dynamic> json) =>
      _$InventoryStateFromJson(json);
}
