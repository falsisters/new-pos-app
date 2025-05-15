import 'package:falsisters_pos_android/features/stocks/data/models/transfer_state.dart';
import 'package:falsisters_pos_android/features/stocks/data/repository/stock_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferNotifier extends AsyncNotifier<TransferState> {
  final StockRepository _transferRepository = StockRepository();

  @override
  Future<TransferState> build() async {
    try {
      final transferLists = await _transferRepository.getTransfers();
      return TransferState(
        transferList: transferLists,
      );
    } catch (e) {
      return TransferState(
        transferList: [],
        error: e.toString(),
      );
    }
  }

  Future<TransferState> getTransferList() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final transferLists = await _transferRepository.getTransfers();

        return TransferState(
          transferList: transferLists,
        );
      } catch (e) {
        return TransferState(
          transferList: [],
          error: e.toString(),
        );
      }
    });

    return state.value!;
  }
}
