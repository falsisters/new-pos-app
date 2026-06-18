import 'package:drift/drift.dart';
import 'package:falsisters_pos_android/core/database/converters/date_time_converter.dart';

class OutboxEntries extends Table {
  TextColumn get id => text()();
  TextColumn get feature => text()();
  TextColumn get operation => text()();
  TextColumn get endpoint => text()();
  TextColumn get method => text()();
  TextColumn get entityId => text().nullable()();
  TextColumn get clientCuid => text()();
  TextColumn get payload => text()();
  TextColumn get idempotencyKey => text().unique()();
  IntColumn get createdAt =>
      integer().map(const EpochMillisConverter())();
  IntColumn get syncedAt =>
      integer().map(const NullableEpochMillisConverter()).nullable()();
  IntColumn get syncAttempts => integer().withDefault(const Constant(0))();
  TextColumn get status =>
      text().withDefault(const Constant('pending'))();
  TextColumn get error => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
