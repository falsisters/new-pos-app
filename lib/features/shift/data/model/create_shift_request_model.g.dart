// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_shift_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateShiftRequestModel _$CreateShiftRequestModelFromJson(
        Map<String, dynamic> json) =>
    _CreateShiftRequestModel(
      employees:
          (json['employees'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CreateShiftRequestModelToJson(
        _CreateShiftRequestModel instance) =>
    <String, dynamic>{
      'employees': instance.employees,
    };
