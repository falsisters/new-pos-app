import 'package:falsisters_pos_android/features/sales/data/model/cart_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_state.freezed.dart';
part 'sales_state.g.dart';

@freezed
sealed class SalesState with _$SalesState {
  const factory SalesState({
    required CartModel cart,
    String? error,
  }) = _SalesState;

  factory SalesState.fromJson(Map<String, dynamic> json) =>
      _$SalesStateFromJson(json);
}
