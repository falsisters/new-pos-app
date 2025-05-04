// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_count_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillCountState _$BillCountStateFromJson(Map<String, dynamic> json) =>
    _BillCountState(
      billCount: json['billCount'] == null
          ? null
          : BillCountModel.fromJson(json['billCount'] as Map<String, dynamic>),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$BillCountStateToJson(_BillCountState instance) =>
    <String, dynamic>{
      'billCount': instance.billCount,
      'error': instance.error,
    };
