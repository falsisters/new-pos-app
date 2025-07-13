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

final sidebarCollapseProvider =
    StateNotifierProvider<SidebarCollapseNotifier, bool>((ref) {
  return SidebarCollapseNotifier();
});

class SidebarCollapseNotifier extends StateNotifier<bool> {
  SidebarCollapseNotifier() : super(false);

  void toggle() {
    state = !state;
  }

  void setIndex(int i) {}

  void collapse() {
    state = true;
  }

  void expand() {
    state = false;
  }
}
