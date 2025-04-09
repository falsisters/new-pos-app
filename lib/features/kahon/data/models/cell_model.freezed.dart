// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cell_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CellModel {
  String get id;
  int get columnIndex;
  String get rowId;
  String? get color;
  String? get kahonItemId;
  String? get value;
  String? get formula;
  bool get isCalculated;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of CellModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CellModelCopyWith<CellModel> get copyWith =>
      _$CellModelCopyWithImpl<CellModel>(this as CellModel, _$identity);

  /// Serializes this CellModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CellModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.columnIndex, columnIndex) ||
                other.columnIndex == columnIndex) &&
            (identical(other.rowId, rowId) || other.rowId == rowId) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.kahonItemId, kahonItemId) ||
                other.kahonItemId == kahonItemId) &&
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
  int get hashCode => Object.hash(runtimeType, id, columnIndex, rowId, color,
      kahonItemId, value, formula, isCalculated, createdAt, updatedAt);

  @override
  String toString() {
    return 'CellModel(id: $id, columnIndex: $columnIndex, rowId: $rowId, color: $color, kahonItemId: $kahonItemId, value: $value, formula: $formula, isCalculated: $isCalculated, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $CellModelCopyWith<$Res> {
  factory $CellModelCopyWith(CellModel value, $Res Function(CellModel) _then) =
      _$CellModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      int columnIndex,
      String rowId,
      String? color,
      String? kahonItemId,
      String? value,
      String? formula,
      bool isCalculated,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$CellModelCopyWithImpl<$Res> implements $CellModelCopyWith<$Res> {
  _$CellModelCopyWithImpl(this._self, this._then);

  final CellModel _self;
  final $Res Function(CellModel) _then;

  /// Create a copy of CellModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? columnIndex = null,
    Object? rowId = null,
    Object? color = freezed,
    Object? kahonItemId = freezed,
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
      rowId: null == rowId
          ? _self.rowId
          : rowId // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      kahonItemId: freezed == kahonItemId
          ? _self.kahonItemId
          : kahonItemId // ignore: cast_nullable_to_non_nullable
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
class _CellModel implements CellModel {
  const _CellModel(
      {required this.id,
      required this.columnIndex,
      required this.rowId,
      this.color,
      this.kahonItemId,
      this.value,
      this.formula,
      required this.isCalculated,
      required this.createdAt,
      required this.updatedAt});
  factory _CellModel.fromJson(Map<String, dynamic> json) =>
      _$CellModelFromJson(json);

  @override
  final String id;
  @override
  final int columnIndex;
  @override
  final String rowId;
  @override
  final String? color;
  @override
  final String? kahonItemId;
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

  /// Create a copy of CellModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CellModelCopyWith<_CellModel> get copyWith =>
      __$CellModelCopyWithImpl<_CellModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CellModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CellModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.columnIndex, columnIndex) ||
                other.columnIndex == columnIndex) &&
            (identical(other.rowId, rowId) || other.rowId == rowId) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.kahonItemId, kahonItemId) ||
                other.kahonItemId == kahonItemId) &&
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
  int get hashCode => Object.hash(runtimeType, id, columnIndex, rowId, color,
      kahonItemId, value, formula, isCalculated, createdAt, updatedAt);

  @override
  String toString() {
    return 'CellModel(id: $id, columnIndex: $columnIndex, rowId: $rowId, color: $color, kahonItemId: $kahonItemId, value: $value, formula: $formula, isCalculated: $isCalculated, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$CellModelCopyWith<$Res>
    implements $CellModelCopyWith<$Res> {
  factory _$CellModelCopyWith(
          _CellModel value, $Res Function(_CellModel) _then) =
      __$CellModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      int columnIndex,
      String rowId,
      String? color,
      String? kahonItemId,
      String? value,
      String? formula,
      bool isCalculated,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$CellModelCopyWithImpl<$Res> implements _$CellModelCopyWith<$Res> {
  __$CellModelCopyWithImpl(this._self, this._then);

  final _CellModel _self;
  final $Res Function(_CellModel) _then;

  /// Create a copy of CellModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? columnIndex = null,
    Object? rowId = null,
    Object? color = freezed,
    Object? kahonItemId = freezed,
    Object? value = freezed,
    Object? formula = freezed,
    Object? isCalculated = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_CellModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      columnIndex: null == columnIndex
          ? _self.columnIndex
          : columnIndex // ignore: cast_nullable_to_non_nullable
              as int,
      rowId: null == rowId
          ? _self.rowId
          : rowId // ignore: cast_nullable_to_non_nullable
              as String,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      kahonItemId: freezed == kahonItemId
          ? _self.kahonItemId
          : kahonItemId // ignore: cast_nullable_to_non_nullable
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
