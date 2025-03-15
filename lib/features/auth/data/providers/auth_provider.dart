// Provider for the auth notifier
import 'package:falsisters_pos_android/features/auth/data/model/auth_state.dart';
import 'package:falsisters_pos_android/features/auth/data/model/cashier_jwt_model.dart';
import 'package:falsisters_pos_android/features/auth/data/providers/auth_notifier.dart';
import 'package:riverpod/riverpod.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref
          .watch(authProvider)
          .whenData((state) => state.isAuthenticated)
          .value ??
      false;
});

final cashierProvider = Provider<CashierJwtModel?>((ref) {
  return ref.watch(authProvider).whenData((state) => state.cashier).value;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).whenData((state) => state.error).value;
});
