// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderProduct {
  String get id;
  String get name;
  String get picture;
  String get userId;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of OrderProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderProductCopyWith<OrderProduct> get copyWith =>
      _$OrderProductCopyWithImpl<OrderProduct>(
          this as OrderProduct, _$identity);

  /// Serializes this OrderProduct to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderProduct &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.picture, picture) || other.picture == picture) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, picture, userId, createdAt, updatedAt);

  @override
  String toString() {
    return 'OrderProduct(id: $id, name: $name, picture: $picture, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $OrderProductCopyWith<$Res> {
  factory $OrderProductCopyWith(
          OrderProduct value, $Res Function(OrderProduct) _then) =
      _$OrderProductCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String picture,
      String userId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$OrderProductCopyWithImpl<$Res> implements $OrderProductCopyWith<$Res> {
  _$OrderProductCopyWithImpl(this._self, this._then);

  final OrderProduct _self;
  final $Res Function(OrderProduct) _then;

  /// Create a copy of OrderProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? picture = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
class _OrderProduct implements OrderProduct {
  const _OrderProduct(
      {required this.id,
      required this.name,
      required this.picture,
      required this.userId,
      required this.createdAt,
      required this.updatedAt});
  factory _OrderProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderProductFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String picture;
  @override
  final String userId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of OrderProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderProductCopyWith<_OrderProduct> get copyWith =>
      __$OrderProductCopyWithImpl<_OrderProduct>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderProductToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderProduct &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.picture, picture) || other.picture == picture) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, picture, userId, createdAt, updatedAt);

  @override
  String toString() {
    return 'OrderProduct(id: $id, name: $name, picture: $picture, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$OrderProductCopyWith<$Res>
    implements $OrderProductCopyWith<$Res> {
  factory _$OrderProductCopyWith(
          _OrderProduct value, $Res Function(_OrderProduct) _then) =
      __$OrderProductCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String picture,
      String userId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$OrderProductCopyWithImpl<$Res>
    implements _$OrderProductCopyWith<$Res> {
  __$OrderProductCopyWithImpl(this._self, this._then);

  final _OrderProduct _self;
  final $Res Function(_OrderProduct) _then;

  /// Create a copy of OrderProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? picture = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_OrderProduct(
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
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
