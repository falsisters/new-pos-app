// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sack_price_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SackPrice {
  String get id;
  double get price;
  int get stock;
  SackType get type;
  String get productId;
  DateTime get createdAt;
  DateTime get updatedAt;
  SpecialPrice? get specialPrice;

  /// Create a copy of SackPrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SackPriceCopyWith<SackPrice> get copyWith =>
      _$SackPriceCopyWithImpl<SackPrice>(this as SackPrice, _$identity);

  /// Serializes this SackPrice to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SackPrice &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.specialPrice, specialPrice) ||
                other.specialPrice == specialPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, price, stock, type,
      productId, createdAt, updatedAt, specialPrice);

  @override
  String toString() {
    return 'SackPrice(id: $id, price: $price, stock: $stock, type: $type, productId: $productId, createdAt: $createdAt, updatedAt: $updatedAt, specialPrice: $specialPrice)';
  }
}

/// @nodoc
abstract mixin class $SackPriceCopyWith<$Res> {
  factory $SackPriceCopyWith(SackPrice value, $Res Function(SackPrice) _then) =
      _$SackPriceCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      double price,
      int stock,
      SackType type,
      String productId,
      DateTime createdAt,
      DateTime updatedAt,
      SpecialPrice? specialPrice});

  $SpecialPriceCopyWith<$Res>? get specialPrice;
}

/// @nodoc
class _$SackPriceCopyWithImpl<$Res> implements $SackPriceCopyWith<$Res> {
  _$SackPriceCopyWithImpl(this._self, this._then);

  final SackPrice _self;
  final $Res Function(SackPrice) _then;

  /// Create a copy of SackPrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? stock = null,
    Object? type = null,
    Object? productId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? specialPrice = freezed,
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
      stock: null == stock
          ? _self.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as SackType,
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
      specialPrice: freezed == specialPrice
          ? _self.specialPrice
          : specialPrice // ignore: cast_nullable_to_non_nullable
              as SpecialPrice?,
    ));
  }

  /// Create a copy of SackPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpecialPriceCopyWith<$Res>? get specialPrice {
    if (_self.specialPrice == null) {
      return null;
    }

    return $SpecialPriceCopyWith<$Res>(_self.specialPrice!, (value) {
      return _then(_self.copyWith(specialPrice: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _SackPrice implements SackPrice {
  const _SackPrice(
      {required this.id,
      required this.price,
      required this.stock,
      required this.type,
      required this.productId,
      required this.createdAt,
      required this.updatedAt,
      this.specialPrice});
  factory _SackPrice.fromJson(Map<String, dynamic> json) =>
      _$SackPriceFromJson(json);

  @override
  final String id;
  @override
  final double price;
  @override
  final int stock;
  @override
  final SackType type;
  @override
  final String productId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final SpecialPrice? specialPrice;

  /// Create a copy of SackPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SackPriceCopyWith<_SackPrice> get copyWith =>
      __$SackPriceCopyWithImpl<_SackPrice>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SackPriceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SackPrice &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.specialPrice, specialPrice) ||
                other.specialPrice == specialPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, price, stock, type,
      productId, createdAt, updatedAt, specialPrice);

  @override
  String toString() {
    return 'SackPrice(id: $id, price: $price, stock: $stock, type: $type, productId: $productId, createdAt: $createdAt, updatedAt: $updatedAt, specialPrice: $specialPrice)';
  }
}

/// @nodoc
abstract mixin class _$SackPriceCopyWith<$Res>
    implements $SackPriceCopyWith<$Res> {
  factory _$SackPriceCopyWith(
          _SackPrice value, $Res Function(_SackPrice) _then) =
      __$SackPriceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      double price,
      int stock,
      SackType type,
      String productId,
      DateTime createdAt,
      DateTime updatedAt,
      SpecialPrice? specialPrice});

  @override
  $SpecialPriceCopyWith<$Res>? get specialPrice;
}

/// @nodoc
class __$SackPriceCopyWithImpl<$Res> implements _$SackPriceCopyWith<$Res> {
  __$SackPriceCopyWithImpl(this._self, this._then);

  final _SackPrice _self;
  final $Res Function(_SackPrice) _then;

  /// Create a copy of SackPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? stock = null,
    Object? type = null,
    Object? productId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? specialPrice = freezed,
  }) {
    return _then(_SackPrice(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      stock: null == stock
          ? _self.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as SackType,
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
      specialPrice: freezed == specialPrice
          ? _self.specialPrice
          : specialPrice // ignore: cast_nullable_to_non_nullable
              as SpecialPrice?,
    ));
  }

  /// Create a copy of SackPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpecialPriceCopyWith<$Res>? get specialPrice {
    if (_self.specialPrice == null) {
      return null;
    }

    return $SpecialPriceCopyWith<$Res>(_self.specialPrice!, (value) {
      return _then(_self.copyWith(specialPrice: value));
    });
  }
}

// dart format on
