import 'package:falsisters_pos_android/features/kahon/data/models/sheet_state.dart';
import 'package:falsisters_pos_android/features/kahon/data/providers/sheet_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sheetNotifierProvider =
    AsyncNotifierProvider<SheetNotifier, SheetState>(() => SheetNotifier());
