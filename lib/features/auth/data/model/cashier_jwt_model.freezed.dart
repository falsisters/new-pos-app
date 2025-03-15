// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cashier_jwt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CashierJwtModel {
  String get id;
  String get name;
  String get userId;
  List<String> get permissions;

  /// Create a copy of CashierJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CashierJwtModelCopyWith<CashierJwtModel> get copyWith =>
      _$CashierJwtModelCopyWithImpl<CashierJwtModel>(
          this as CashierJwtModel, _$identity);

  /// Serializes this CashierJwtModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CashierJwtModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other.permissions, permissions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, userId,
      const DeepCollectionEquality().hash(permissions));

  @override
  String toString() {
    return 'CashierJwtModel(id: $id, name: $name, userId: $userId, permissions: $permissions)';
  }
}

/// @nodoc
abstract mixin class $CashierJwtModelCopyWith<$Res> {
  factory $CashierJwtModelCopyWith(
          CashierJwtModel value, $Res Function(CashierJwtModel) _then) =
      _$CashierJwtModelCopyWithImpl;
  @useResult
  $Res call({String id, String name, String userId, List<String> permissions});
}

/// @nodoc
class _$CashierJwtModelCopyWithImpl<$Res>
    implements $CashierJwtModelCopyWith<$Res> {
  _$CashierJwtModelCopyWithImpl(this._self, this._then);

  final CashierJwtModel _self;
  final $Res Function(CashierJwtModel) _then;

  /// Create a copy of CashierJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? userId = null,
    Object? permissions = null,
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
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _self.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CashierJwtModel implements CashierJwtModel {
  const _CashierJwtModel(
      {required this.id,
      required this.name,
      required this.userId,
      required final List<String> permissions})
      : _permissions = permissions;
  factory _CashierJwtModel.fromJson(Map<String, dynamic> json) =>
      _$CashierJwtModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String userId;
  final List<String> _permissions;
  @override
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  /// Create a copy of CashierJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CashierJwtModelCopyWith<_CashierJwtModel> get copyWith =>
      __$CashierJwtModelCopyWithImpl<_CashierJwtModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CashierJwtModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CashierJwtModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, userId,
      const DeepCollectionEquality().hash(_permissions));

  @override
  String toString() {
    return 'CashierJwtModel(id: $id, name: $name, userId: $userId, permissions: $permissions)';
  }
}

/// @nodoc
abstract mixin class _$CashierJwtModelCopyWith<$Res>
    implements $CashierJwtModelCopyWith<$Res> {
  factory _$CashierJwtModelCopyWith(
          _CashierJwtModel value, $Res Function(_CashierJwtModel) _then) =
      __$CashierJwtModelCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name, String userId, List<String> permissions});
}

/// @nodoc
class __$CashierJwtModelCopyWithImpl<$Res>
    implements _$CashierJwtModelCopyWith<$Res> {
  __$CashierJwtModelCopyWithImpl(this._self, this._then);

  final _CashierJwtModel _self;
  final $Res Function(_CashierJwtModel) _then;

  /// Create a copy of CashierJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? userId = null,
    Object? permissions = null,
  }) {
    return _then(_CashierJwtModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _self._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
