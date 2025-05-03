// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_cell_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryCellModel {
  String get id;
  int get columnIndex;
  String get inventoryRowId;
  String? get color; // Add color field as a hex string
  String? get value;
  String? get formula;
  bool get isCalculated;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of InventoryCellModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InventoryCellModelCopyWith<InventoryCellModel> get copyWith =>
      _$InventoryCellModelCopyWithImpl<InventoryCellModel>(
          this as InventoryCellModel, _$identity);

  /// Serializes this InventoryCellModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InventoryCellModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.columnIndex, columnIndex) ||
                other.columnIndex == columnIndex) &&
            (identical(other.inventoryRowId, inventoryRowId) ||
                other.inventoryRowId == inventoryRowId) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.formula, formula) || other.formula == formula) &&
            (identical(other.isCalculated, isCalculated) ||
                other.isCalculated == isCalculated) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, columnIndex, inventoryRowId,
      color, value, formula, isCalculated, createdAt, updatedAt);

  @override
  String toString() {
    return 'InventoryCellModel(id: $id, columnIndex: $columnIndex, inventoryRowId: $inventoryRowId, color: $color, value: $value, formula: $formula, isCalculated: $isCalculated, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $InventoryCellModelCopyWith<$Res> {
  factory $InventoryCellModelCopyWith(
          InventoryCellModel value, $Res Function(InventoryCellModel) _then) =
      _$InventoryCellModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      int columnIndex,
      String inventoryRowId,
      String? color,
      String? value,
      String? formula,
      bool isCalculated,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$InventoryCellModelCopyWithImpl<$Res>
    implements $InventoryCellModelCopyWith<$Res> {
  _$InventoryCellModelCopyWithImpl(this._self, this._then);

  final InventoryCellModel _self;
  final $Res Function(InventoryCellModel) _then;

  /// Create a copy of InventoryCellModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? columnIndex = null,
    Object? inventoryRowId = null,
    Object? color = freezed,
    Object? value = freezed,
    Object? formula = freezed,
    Object? isCalculated = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      columnIndex: null == columnIndex
          ? _self.columnIndex
          : columnIndex // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryRowId: null == inventoryRowId
          ? _self.inventoryRowId
          : inventoryRowId // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      formula: freezed == formula
          ? _self.formula
          : formula // ignore: cast_nullable_to_non_nullable
              as String?,
      isCalculated: null == isCalculated
          ? _self.isCalculated
          : isCalculated // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _InventoryCellModel implements InventoryCellModel {
  const _InventoryCellModel(
      {required this.id,
      required this.columnIndex,
      required this.inventoryRowId,
      this.color,
      this.value,
      this.formula,
      required this.isCalculated,
      required this.createdAt,
      required this.updatedAt});
  factory _InventoryCellModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryCellModelFromJson(json);

  @override
  final String id;
  @override
  final int columnIndex;
  @override
  final String inventoryRowId;
  @override
  final String? color;
// Add color field as a hex string
  @override
  final String? value;
  @override
  final String? formula;
  @override
  final bool isCalculated;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of InventoryCellModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InventoryCellModelCopyWith<_InventoryCellModel> get copyWith =>
      __$InventoryCellModelCopyWithImpl<_InventoryCellModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InventoryCellModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InventoryCellModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.columnIndex, columnIndex) ||
                other.columnIndex == columnIndex) &&
            (identical(other.inventoryRowId, inventoryRowId) ||
                other.inventoryRowId == inventoryRowId) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.formula, formula) || other.formula == formula) &&
            (identical(other.isCalculated, isCalculated) ||
                other.isCalculated == isCalculated) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, columnIndex, inventoryRowId,
      color, value, formula, isCalculated, createdAt, updatedAt);

  @override
  String toString() {
    return 'InventoryCellModel(id: $id, columnIndex: $columnIndex, inventoryRowId: $inventoryRowId, color: $color, value: $value, formula: $formula, isCalculated: $isCalculated, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$InventoryCellModelCopyWith<$Res>
    implements $InventoryCellModelCopyWith<$Res> {
  factory _$InventoryCellModelCopyWith(
          _InventoryCellModel value, $Res Function(_InventoryCellModel) _then) =
      __$InventoryCellModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      int columnIndex,
      String inventoryRowId,
      String? color,
      String? value,
      String? formula,
      bool isCalculated,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$InventoryCellModelCopyWithImpl<$Res>
    implements _$InventoryCellModelCopyWith<$Res> {
  __$InventoryCellModelCopyWithImpl(this._self, this._then);

  final _InventoryCellModel _self;
  final $Res Function(_InventoryCellModel) _then;

  /// Create a copy of InventoryCellModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? columnIndex = null,
    Object? inventoryRowId = null,
    Object? color = freezed,
    Object? value = freezed,
    Object? formula = freezed,
    Object? isCalculated = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_InventoryCellModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      columnIndex: null == columnIndex
          ? _self.columnIndex
          : columnIndex // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryRowId: null == inventoryRowId
          ? _self.inventoryRowId
          : inventoryRowId // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      formula: freezed == formula
          ? _self.formula
          : formula // ignore: cast_nullable_to_non_nullable
              as String?,
      isCalculated: null == isCalculated
          ? _self.isCalculated
          : isCalculated // ignore: cast_nullable_to_non_nullable
              as bool,
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
