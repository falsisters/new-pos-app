import 'package:falsisters_pos_android/features/stocks/data/models/transfer_state.dart';
import 'package:falsisters_pos_android/features/stocks/data/repository/stock_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferNotifier extends AsyncNotifier<TransferState> {
  final StockRepository _transferRepository = StockRepository();

  @override
  Future<TransferState> build() async {
    try {
      final today = DateTime.now();
      final transferLists = await _transferRepository.getTransfers(date: today);
      return TransferState(
        transferList: transferLists,
        selectedDate: today,
      );
    } catch (e) {
      return TransferState(
        transferList: [],
        error: e.toString(),
        selectedDate: DateTime.now(),
      );
    }
  }

  Future<TransferState> getTransferList({DateTime? date}) async {
    state = const AsyncLoading();
    final targetDate = date ?? state.value?.selectedDate ?? DateTime.now();

    state = await AsyncValue.guard(() async {
      try {
        final transferLists =
            await _transferRepository.getTransfers(date: targetDate);

        return TransferState(
          transferList: transferLists,
          selectedDate: targetDate,
        );
      } catch (e) {
        return TransferState(
          transferList: [],
          error: e.toString(),
          selectedDate: targetDate,
        );
      }
    });

    return state.value!;
  }

  Future<void> changeSelectedDate(DateTime newDate) async {
    await getTransferList(date: newDate);
  }
}
