// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/kahon/data/models/row_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sheet_model.freezed.dart';
part 'sheet_model.g.dart';

@freezed
sealed class SheetModel with _$SheetModel {
  const factory SheetModel({
    required String id,
    required String name,
    required String kahonId,
    required int columns,
    required DateTime createdAt,
    required DateTime updatedAt,
    @JsonKey(name: 'Rows') @Default([]) List<RowModel> rows,
  }) = _SheetModel;

  factory SheetModel.fromJson(Map<String, dynamic> json) =>
      _$SheetModelFromJson(json);
}
