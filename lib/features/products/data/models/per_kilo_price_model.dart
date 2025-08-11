// model PerKiloPrice {
//   id        String   @id @default(cuid())
//   price     Float
//   stock     Float
//   product   Product  @relation(fields: [productId], references: [id], onDelete: Cascade)
//   productId String   @unique
//   createdAt DateTime @default(now())
//   updatedAt DateTime @updatedAt
// }

import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'per_kilo_price_model.freezed.dart';
part 'per_kilo_price_model.g.dart';

@freezed
sealed class PerKiloPrice with _$PerKiloPrice {
  const factory PerKiloPrice({
    required String id,
    @DecimalConverter() required Decimal price,
    @DecimalConverter() required Decimal stock,
    @NullableDecimalConverter() Decimal? profit,
    required String productId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PerKiloPrice;

  factory PerKiloPrice.fromJson(Map<String, dynamic> json) =>
      _$PerKiloPriceFromJson(json);
}
