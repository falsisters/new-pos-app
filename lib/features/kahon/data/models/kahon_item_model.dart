// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/kahon/data/models/cell_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'kahon_item_model.freezed.dart';
part 'kahon_item_model.g.dart';

@freezed
sealed class KahonItemModel with _$KahonItemModel {
  const factory KahonItemModel({
    required String id,
    required String name,
    required double quantity,
    required String kahonId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @JsonKey(name: 'Cells') @Default([]) List<CellModel> cells,
  }) = _KahonItemModel;

  factory KahonItemModel.fromJson(Map<String, dynamic> json) =>
      _$KahonItemModelFromJson(json);
}
