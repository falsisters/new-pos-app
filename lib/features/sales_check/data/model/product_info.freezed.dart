// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductInfo {
  String get id;
  String get name;

  /// Create a copy of ProductInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductInfoCopyWith<ProductInfo> get copyWith =>
      _$ProductInfoCopyWithImpl<ProductInfo>(this as ProductInfo, _$identity);

  /// Serializes this ProductInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'ProductInfo(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class $ProductInfoCopyWith<$Res> {
  factory $ProductInfoCopyWith(
          ProductInfo value, $Res Function(ProductInfo) _then) =
      _$ProductInfoCopyWithImpl;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$ProductInfoCopyWithImpl<$Res> implements $ProductInfoCopyWith<$Res> {
  _$ProductInfoCopyWithImpl(this._self, this._then);

  final ProductInfo _self;
  final $Res Function(ProductInfo) _then;

  /// Create a copy of ProductInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ProductInfo implements ProductInfo {
  const _ProductInfo({required this.id, required this.name});
  factory _ProductInfo.fromJson(Map<String, dynamic> json) =>
      _$ProductInfoFromJson(json);

  @override
  final String id;
  @override
  final String name;

  /// Create a copy of ProductInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductInfoCopyWith<_ProductInfo> get copyWith =>
      __$ProductInfoCopyWithImpl<_ProductInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'ProductInfo(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$ProductInfoCopyWith<$Res>
    implements $ProductInfoCopyWith<$Res> {
  factory _$ProductInfoCopyWith(
          _ProductInfo value, $Res Function(_ProductInfo) _then) =
      __$ProductInfoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$ProductInfoCopyWithImpl<$Res> implements _$ProductInfoCopyWith<$Res> {
  __$ProductInfoCopyWithImpl(this._self, this._then);

  final _ProductInfo _self;
  final $Res Function(_ProductInfo) _then;

  /// Create a copy of ProductInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_ProductInfo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
