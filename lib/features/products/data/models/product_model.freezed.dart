// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {
  String get id;
  String get name;
  String get picture;
  DateTime get createdAt;
  DateTime get updatedAt;
  String get userId;
  List<SackPrice> get sackPrice;
  PerKiloPrice? get perKiloPrice;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductCopyWith<Product> get copyWith =>
      _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Product &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.picture, picture) || other.picture == picture) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other.sackPrice, sackPrice) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      picture,
      createdAt,
      updatedAt,
      userId,
      const DeepCollectionEquality().hash(sackPrice),
      perKiloPrice);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, picture: $picture, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, sackPrice: $sackPrice, perKiloPrice: $perKiloPrice)';
  }
}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) =
      _$ProductCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String picture,
      DateTime createdAt,
      DateTime updatedAt,
      String userId,
      List<SackPrice> sackPrice,
      PerKiloPrice? perKiloPrice});

  $PerKiloPriceCopyWith<$Res>? get perKiloPrice;
}

/// @nodoc
class _$ProductCopyWithImpl<$Res> implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? picture = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = null,
    Object? sackPrice = null,
    Object? perKiloPrice = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      picture: null == picture
          ? _self.picture
          : picture // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sackPrice: null == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as List<SackPrice>,
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as PerKiloPrice?,
    ));
  }

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PerKiloPriceCopyWith<$Res>? get perKiloPrice {
    if (_self.perKiloPrice == null) {
      return null;
    }

    return $PerKiloPriceCopyWith<$Res>(_self.perKiloPrice!, (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Product implements Product {
  const _Product(
      {required this.id,
      required this.name,
      required this.picture,
      required this.createdAt,
      required this.updatedAt,
      required this.userId,
      required final List<SackPrice> sackPrice,
      this.perKiloPrice})
      : _sackPrice = sackPrice;
  factory _Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String picture;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String userId;
  final List<SackPrice> _sackPrice;
  @override
  List<SackPrice> get sackPrice {
    if (_sackPrice is EqualUnmodifiableListView) return _sackPrice;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sackPrice);
  }

  @override
  final PerKiloPrice? perKiloPrice;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductCopyWith<_Product> get copyWith =>
      __$ProductCopyWithImpl<_Product>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Product &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.picture, picture) || other.picture == picture) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._sackPrice, _sackPrice) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      picture,
      createdAt,
      updatedAt,
      userId,
      const DeepCollectionEquality().hash(_sackPrice),
      perKiloPrice);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, picture: $picture, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, sackPrice: $sackPrice, perKiloPrice: $perKiloPrice)';
  }
}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) =
      __$ProductCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String picture,
      DateTime createdAt,
      DateTime updatedAt,
      String userId,
      List<SackPrice> sackPrice,
      PerKiloPrice? perKiloPrice});

  @override
  $PerKiloPriceCopyWith<$Res>? get perKiloPrice;
}

/// @nodoc
class __$ProductCopyWithImpl<$Res> implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? picture = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = null,
    Object? sackPrice = null,
    Object? perKiloPrice = freezed,
  }) {
    return _then(_Product(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      picture: null == picture
          ? _self.picture
          : picture // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sackPrice: null == sackPrice
          ? _self._sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as List<SackPrice>,
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as PerKiloPrice?,
    ));
  }

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PerKiloPriceCopyWith<$Res>? get perKiloPrice {
    if (_self.perKiloPrice == null) {
      return null;
    }

    return $PerKiloPriceCopyWith<$Res>(_self.perKiloPrice!, (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }
}

// dart format on
