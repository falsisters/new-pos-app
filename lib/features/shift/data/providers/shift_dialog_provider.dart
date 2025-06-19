import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/core/services/secure_code_service.dart';

final dialogStateProvider =
    StateNotifierProvider<DialogStateNotifier, DialogState>((ref) {
  return DialogStateNotifier();
});

// Enhanced dialog state
class DialogState {
  final bool isVisible;
  final bool isBypassed;
  final bool isEditingShift;
  final DateTime? lastUpdate;

  const DialogState({
    this.isVisible = false,
    this.isBypassed = false,
    this.isEditingShift = false,
    this.lastUpdate,
  });

  DialogState copyWith({
    bool? isVisible,
    bool? isBypassed,
    bool? isEditingShift,
    DateTime? lastUpdate,
  }) {
    return DialogState(
      isVisible: isVisible ?? this.isVisible,
      isBypassed: isBypassed ?? this.isBypassed,
      isEditingShift: isEditingShift ?? this.isEditingShift,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

// Enhanced state notifier to control the dialog visibility
class DialogStateNotifier extends StateNotifier<DialogState> {
  DialogStateNotifier() : super(const DialogState());

  void showDialog() {
    // Don't show dialog if we're editing a shift
    if (state.isEditingShift) return;

    state = state.copyWith(
      isVisible: true,
      lastUpdate: DateTime.now(),
    );
  }

  void hideDialog() {
    state = state.copyWith(
      isVisible: false,
      lastUpdate: DateTime.now(),
    );
  }

  Future<void> checkBypassStatus() async {
    final bypassed = await SecureCodeService.isBypassActive();
    state = state.copyWith(
      isBypassed: bypassed,
      lastUpdate: DateTime.now(),
    );
  }

  void setBypass() {
    state = state.copyWith(
      isBypassed: true,
      isVisible: false,
      lastUpdate: DateTime.now(),
    );
  }

  void setEditingShift(bool isEditing) {
    state = state.copyWith(
      isEditingShift: isEditing,
      isVisible: isEditing
          ? false
          : state.isVisible, // Hide dialog when editing starts
      lastUpdate: DateTime.now(),
    );
  }
}
