import 'package:drift/drift.dart';
import 'package:falsisters_pos_android/core/database/converters/date_time_converter.dart';

class LocalEntities extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get data => text()();
  IntColumn get updatedAt =>
      integer().map(const EpochMillisConverter())();
  BoolColumn get needsRefresh => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id, entityType};
}
