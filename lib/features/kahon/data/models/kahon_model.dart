// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/kahon/data/models/kahon_item_model.dart';
import 'package:falsisters_pos_android/features/kahon/data/models/sheet_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'kahon_model.freezed.dart';
part 'kahon_model.g.dart';

@freezed
sealed class KahonModel with _$KahonModel {
  const factory KahonModel({
    required String id,
    required String name,
    required String cashierId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @JsonKey(name: 'KahonItems') @Default([]) List<KahonItemModel> kahonItems,
    @JsonKey(name: 'Sheets') @Default([]) List<SheetModel> sheets,
  }) = _KahonModel;

  factory KahonModel.fromJson(Map<String, dynamic> json) =>
      _$KahonModelFromJson(json);
}
