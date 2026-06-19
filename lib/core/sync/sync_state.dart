import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncState {
  final int pendingCount;
  final DateTime? lastSyncAt;
  final bool isSyncing;
  final String? lastError;

  const SyncState({
    this.pendingCount = 0,
    this.lastSyncAt,
    this.isSyncing = false,
    this.lastError,
  });

  SyncState copyWith({
    int? pendingCount,
    DateTime? lastSyncAt,
    bool? isSyncing,
    String? lastError,
  }) {
    return SyncState(
      pendingCount: pendingCount ?? this.pendingCount,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      isSyncing: isSyncing ?? this.isSyncing,
      lastError: lastError,
    );
  }
}

class SyncStateNotifier extends StateNotifier<SyncState> {
  SyncStateNotifier() : super(const SyncState());

  void setPendingCount(int count) {
    state = state.copyWith(pendingCount: count);
  }

  void setSyncing(bool syncing) {
    state = state.copyWith(isSyncing: syncing);
  }

  void setSynced() {
    state = state.copyWith(
      isSyncing: false,
      lastSyncAt: DateTime.now(),
      lastError: null,
    );
  }

  void setError(String error) {
    state = state.copyWith(isSyncing: false, lastError: error);
  }
}

final syncStateProvider =
    StateNotifierProvider<SyncStateNotifier, SyncState>(
  (ref) => SyncStateNotifier(),
);

final pendingSyncCountProvider = Provider<int>((ref) {
  return ref.watch(syncStateProvider).pendingCount;
});

final isSyncingProvider = Provider<bool>((ref) {
  return ref.watch(syncStateProvider).isSyncing;
});
