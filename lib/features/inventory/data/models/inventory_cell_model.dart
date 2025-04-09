import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_cell_model.freezed.dart';
part 'inventory_cell_model.g.dart';

@freezed
sealed class InventoryCellModel with _$InventoryCellModel {
  const factory InventoryCellModel({
    required String id,
    required int columnIndex,
    required String inventoryRowId,
    String? color, // Add color field as a hex string
    String? value,
    String? formula,
    required bool isCalculated,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _InventoryCellModel;

  factory InventoryCellModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryCellModelFromJson(json);
}
