import 'package:falsisters_pos_android/features/shift/data/model/employee_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_model.freezed.dart';
part 'shift_model.g.dart';

@freezed
sealed class ShiftModel with _$ShiftModel {
  const factory ShiftModel({
    required String id,
    required List<EmployeeModel> employees,
    required DateTime startTime,
    required DateTime? endTime,
  }) = _ShiftModel;

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);
}
