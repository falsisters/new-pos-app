import 'package:falsisters_pos_android/features/bill_count/data/models/bill_count_state.dart';
import 'package:falsisters_pos_android/features/bill_count/data/providers/bill_count_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final billCountProvider =
    AsyncNotifierProvider<BillCountNotifier, BillCountState>(
  () => BillCountNotifier(),
);
