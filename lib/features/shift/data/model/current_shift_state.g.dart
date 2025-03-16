// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_shift_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CurrentShiftState _$CurrentShiftStateFromJson(Map<String, dynamic> json) =>
    _CurrentShiftState(
      shift: json['shift'] == null
          ? null
          : ShiftModel.fromJson(json['shift'] as Map<String, dynamic>),
      isShiftActive: json['isShiftActive'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$CurrentShiftStateToJson(_CurrentShiftState instance) =>
    <String, dynamic>{
      'shift': instance.shift,
      'isShiftActive': instance.isShiftActive,
      'error': instance.error,
    };
