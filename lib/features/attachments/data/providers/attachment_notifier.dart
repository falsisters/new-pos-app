import 'package:falsisters_pos_android/features/attachments/data/models/attachment_state.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/attachment_type_enum.dart';
import 'package:falsisters_pos_android/features/attachments/data/repository/attachment_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentNotifier extends AsyncNotifier<AttachmentState> {
  final AttachmentRepository _attachmentRepository = AttachmentRepository();

  @override
  Future<AttachmentState> build() async {
    final attachments = await _attachmentRepository.getAttachments();

    return AttachmentState(attachments: attachments);
  }

  Future<AttachmentState> getAttachments() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final attachments = await _attachmentRepository.getAttachments();
        return AttachmentState(attachments: attachments);
      } catch (e) {
        return AttachmentState(
          attachments: [],
          error: e.toString(),
        );
      }
    });

    return state.value!;
  }

  Future<void> createAttachment(
      XFile file, String name, AttachmentType type) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _attachmentRepository.createAttachment(file, name, type);
        final attachments = await _attachmentRepository.getAttachments();
        return AttachmentState(attachments: attachments);
      } catch (e) {
        return AttachmentState(
          attachments: [],
          error: e.toString(),
        );
      }
    });
  }

  Future<void> editAttachment(
      String id, String? name, AttachmentType? type) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _attachmentRepository.editAttachment(id, name, type);
        final attachments = await _attachmentRepository.getAttachments();
        return AttachmentState(attachments: attachments);
      } catch (e) {
        return AttachmentState(
          attachments: [],
          error: e.toString(),
        );
      }
    });
  }

  Future<void> deleteAttachment(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _attachmentRepository.deleteAttachment(id);
        final attachments = await _attachmentRepository.getAttachments();
        return AttachmentState(attachments: attachments);
      } catch (e) {
        return AttachmentState(
          attachments: [],
          error: e.toString(),
        );
      }
    });
  }
}
