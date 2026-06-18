import 'package:drift/drift.dart';
import 'package:falsisters_pos_android/core/database/converters/date_time_converter.dart';

class LocalProducts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get picture => text()();
  TextColumn get userId => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  BoolColumn get needsRefresh =>
      boolean().withDefault(const Constant(false))();
  IntColumn get localUpdatedAt =>
      integer().map(const EpochMillisConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalSackPrices extends Table {
  TextColumn get id => text()();
  TextColumn get productId =>
      text().references(LocalProducts, #id)();
  RealColumn get price => real()();
  RealColumn get stock => real()();
  RealColumn get profit => real().nullable()();
  TextColumn get type => text()();
  BoolColumn get hasSpecialPrice =>
      boolean().withDefault(const Constant(false))();
  RealColumn get specialPricePrice => real().nullable()();
  IntColumn get specialPriceMinimumQty => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalPerKiloPrices extends Table {
  TextColumn get id => text()();
  TextColumn get productId =>
      text().references(LocalProducts, #id)();
  RealColumn get price => real()();
  RealColumn get stock => real()();
  RealColumn get profit => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
