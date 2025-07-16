import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart'; // For PaymentMethod
import 'package:falsisters_pos_android/features/sales_check/data/model/product_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'total_sale_item.freezed.dart';
part 'total_sale_item.g.dart';

@freezed
sealed class TotalSaleItem with _$TotalSaleItem {
  const factory TotalSaleItem({
    required String id,
    required String saleId,
    required double quantity,
    required ProductInfo product,
    required String priceType, // e.g., "KG", "50KG"
    required double unitPrice,
    required double totalAmount,
    required PaymentMethod paymentMethod,
    required bool isSpecialPrice,
    required bool isDiscounted, // Add this field
    double? discountedPrice, // Add this field for discounted unit price
    required DateTime saleDate,
    required String formattedTime, // e.g., "14:30"
    required String
        formattedSale, // e.g., "1 Rice 50KG = 2500 (CHECK) (special price)"
  }) = _TotalSaleItem;

  factory TotalSaleItem.fromJson(Map<String, dynamic> json) =>
      _$TotalSaleItemFromJson(json);
}
