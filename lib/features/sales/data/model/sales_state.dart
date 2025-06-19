import 'package:falsisters_pos_android/features/sales/data/model/cart_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/pending_sale.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_state.freezed.dart';
part 'sales_state.g.dart';

@freezed
sealed class SalesState with _$SalesState {
  const factory SalesState({
    required CartModel cart,
    required List<SaleModel> sales,
    @Default([]) List<PendingSale> pendingSales,
    String? orderId,
    String? error,
    DateTime? selectedDate,
  }) = _SalesState;

  factory SalesState.fromJson(Map<String, dynamic> json) =>
      _$SalesStateFromJson(json);
}
