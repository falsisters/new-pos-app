// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'special_price_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpecialPrice {
  String get id;
  double get price;
  int get minimumQty;
  String get sackPriceId;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of SpecialPrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SpecialPriceCopyWith<SpecialPrice> get copyWith =>
      _$SpecialPriceCopyWithImpl<SpecialPrice>(
          this as SpecialPrice, _$identity);

  /// Serializes this SpecialPrice to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SpecialPrice &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.minimumQty, minimumQty) ||
                other.minimumQty == minimumQty) &&
            (identical(other.sackPriceId, sackPriceId) ||
                other.sackPriceId == sackPriceId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, price, minimumQty, sackPriceId, createdAt, updatedAt);

  @override
  String toString() {
    return 'SpecialPrice(id: $id, price: $price, minimumQty: $minimumQty, sackPriceId: $sackPriceId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $SpecialPriceCopyWith<$Res> {
  factory $SpecialPriceCopyWith(
          SpecialPrice value, $Res Function(SpecialPrice) _then) =
      _$SpecialPriceCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      double price,
      int minimumQty,
      String sackPriceId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$SpecialPriceCopyWithImpl<$Res> implements $SpecialPriceCopyWith<$Res> {
  _$SpecialPriceCopyWithImpl(this._self, this._then);

  final SpecialPrice _self;
  final $Res Function(SpecialPrice) _then;

  /// Create a copy of SpecialPrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? minimumQty = null,
    Object? sackPriceId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      minimumQty: null == minimumQty
          ? _self.minimumQty
          : minimumQty // ignore: cast_nullable_to_non_nullable
              as int,
      sackPriceId: null == sackPriceId
          ? _self.sackPriceId
          : sackPriceId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SpecialPrice implements SpecialPrice {
  const _SpecialPrice(
      {required this.id,
      required this.price,
      required this.minimumQty,
      required this.sackPriceId,
      required this.createdAt,
      required this.updatedAt});
  factory _SpecialPrice.fromJson(Map<String, dynamic> json) =>
      _$SpecialPriceFromJson(json);

  @override
  final String id;
  @override
  final double price;
  @override
  final int minimumQty;
  @override
  final String sackPriceId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of SpecialPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SpecialPriceCopyWith<_SpecialPrice> get copyWith =>
      __$SpecialPriceCopyWithImpl<_SpecialPrice>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SpecialPriceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SpecialPrice &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.minimumQty, minimumQty) ||
                other.minimumQty == minimumQty) &&
            (identical(other.sackPriceId, sackPriceId) ||
                other.sackPriceId == sackPriceId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, price, minimumQty, sackPriceId, createdAt, updatedAt);

  @override
  String toString() {
    return 'SpecialPrice(id: $id, price: $price, minimumQty: $minimumQty, sackPriceId: $sackPriceId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$SpecialPriceCopyWith<$Res>
    implements $SpecialPriceCopyWith<$Res> {
  factory _$SpecialPriceCopyWith(
          _SpecialPrice value, $Res Function(_SpecialPrice) _then) =
      __$SpecialPriceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      double price,
      int minimumQty,
      String sackPriceId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$SpecialPriceCopyWithImpl<$Res>
    implements _$SpecialPriceCopyWith<$Res> {
  __$SpecialPriceCopyWithImpl(this._self, this._then);

  final _SpecialPrice _self;
  final $Res Function(_SpecialPrice) _then;

  /// Create a copy of SpecialPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? minimumQty = null,
    Object? sackPriceId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_SpecialPrice(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      minimumQty: null == minimumQty
          ? _self.minimumQty
          : minimumQty // ignore: cast_nullable_to_non_nullable
              as int,
      sackPriceId: null == sackPriceId
          ? _self.sackPriceId
          : sackPriceId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
