import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_type.dart';

part 'bill_model.freezed.dart';
part 'bill_model.g.dart';

@freezed
sealed class BillModel with _$BillModel {
  const factory BillModel({
    String? id,
    required BillType type,
    required int amount,
    int? value,
  }) = _BillModel;

  factory BillModel.fromJson(Map<String, dynamic> json) =>
      _$BillModelFromJson(json);
}
