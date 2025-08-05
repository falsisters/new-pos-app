// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'per_kilo_price_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PerKiloPrice {
  String get id;
  @DecimalConverter()
  Decimal get price;
  @DecimalConverter()
  Decimal get stock;
  String get productId;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of PerKiloPrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PerKiloPriceCopyWith<PerKiloPrice> get copyWith =>
      _$PerKiloPriceCopyWithImpl<PerKiloPrice>(
          this as PerKiloPrice, _$identity);

  /// Serializes this PerKiloPrice to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PerKiloPrice &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, price, stock, productId, createdAt, updatedAt);

  @override
  String toString() {
    return 'PerKiloPrice(id: $id, price: $price, stock: $stock, productId: $productId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $PerKiloPriceCopyWith<$Res> {
  factory $PerKiloPriceCopyWith(
          PerKiloPrice value, $Res Function(PerKiloPrice) _then) =
      _$PerKiloPriceCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @DecimalConverter() Decimal price,
      @DecimalConverter() Decimal stock,
      String productId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$PerKiloPriceCopyWithImpl<$Res> implements $PerKiloPriceCopyWith<$Res> {
  _$PerKiloPriceCopyWithImpl(this._self, this._then);

  final PerKiloPrice _self;
  final $Res Function(PerKiloPrice) _then;

  /// Create a copy of PerKiloPrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? stock = null,
    Object? productId = null,
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
              as Decimal,
      stock: null == stock
          ? _self.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as Decimal,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
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
class _PerKiloPrice implements PerKiloPrice {
  const _PerKiloPrice(
      {required this.id,
      @DecimalConverter() required this.price,
      @DecimalConverter() required this.stock,
      required this.productId,
      required this.createdAt,
      required this.updatedAt});
  factory _PerKiloPrice.fromJson(Map<String, dynamic> json) =>
      _$PerKiloPriceFromJson(json);

  @override
  final String id;
  @override
  @DecimalConverter()
  final Decimal price;
  @override
  @DecimalConverter()
  final Decimal stock;
  @override
  final String productId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of PerKiloPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PerKiloPriceCopyWith<_PerKiloPrice> get copyWith =>
      __$PerKiloPriceCopyWithImpl<_PerKiloPrice>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PerKiloPriceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PerKiloPrice &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, price, stock, productId, createdAt, updatedAt);

  @override
  String toString() {
    return 'PerKiloPrice(id: $id, price: $price, stock: $stock, productId: $productId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$PerKiloPriceCopyWith<$Res>
    implements $PerKiloPriceCopyWith<$Res> {
  factory _$PerKiloPriceCopyWith(
          _PerKiloPrice value, $Res Function(_PerKiloPrice) _then) =
      __$PerKiloPriceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @DecimalConverter() Decimal price,
      @DecimalConverter() Decimal stock,
      String productId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$PerKiloPriceCopyWithImpl<$Res>
    implements _$PerKiloPriceCopyWith<$Res> {
  __$PerKiloPriceCopyWithImpl(this._self, this._then);

  final _PerKiloPrice _self;
  final $Res Function(_PerKiloPrice) _then;

  /// Create a copy of PerKiloPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? stock = null,
    Object? productId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_PerKiloPrice(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal,
      stock: null == stock
          ? _self.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as Decimal,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
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
