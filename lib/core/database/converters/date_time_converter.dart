import 'package:drift/drift.dart';

class EpochMillisConverter extends TypeConverter<DateTime, int> {
  const EpochMillisConverter();

  @override
  DateTime fromSql(int fromDb) =>
      DateTime.fromMillisecondsSinceEpoch(fromDb);

  @override
  int toSql(DateTime value) => value.millisecondsSinceEpoch;
}

class NullableEpochMillisConverter extends TypeConverter<DateTime?, int?> {
  const NullableEpochMillisConverter();

  @override
  DateTime? fromSql(int? fromDb) =>
      fromDb != null ? DateTime.fromMillisecondsSinceEpoch(fromDb) : null;

  @override
  int? toSql(DateTime? value) => value?.millisecondsSinceEpoch;
}
