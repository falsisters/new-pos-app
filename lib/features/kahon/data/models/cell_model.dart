import 'package:freezed_annotation/freezed_annotation.dart';

part 'cell_model.freezed.dart';
part 'cell_model.g.dart';

@freezed
sealed class CellModel with _$CellModel {
  const factory CellModel({
    required String id,
    required int columnIndex,
    required String rowId,
    String? color,
    String? kahonItemId,
    String? value,
    String? formula,
    required bool isCalculated,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CellModel;

  factory CellModel.fromJson(Map<String, dynamic> json) =>
      _$CellModelFromJson(json);
}
