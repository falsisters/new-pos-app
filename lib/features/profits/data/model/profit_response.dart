// ignore_for_file: invalid_annotation_target

import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/utils/decimal_converter.dart';
import 'package:falsisters_pos_android/features/profits/data/model/profit_category.dart';
import 'package:falsisters_pos_android/features/profits/data/model/profit_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profit_response.freezed.dart';
part 'profit_response.g.dart';

@freezed
sealed class ProfitResponse with _$ProfitResponse {
  const factory ProfitResponse({
    required ProfitCategory sacks,
    required ProfitCategory asin,
    @DecimalConverter() required Decimal overallTotal,
    @JsonKey(name: 'rawItems') required List<ProfitItem> items,
  }) = _ProfitResponse;

  factory ProfitResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfitResponseFromJson(json);
}
