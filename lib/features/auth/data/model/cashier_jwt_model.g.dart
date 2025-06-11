// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_jwt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CashierJwtModel _$CashierJwtModelFromJson(Map<String, dynamic> json) =>
    _CashierJwtModel(
      id: json['id'] as String,
      name: json['name'] as String,
      userId: json['userId'] as String,
      secureCode: json['secureCode'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CashierJwtModelToJson(_CashierJwtModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userId': instance.userId,
      'secureCode': instance.secureCode,
      'permissions': instance.permissions,
    };
