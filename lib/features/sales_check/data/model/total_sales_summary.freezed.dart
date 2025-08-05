// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'total_sales_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TotalSalesSummary {
  @DecimalConverter()
  Decimal get totalQuantity;
  @DecimalConverter()
  set totalQuantity(Decimal value);
  @DecimalConverter()
  Decimal get totalAmount;
  @DecimalConverter()
  set totalAmount(
      Decimal
          value); // Use JsonKey to handle the nested structure during serialization/deserialization
  @JsonKey(name: 'paymentTotals')
  PaymentTotals
      get summaryPaymentTotals; // Use JsonKey to handle the nested structure during serialization/deserialization
  @JsonKey(name: 'paymentTotals')
  set summaryPaymentTotals(PaymentTotals value);

  /// Create a copy of TotalSalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TotalSalesSummaryCopyWith<TotalSalesSummary> get copyWith =>
      _$TotalSalesSummaryCopyWithImpl<TotalSalesSummary>(
          this as TotalSalesSummary, _$identity);

  /// Serializes this TotalSalesSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'TotalSalesSummary(totalQuantity: $totalQuantity, totalAmount: $totalAmount, summaryPaymentTotals: $summaryPaymentTotals)';
  }
}

/// @nodoc
abstract mixin class $TotalSalesSummaryCopyWith<$Res> {
  factory $TotalSalesSummaryCopyWith(
          TotalSalesSummary value, $Res Function(TotalSalesSummary) _then) =
      _$TotalSalesSummaryCopyWithImpl;
  @useResult
  $Res call(
      {@DecimalConverter() Decimal totalQuantity,
      @DecimalConverter() Decimal totalAmount,
      @JsonKey(name: 'paymentTotals') PaymentTotals summaryPaymentTotals});

  $PaymentTotalsCopyWith<$Res> get summaryPaymentTotals;
}

/// @nodoc
class _$TotalSalesSummaryCopyWithImpl<$Res>
    implements $TotalSalesSummaryCopyWith<$Res> {
  _$TotalSalesSummaryCopyWithImpl(this._self, this._then);

  final TotalSalesSummary _self;
  final $Res Function(TotalSalesSummary) _then;

  /// Create a copy of TotalSalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuantity = null,
    Object? totalAmount = null,
    Object? summaryPaymentTotals = null,
  }) {
    return _then(_self.copyWith(
      totalQuantity: null == totalQuantity
          ? _self.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      summaryPaymentTotals: null == summaryPaymentTotals
          ? _self.summaryPaymentTotals
          : summaryPaymentTotals // ignore: cast_nullable_to_non_nullable
              as PaymentTotals,
    ));
  }

  /// Create a copy of TotalSalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentTotalsCopyWith<$Res> get summaryPaymentTotals {
    return $PaymentTotalsCopyWith<$Res>(_self.summaryPaymentTotals, (value) {
      return _then(_self.copyWith(summaryPaymentTotals: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TotalSalesSummary implements TotalSalesSummary {
  _TotalSalesSummary(
      {@DecimalConverter() required this.totalQuantity,
      @DecimalConverter() required this.totalAmount,
      @JsonKey(name: 'paymentTotals') required this.summaryPaymentTotals});
  factory _TotalSalesSummary.fromJson(Map<String, dynamic> json) =>
      _$TotalSalesSummaryFromJson(json);

  @override
  @DecimalConverter()
  Decimal totalQuantity;
  @override
  @DecimalConverter()
  Decimal totalAmount;
// Use JsonKey to handle the nested structure during serialization/deserialization
  @override
  @JsonKey(name: 'paymentTotals')
  PaymentTotals summaryPaymentTotals;

  /// Create a copy of TotalSalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TotalSalesSummaryCopyWith<_TotalSalesSummary> get copyWith =>
      __$TotalSalesSummaryCopyWithImpl<_TotalSalesSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TotalSalesSummaryToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'TotalSalesSummary(totalQuantity: $totalQuantity, totalAmount: $totalAmount, summaryPaymentTotals: $summaryPaymentTotals)';
  }
}

/// @nodoc
abstract mixin class _$TotalSalesSummaryCopyWith<$Res>
    implements $TotalSalesSummaryCopyWith<$Res> {
  factory _$TotalSalesSummaryCopyWith(
          _TotalSalesSummary value, $Res Function(_TotalSalesSummary) _then) =
      __$TotalSalesSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@DecimalConverter() Decimal totalQuantity,
      @DecimalConverter() Decimal totalAmount,
      @JsonKey(name: 'paymentTotals') PaymentTotals summaryPaymentTotals});

  @override
  $PaymentTotalsCopyWith<$Res> get summaryPaymentTotals;
}

/// @nodoc
class __$TotalSalesSummaryCopyWithImpl<$Res>
    implements _$TotalSalesSummaryCopyWith<$Res> {
  __$TotalSalesSummaryCopyWithImpl(this._self, this._then);

  final _TotalSalesSummary _self;
  final $Res Function(_TotalSalesSummary) _then;

  /// Create a copy of TotalSalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalQuantity = null,
    Object? totalAmount = null,
    Object? summaryPaymentTotals = null,
  }) {
    return _then(_TotalSalesSummary(
      totalQuantity: null == totalQuantity
          ? _self.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      summaryPaymentTotals: null == summaryPaymentTotals
          ? _self.summaryPaymentTotals
          : summaryPaymentTotals // ignore: cast_nullable_to_non_nullable
              as PaymentTotals,
    ));
  }

  /// Create a copy of TotalSalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentTotalsCopyWith<$Res> get summaryPaymentTotals {
    return $PaymentTotalsCopyWith<$Res>(_self.summaryPaymentTotals, (value) {
      return _then(_self.copyWith(summaryPaymentTotals: value));
    });
  }
}

// dart format on
