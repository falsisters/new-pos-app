import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawerIndexProvider =
    StateNotifierProvider<DrawerIndexNotifier, int>((ref) {
  return DrawerIndexNotifier();
});

class DrawerIndexNotifier extends StateNotifier<int> {
  DrawerIndexNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}
