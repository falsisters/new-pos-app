import 'package:falsisters_pos_android/features/attachments/data/models/attachment_type_enum.dart';

class CreateAttachmentRequest {
  final String name;
  final String type;

  CreateAttachmentRequest({
    required this.name,
    required AttachmentType type,
  }) : type = _getTypeString(type);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
    };
  }

  // Convert enum to string without the enum type name prefix
  static String _getTypeString(AttachmentType type) {
    // Get the string value of the enum without the enum type name
    return type.toString().split('.').last;
  }
}
