// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthState _$AuthStateFromJson(Map<String, dynamic> json) => _AuthState(
      cashier: json['cashier'] == null
          ? null
          : CashierJwtModel.fromJson(json['cashier'] as Map<String, dynamic>),
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      error: json['error'] as String?,
      isLoading: json['isLoading'] as bool? ?? false,
    );

Map<String, dynamic> _$AuthStateToJson(_AuthState instance) =>
    <String, dynamic>{
      'cashier': instance.cashier,
      'isAuthenticated': instance.isAuthenticated,
      'error': instance.error,
      'isLoading': instance.isLoading,
    };
