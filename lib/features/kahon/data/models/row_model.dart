// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/kahon/data/models/cell_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'row_model.freezed.dart';
part 'row_model.g.dart';

@freezed
sealed class RowModel with _$RowModel {
  const factory RowModel({
    required String id,
    required int rowIndex,
    required String sheetId,
    required bool isItemRow,
    String? itemId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @JsonKey(name: 'Cells') @Default([]) List<CellModel> cells,
  }) = _RowModel;

  factory RowModel.fromJson(Map<String, dynamic> json) =>
      _$RowModelFromJson(json);
}
