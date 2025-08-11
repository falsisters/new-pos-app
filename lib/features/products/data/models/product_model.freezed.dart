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
mixin _$Cashier {
  String get name;
  String get userId;

  /// Create a copy of Cashier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CashierCopyWith<Cashier> get copyWith =>
      _$CashierCopyWithImpl<Cashier>(this as Cashier, _$identity);

  /// Serializes this Cashier to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Cashier &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, userId);

  @override
  String toString() {
    return 'Cashier(name: $name, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $CashierCopyWith<$Res> {
  factory $CashierCopyWith(Cashier value, $Res Function(Cashier) _then) =
      _$CashierCopyWithImpl;
  @useResult
  $Res call({String name, String userId});
}

/// @nodoc
class _$CashierCopyWithImpl<$Res> implements $CashierCopyWith<$Res> {
  _$CashierCopyWithImpl(this._self, this._then);

  final Cashier _self;
  final $Res Function(Cashier) _then;

  /// Create a copy of Cashier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? userId = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Cashier implements Cashier {
  const _Cashier({required this.name, required this.userId});
  factory _Cashier.fromJson(Map<String, dynamic> json) =>
      _$CashierFromJson(json);

  @override
  final String name;
  @override
  final String userId;

  /// Create a copy of Cashier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CashierCopyWith<_Cashier> get copyWith =>
      __$CashierCopyWithImpl<_Cashier>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CashierToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Cashier &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, userId);

  @override
  String toString() {
    return 'Cashier(name: $name, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class _$CashierCopyWith<$Res> implements $CashierCopyWith<$Res> {
  factory _$CashierCopyWith(_Cashier value, $Res Function(_Cashier) _then) =
      __$CashierCopyWithImpl;
  @override
  @useResult
  $Res call({String name, String userId});
}

/// @nodoc
class __$CashierCopyWithImpl<$Res> implements _$CashierCopyWith<$Res> {
  __$CashierCopyWithImpl(this._self, this._then);

  final _Cashier _self;
  final $Res Function(_Cashier) _then;

  /// Create a copy of Cashier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? userId = null,
  }) {
    return _then(_Cashier(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$Product {
  String get id;
  String get name;
  String get picture;
  DateTime get createdAt;
  DateTime get updatedAt;
  String get userId;
  @JsonKey(name: "SackPrice")
  List<SackPrice> get sackPrice;
  PerKiloPrice? get perKiloPrice;
  Cashier? get cashier;
  String? get cashierId;

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
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.cashier, cashier) || other.cashier == cashier) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId));
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
      perKiloPrice,
      cashier,
      cashierId);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, picture: $picture, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, sackPrice: $sackPrice, perKiloPrice: $perKiloPrice, cashier: $cashier, cashierId: $cashierId)';
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
      @JsonKey(name: "SackPrice") List<SackPrice> sackPrice,
      PerKiloPrice? perKiloPrice,
      Cashier? cashier,
      String? cashierId});

  $PerKiloPriceCopyWith<$Res>? get perKiloPrice;
  $CashierCopyWith<$Res>? get cashier;
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
    Object? cashier = freezed,
    Object? cashierId = freezed,
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
      cashier: freezed == cashier
          ? _self.cashier
          : cashier // ignore: cast_nullable_to_non_nullable
              as Cashier?,
      cashierId: freezed == cashierId
          ? _self.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String?,
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

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CashierCopyWith<$Res>? get cashier {
    if (_self.cashier == null) {
      return null;
    }

    return $CashierCopyWith<$Res>(_self.cashier!, (value) {
      return _then(_self.copyWith(cashier: value));
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
      @JsonKey(name: "SackPrice") required final List<SackPrice> sackPrice,
      this.perKiloPrice,
      this.cashier,
      this.cashierId})
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
  @JsonKey(name: "SackPrice")
  List<SackPrice> get sackPrice {
    if (_sackPrice is EqualUnmodifiableListView) return _sackPrice;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sackPrice);
  }

  @override
  final PerKiloPrice? perKiloPrice;
  @override
  final Cashier? cashier;
  @override
  final String? cashierId;

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
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.cashier, cashier) || other.cashier == cashier) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId));
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
      perKiloPrice,
      cashier,
      cashierId);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, picture: $picture, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, sackPrice: $sackPrice, perKiloPrice: $perKiloPrice, cashier: $cashier, cashierId: $cashierId)';
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
      @JsonKey(name: "SackPrice") List<SackPrice> sackPrice,
      PerKiloPrice? perKiloPrice,
      Cashier? cashier,
      String? cashierId});

  @override
  $PerKiloPriceCopyWith<$Res>? get perKiloPrice;
  @override
  $CashierCopyWith<$Res>? get cashier;
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
    Object? cashier = freezed,
    Object? cashierId = freezed,
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
      cashier: freezed == cashier
          ? _self.cashier
          : cashier // ignore: cast_nullable_to_non_nullable
              as Cashier?,
      cashierId: freezed == cashierId
          ? _self.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String?,
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

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CashierCopyWith<$Res>? get cashier {
    if (_self.cashier == null) {
      return null;
    }

    return $CashierCopyWith<$Res>(_self.cashier!, (value) {
      return _then(_self.copyWith(cashier: value));
    });
  }
}

// dart format on
