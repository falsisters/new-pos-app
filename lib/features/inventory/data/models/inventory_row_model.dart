// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/inventory/data/models/inventory_cell_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_row_model.freezed.dart';
part 'inventory_row_model.g.dart';

@freezed
sealed class InventoryRowModel with _$InventoryRowModel {
  const factory InventoryRowModel({
    required String id,
    required int rowIndex,
    required String inventorySheetId,
    required bool isItemRow,
    String? itemId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @JsonKey(name: 'Cells') @Default([]) List<InventoryCellModel> cells,
  }) = _InventoryRowModel;

  factory InventoryRowModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryRowModelFromJson(json);
}
