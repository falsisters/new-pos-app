import 'package:falsisters_pos_android/features/profits/data/model/profits_state.dart';
import 'package:falsisters_pos_android/features/profits/data/providers/profits_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the profits state notifier
final profitsStateNotifierProvider =
    AsyncNotifierProvider<ProfitsNotifier, ProfitsState>(() {
  return ProfitsNotifier();
});

// Convenience providers for accessing specific parts of the state
final profitsSacksProvider = Provider<dynamic>((ref) {
  final profitsState = ref.watch(profitsStateNotifierProvider);
  return profitsState.value?.profitResponse?.sacks;
});

final profitsAsinProvider = Provider<dynamic>((ref) {
  final profitsState = ref.watch(profitsStateNotifierProvider);
  return profitsState.value?.profitResponse?.asin;
});

final profitsOverallTotalProvider = Provider<double?>((ref) {
  final profitsState = ref.watch(profitsStateNotifierProvider);
  return profitsState.value?.profitResponse?.overallTotal;
});

final profitsErrorProvider = Provider<String?>((ref) {
  final profitsState = ref.watch(profitsStateNotifierProvider);
  return profitsState.value?.error;
});

final profitsIsLoadingProvider = Provider<bool>((ref) {
  final profitsState = ref.watch(profitsStateNotifierProvider);
  return profitsState.isLoading;
});
