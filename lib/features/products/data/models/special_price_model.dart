// model SpecialPrice {
//   id          String    @id @default(cuid())
//   price       Float
//   minimumQty  Int
//   sackPrice   SackPrice @relation(fields: [sackPriceId], references: [id], onDelete: Cascade)
//   sackPriceId String    @unique
//   createdAt   DateTime  @default(now())
//   updatedAt   DateTime  @updatedAt
// }

import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'special_price_model.freezed.dart';
part 'special_price_model.g.dart';

@freezed
sealed class SpecialPrice with _$SpecialPrice {
  const factory SpecialPrice({
    required String id,
    @DecimalConverter() required Decimal price,
    @NullableDecimalConverter() Decimal? profit,
    required int minimumQty,
    required String sackPriceId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SpecialPrice;

  factory SpecialPrice.fromJson(Map<String, dynamic> json) =>
      _$SpecialPriceFromJson(json);
}
