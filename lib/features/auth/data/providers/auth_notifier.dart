import 'package:falsisters_pos_android/core/handlers/secure_storage.dart';
import 'package:falsisters_pos_android/features/auth/data/model/auth_state.dart';
import 'package:falsisters_pos_android/features/auth/data/model/cashier_jwt_model.dart';
import 'package:falsisters_pos_android/features/auth/data/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  final AuthRepository _authRepository = AuthRepository();
  final SecureStorage _secureStorage = SecureStorage();

  @override
  Future<AuthState> build() async {
    return AuthState();
  }

  Future<void> login(String name, String accessKey) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        await _authRepository.login(name, accessKey);
        final cashierData = await _authRepository.getCashierInfo();

        // Parse the cashier data
        final cashier = CashierJwtModel.fromJson(cashierData);

        return AuthState(
          cashier: cashier,
          isAuthenticated: true,
        );
      } catch (e) {
        return AuthState(
          error: e.toString(),
          isAuthenticated: false,
        );
      }
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    await _secureStorage.deleteToken();
    state = AsyncValue.data(AuthState());
  }

  Future<void> getCashierInfo() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final cashierData = await _authRepository.getCashierInfo();
        final cashier = CashierJwtModel.fromJson(cashierData);

        return AuthState(
          cashier: cashier,
          isAuthenticated: true,
        );
      } catch (e) {
        return AuthState(
          error: e.toString(),
          isAuthenticated: false,
        );
      }
    });
  }

  Future<void> refreshCashierInfo() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final cashierData = await _authRepository.getCashierInfo();
        final cashier = CashierJwtModel.fromJson(cashierData);

        return state.value!.copyWith(
          cashier: cashier,
        );
      } catch (e) {
        return state.value!.copyWith(
          error: e.toString(),
        );
      }
    });
  }
}
