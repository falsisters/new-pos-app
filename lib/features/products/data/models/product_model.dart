// model Product {
//   id           String         @id @default(cuid())
//   name         String
//   picture      String         @default("https://placehold.co/800x800?text=Product")
//   createdAt    DateTime       @default(now())
//   updatedAt    DateTime       @updatedAt
//   userId       String
//   user         User           @relation(fields: [userId], references: [id], onDelete: Cascade)
//   SackPrice    SackPrice[]
//   perKiloPrice PerKiloPrice?
//   DeliveryItem DeliveryItem[]
//   SaleItem     SaleItem[]
// }

// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/products/data/models/per_kilo_price_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/sack_price_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
sealed class Cashier with _$Cashier {
  const factory Cashier({
    required String name,
    required String userId,
  }) = _Cashier;

  factory Cashier.fromJson(Map<String, dynamic> json) =>
      _$CashierFromJson(json);
}

@freezed
sealed class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String picture,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
    @JsonKey(name: "SackPrice") required List<SackPrice> sackPrice,
    PerKiloPrice? perKiloPrice,
    Cashier? cashier,
    String? cashierId,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
