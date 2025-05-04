import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_count_model.dart';

part 'bill_count_state.freezed.dart';
part 'bill_count_state.g.dart';

@freezed
sealed class BillCountState with _$BillCountState {
  const factory BillCountState({
    BillCountModel? billCount,
    String? error,
  }) = _BillCountState;

  factory BillCountState.fromJson(Map<String, dynamic> json) =>
      _$BillCountStateFromJson(json);
}
