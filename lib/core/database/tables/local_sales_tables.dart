import 'package:drift/drift.dart';
import 'package:falsisters_pos_android/core/database/converters/date_time_converter.dart';

class LocalSales extends Table {
  TextColumn get id => text()();
  TextColumn get cashierId => text()();
  RealColumn get totalAmount => real()();
  TextColumn get paymentMethod => text()();
  RealColumn get discount => real().nullable()();
  TextColumn get orderId => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  IntColumn get localUpdatedAt =>
      integer().map(const EpochMillisConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalSaleItems extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text().references(LocalSales, #id)();
  TextColumn get productId => text()();
  TextColumn get productName => text()();
  TextColumn get productPicture => text().withDefault(const Constant(''))();
  RealColumn get quantity => real()();
  RealColumn get price => real().nullable()();
  RealColumn get discountedPrice => real().nullable()();
  TextColumn get sackPriceId => text().nullable()();
  TextColumn get sackType => text().nullable()();
  TextColumn get perKiloPriceId => text().nullable()();
  BoolColumn get isGantang => boolean().withDefault(const Constant(false))();
  BoolColumn get isSpecialPrice =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isDiscounted =>
      boolean().withDefault(const Constant(false))();
  RealColumn get sackPricePrice => real().nullable()();
  RealColumn get perKiloPricePrice => real().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
