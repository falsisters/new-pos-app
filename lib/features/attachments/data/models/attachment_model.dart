import 'package:falsisters_pos_android/features/attachments/data/models/attachment_type_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment_model.freezed.dart';
part 'attachment_model.g.dart';

@freezed
sealed class AttachmentModel with _$AttachmentModel {
  const factory AttachmentModel({
    required String id,
    required String name,
    required String url,
    required AttachmentType type,
  }) = _AttachmentModel;

  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$AttachmentModelFromJson(json);
}
