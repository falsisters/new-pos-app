import 'package:falsisters_pos_android/features/stocks/data/models/transfer_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_state.freezed.dart';
part 'transfer_state.g.dart';

@freezed
sealed class TransferState with _$TransferState {
  const factory TransferState({
    @Default([]) List<TransferModel> transferList,
    @Default(false) bool isLoading,
    String? error,
    DateTime? selectedDate,
  }) = _TransferState;

  factory TransferState.fromJson(Map<String, dynamic> json) =>
      _$TransferStateFromJson(json);
}
