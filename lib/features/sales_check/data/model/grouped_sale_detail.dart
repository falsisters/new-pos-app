import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart'; // For PaymentMethod
import 'package:freezed_annotation/freezed_annotation.dart';

part 'grouped_sale_detail.freezed.dart';
part 'grouped_sale_detail.g.dart';

@freezed
sealed class GroupedSaleDetail with _$GroupedSaleDetail {
  const factory GroupedSaleDetail({
    required double quantity,
    required double unitPrice,
    required double totalAmount,
    required PaymentMethod paymentMethod,
    required bool isSpecialPrice,
    required String
        formattedSale, // e.g., "1 Rice 50KG = 2500 (CHECK) (special price)"
  }) = _GroupedSaleDetail;

  factory GroupedSaleDetail.fromJson(Map<String, dynamic> json) =>
      _$GroupedSaleDetailFromJson(json);
}
