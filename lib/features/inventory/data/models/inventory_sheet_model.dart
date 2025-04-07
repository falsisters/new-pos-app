// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/inventory/data/models/inventory_row_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_sheet_model.freezed.dart';
part 'inventory_sheet_model.g.dart';

@freezed
sealed class InventorySheetModel with _$InventorySheetModel {
  const factory InventorySheetModel({
    required String id,
    required String name,
    required String inventoryId,
    required int columns,
    required DateTime createdAt,
    required DateTime updatedAt,
    @JsonKey(name: 'Rows') @Default([]) List<InventoryRowModel> rows,
  }) = _InventorySheetModel;

  factory InventorySheetModel.fromJson(Map<String, dynamic> json) =>
      _$InventorySheetModelFromJson(json);
}
