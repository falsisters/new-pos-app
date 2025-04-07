// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/inventory/data/models/inventory_sheet_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_model.freezed.dart';
part 'inventory_model.g.dart';

@freezed
sealed class InventoryModel with _$InventoryModel {
  const factory InventoryModel({
    required String id,
    required String name,
    required String cashierId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @JsonKey(name: 'Sheets') @Default([]) List<InventorySheetModel> sheets,
  }) = _InventoryModel;

  factory InventoryModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryModelFromJson(json);
}
