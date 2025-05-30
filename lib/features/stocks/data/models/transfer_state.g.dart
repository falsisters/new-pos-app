// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferState _$TransferStateFromJson(Map<String, dynamic> json) =>
    _TransferState(
      transferList: (json['transferList'] as List<dynamic>?)
              ?.map((e) => TransferModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
      selectedDate: json['selectedDate'] == null
          ? null
          : DateTime.parse(json['selectedDate'] as String),
    );

Map<String, dynamic> _$TransferStateToJson(_TransferState instance) =>
    <String, dynamic>{
      'transferList': instance.transferList,
      'isLoading': instance.isLoading,
      'error': instance.error,
      'selectedDate': instance.selectedDate?.toIso8601String(),
    };
