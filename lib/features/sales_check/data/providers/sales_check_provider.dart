import 'package:falsisters_pos_android/features/sales_check/data/model/sales_check_state.dart';
import 'package:falsisters_pos_android/features/sales_check/data/providers/sales_check_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final salesCheckProvider =
    AsyncNotifierProvider<SalesCheckNotifier, SalesCheckState>(() {
  return SalesCheckNotifier();
});
