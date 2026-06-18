import 'package:drift/drift.dart';
import 'package:falsisters_pos_android/core/database/converters/date_time_converter.dart';

class LocalKahons extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get cashierId => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  BoolColumn get needsRefresh =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalSheets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get kahonId => text()();
  IntColumn get columns => integer()();
  IntColumn get createdAt =>
      integer().map(const EpochMillisConverter())();
  IntColumn get updatedAt =>
      integer().map(const EpochMillisConverter())();
  BoolColumn get needsRefresh =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalRows extends Table {
  TextColumn get id => text()();
  IntColumn get rowIndex => integer()();
  TextColumn get sheetId =>
      text().references(LocalSheets, #id)();
  BoolColumn get isItemRow => boolean()();
  TextColumn get itemId => text().nullable()();
  IntColumn get createdAt =>
      integer().map(const EpochMillisConverter())();
  IntColumn get updatedAt =>
      integer().map(const EpochMillisConverter())();
  BoolColumn get synced =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalCells extends Table {
  TextColumn get id => text()();
  IntColumn get columnIndex => integer()();
  TextColumn get rowId =>
      text().references(LocalRows, #id)();
  TextColumn get color => text().nullable()();
  TextColumn get kahonItemId => text().nullable()();
  TextColumn get value => text().nullable()();
  TextColumn get formula => text().nullable()();
  BoolColumn get isCalculated => boolean()();
  IntColumn get createdAt =>
      integer().map(const EpochMillisConverter())();
  IntColumn get updatedAt =>
      integer().map(const EpochMillisConverter())();
  BoolColumn get synced =>
      boolean().withDefault(const Constant(false))();
  IntColumn get localUpdatedAt =>
      integer().map(const EpochMillisConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalKahonItems extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get quantity => real()();
  TextColumn get kahonId => text()();
  IntColumn get createdAt =>
      integer().map(const EpochMillisConverter())();
  IntColumn get updatedAt =>
      integer().map(const EpochMillisConverter())();
  BoolColumn get needsRefresh =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
