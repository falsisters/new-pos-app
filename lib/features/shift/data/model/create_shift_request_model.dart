import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_shift_request_model.freezed.dart';
part 'create_shift_request_model.g.dart';

@freezed
sealed class CreateShiftRequestModel with _$CreateShiftRequestModel {
  const factory CreateShiftRequestModel({
    required List<String> employees,
  }) = _CreateShiftRequestModel;

  factory CreateShiftRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateShiftRequestModelFromJson(json);
}
