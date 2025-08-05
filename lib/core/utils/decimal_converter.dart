import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';

class DecimalConverter implements JsonConverter<Decimal, String> {
  const DecimalConverter();

  @override
  Decimal fromJson(String json) {
    return Decimal.parse(json);
  }

  @override
  String toJson(Decimal object) {
    return object.toString();
  }
}

class NullableDecimalConverter implements JsonConverter<Decimal?, String?> {
  const NullableDecimalConverter();

  @override
  Decimal? fromJson(String? json) {
    return json != null ? Decimal.parse(json) : null;
  }

  @override
  String? toJson(Decimal? object) {
    return object?.toString();
  }
}
