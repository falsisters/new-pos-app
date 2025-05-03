import 'package:falsisters_pos_android/features/attachments/data/models/attachment_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment_state.freezed.dart';
part 'attachment_state.g.dart';

@freezed
sealed class AttachmentState with _$AttachmentState {
  const factory AttachmentState({
    required List<AttachmentModel> attachments,
    String? error,
  }) = _AttachmentState;

  factory AttachmentState.fromJson(Map<String, dynamic> json) =>
      _$AttachmentStateFromJson(json);
}
