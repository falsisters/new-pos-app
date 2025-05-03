// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttachmentState _$AttachmentStateFromJson(Map<String, dynamic> json) =>
    _AttachmentState(
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$AttachmentStateToJson(_AttachmentState instance) =>
    <String, dynamic>{
      'attachments': instance.attachments,
      'error': instance.error,
    };
