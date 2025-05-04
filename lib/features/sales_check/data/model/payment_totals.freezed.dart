// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_totals.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentTotals {
  double get cash;
  double get check;
  double get bankTransfer;

  /// Create a copy of PaymentTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaymentTotalsCopyWith<PaymentTotals> get copyWith =>
      _$PaymentTotalsCopyWithImpl<PaymentTotals>(
          this as PaymentTotals, _$identity);

  /// Serializes this PaymentTotals to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaymentTotals &&
            (identical(other.cash, cash) || other.cash == cash) &&
            (identical(other.check, check) || other.check == check) &&
            (identical(other.bankTransfer, bankTransfer) ||
                other.bankTransfer == bankTransfer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cash, check, bankTransfer);

  @override
  String toString() {
    return 'PaymentTotals(cash: $cash, check: $check, bankTransfer: $bankTransfer)';
  }
}

/// @nodoc
abstract mixin class $PaymentTotalsCopyWith<$Res> {
  factory $PaymentTotalsCopyWith(
          PaymentTotals value, $Res Function(PaymentTotals) _then) =
      _$PaymentTotalsCopyWithImpl;
  @useResult
  $Res call({double cash, double check, double bankTransfer});
}

/// @nodoc
class _$PaymentTotalsCopyWithImpl<$Res>
    implements $PaymentTotalsCopyWith<$Res> {
  _$PaymentTotalsCopyWithImpl(this._self, this._then);

  final PaymentTotals _self;
  final $Res Function(PaymentTotals) _then;

  /// Create a copy of PaymentTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cash = null,
    Object? check = null,
    Object? bankTransfer = null,
  }) {
    return _then(_self.copyWith(
      cash: null == cash
          ? _self.cash
          : cash // ignore: cast_nullable_to_non_nullable
              as double,
      check: null == check
          ? _self.check
          : check // ignore: cast_nullable_to_non_nullable
              as double,
      bankTransfer: null == bankTransfer
          ? _self.bankTransfer
          : bankTransfer // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PaymentTotals implements PaymentTotals {
  const _PaymentTotals(
      {required this.cash, required this.check, required this.bankTransfer});
  factory _PaymentTotals.fromJson(Map<String, dynamic> json) =>
      _$PaymentTotalsFromJson(json);

  @override
  final double cash;
  @override
  final double check;
  @override
  final double bankTransfer;

  /// Create a copy of PaymentTotals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PaymentTotalsCopyWith<_PaymentTotals> get copyWith =>
      __$PaymentTotalsCopyWithImpl<_PaymentTotals>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PaymentTotalsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PaymentTotals &&
            (identical(other.cash, cash) || other.cash == cash) &&
            (identical(other.check, check) || other.check == check) &&
            (identical(other.bankTransfer, bankTransfer) ||
                other.bankTransfer == bankTransfer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cash, check, bankTransfer);

  @override
  String toString() {
    return 'PaymentTotals(cash: $cash, check: $check, bankTransfer: $bankTransfer)';
  }
}

/// @nodoc
abstract mixin class _$PaymentTotalsCopyWith<$Res>
    implements $PaymentTotalsCopyWith<$Res> {
  factory _$PaymentTotalsCopyWith(
          _PaymentTotals value, $Res Function(_PaymentTotals) _then) =
      __$PaymentTotalsCopyWithImpl;
  @override
  @useResult
  $Res call({double cash, double check, double bankTransfer});
}

/// @nodoc
class __$PaymentTotalsCopyWithImpl<$Res>
    implements _$PaymentTotalsCopyWith<$Res> {
  __$PaymentTotalsCopyWithImpl(this._self, this._then);

  final _PaymentTotals _self;
  final $Res Function(_PaymentTotals) _then;

  /// Create a copy of PaymentTotals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cash = null,
    Object? check = null,
    Object? bankTransfer = null,
  }) {
    return _then(_PaymentTotals(
      cash: null == cash
          ? _self.cash
          : cash // ignore: cast_nullable_to_non_nullable
              as double,
      check: null == check
          ? _self.check
          : check // ignore: cast_nullable_to_non_nullable
              as double,
      bankTransfer: null == bankTransfer
          ? _self.bankTransfer
          : bankTransfer // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
