import 'package:flutter_riverpod/flutter_riverpod.dart';

final dialogStateProvider =
    StateNotifierProvider<DialogStateNotifier, bool>((ref) {
  return DialogStateNotifier();
});

// State notifier to control the dialog visibility
class DialogStateNotifier extends StateNotifier<bool> {
  DialogStateNotifier() : super(false);

  void showDialog() => state = true;
  void hideDialog() => state = false;
}
