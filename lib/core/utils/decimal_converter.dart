import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
    return json == null ? null : Decimal.parse(json);
  }

  @override
  String? toJson(Decimal? object) {
    return object?.toString();
  }
}
