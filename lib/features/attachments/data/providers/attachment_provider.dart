import 'package:falsisters_pos_android/features/attachments/data/models/attachment_state.dart';
import 'package:falsisters_pos_android/features/attachments/data/providers/attachment_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attachmentProvider =
    AsyncNotifierProvider<AttachmentNotifier, AttachmentState>(
  () => AttachmentNotifier(),
);
