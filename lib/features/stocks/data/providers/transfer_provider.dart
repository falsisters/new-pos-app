import 'package:falsisters_pos_android/features/stocks/data/models/transfer_state.dart';
import 'package:falsisters_pos_android/features/stocks/data/providers/transfer_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transferProvider =
    AsyncNotifierProvider<TransferNotifier, TransferState>(() {
  return TransferNotifier();
});
