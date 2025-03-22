import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:falsisters_pos_android/features/auth/data/model/cashier_jwt_model.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    CashierJwtModel? cashier,
    @Default(false) bool isAuthenticated,
    String? error,
    @Default(false) bool isLoading,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}
