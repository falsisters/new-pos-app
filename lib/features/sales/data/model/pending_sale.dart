import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pending_sale.freezed.dart';
part 'pending_sale.g.dart';

@freezed
sealed class PendingSale with _$PendingSale {
  const factory PendingSale({
    required String id,
    required CreateSaleRequestModel saleRequest,
    required DateTime timestamp,
    @Default(false) bool isProcessing,
    String? error,
  }) = _PendingSale;

  factory PendingSale.fromJson(Map<String, dynamic> json) =>
      _$PendingSaleFromJson(json);
}
