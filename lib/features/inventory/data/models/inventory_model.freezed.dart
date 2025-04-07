// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryModel {
  String get id;
  String get name;
  String get cashierId;
  DateTime get createdAt;
  DateTime get updatedAt;
  @JsonKey(name: 'Sheets')
  List<InventorySheetModel> get sheets;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InventoryModelCopyWith<InventoryModel> get copyWith =>
      _$InventoryModelCopyWithImpl<InventoryModel>(
          this as InventoryModel, _$identity);

  /// Serializes this InventoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InventoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.sheets, sheets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, cashierId, createdAt,
      updatedAt, const DeepCollectionEquality().hash(sheets));

  @override
  String toString() {
    return 'InventoryModel(id: $id, name: $name, cashierId: $cashierId, createdAt: $createdAt, updatedAt: $updatedAt, sheets: $sheets)';
  }
}

/// @nodoc
abstract mixin class $InventoryModelCopyWith<$Res> {
  factory $InventoryModelCopyWith(
          InventoryModel value, $Res Function(InventoryModel) _then) =
      _$InventoryModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String cashierId,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Sheets') List<InventorySheetModel> sheets});
}

/// @nodoc
class _$InventoryModelCopyWithImpl<$Res>
    implements $InventoryModelCopyWith<$Res> {
  _$InventoryModelCopyWithImpl(this._self, this._then);

  final InventoryModel _self;
  final $Res Function(InventoryModel) _then;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cashierId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sheets = null,
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
      cashierId: null == cashierId
          ? _self.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sheets: null == sheets
          ? _self.sheets
          : sheets // ignore: cast_nullable_to_non_nullable
              as List<InventorySheetModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _InventoryModel implements InventoryModel {
  const _InventoryModel(
      {required this.id,
      required this.name,
      required this.cashierId,
      required this.createdAt,
      required this.updatedAt,
      @JsonKey(name: 'Sheets')
      final List<InventorySheetModel> sheets = const []})
      : _sheets = sheets;
  factory _InventoryModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String cashierId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<InventorySheetModel> _sheets;
  @override
  @JsonKey(name: 'Sheets')
  List<InventorySheetModel> get sheets {
    if (_sheets is EqualUnmodifiableListView) return _sheets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sheets);
  }

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InventoryModelCopyWith<_InventoryModel> get copyWith =>
      __$InventoryModelCopyWithImpl<_InventoryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InventoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InventoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._sheets, _sheets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, cashierId, createdAt,
      updatedAt, const DeepCollectionEquality().hash(_sheets));

  @override
  String toString() {
    return 'InventoryModel(id: $id, name: $name, cashierId: $cashierId, createdAt: $createdAt, updatedAt: $updatedAt, sheets: $sheets)';
  }
}

/// @nodoc
abstract mixin class _$InventoryModelCopyWith<$Res>
    implements $InventoryModelCopyWith<$Res> {
  factory _$InventoryModelCopyWith(
          _InventoryModel value, $Res Function(_InventoryModel) _then) =
      __$InventoryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String cashierId,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Sheets') List<InventorySheetModel> sheets});
}

/// @nodoc
class __$InventoryModelCopyWithImpl<$Res>
    implements _$InventoryModelCopyWith<$Res> {
  __$InventoryModelCopyWithImpl(this._self, this._then);

  final _InventoryModel _self;
  final $Res Function(_InventoryModel) _then;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cashierId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sheets = null,
  }) {
    return _then(_InventoryModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      cashierId: null == cashierId
          ? _self.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sheets: null == sheets
          ? _self._sheets
          : sheets // ignore: cast_nullable_to_non_nullable
              as List<InventorySheetModel>,
    ));
  }
}

// dart format on
