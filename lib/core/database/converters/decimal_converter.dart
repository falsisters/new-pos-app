import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

class DecimalConverter extends TypeConverter<Decimal, double> {
  const DecimalConverter();

  @override
  Decimal fromSql(double fromDb) => Decimal.parse(fromDb.toString());

  @override
  double toSql(Decimal value) => value.toDouble();
}

class NullableDecimalConverter extends TypeConverter<Decimal?, double?> {
  const NullableDecimalConverter();

  @override
  Decimal? fromSql(double? fromDb) =>
      fromDb != null ? Decimal.parse(fromDb.toString()) : null;

  @override
  double? toSql(Decimal? value) => value?.toDouble();
}
