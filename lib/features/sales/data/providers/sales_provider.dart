import 'package:falsisters_pos_android/features/sales/data/model/sales_state.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final salesProvider = AsyncNotifierProvider<SalesNotifier, SalesState>(() {
  return SalesNotifier();
});
