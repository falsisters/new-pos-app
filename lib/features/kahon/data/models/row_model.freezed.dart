// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'row_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RowModel {
  String get id;
  int get rowIndex;
  String get sheetId;
  bool get isItemRow;
  String? get itemId;
  DateTime get createdAt;
  DateTime get updatedAt;
  @JsonKey(name: 'Cells')
  List<CellModel> get cells;

  /// Create a copy of RowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RowModelCopyWith<RowModel> get copyWith =>
      _$RowModelCopyWithImpl<RowModel>(this as RowModel, _$identity);

  /// Serializes this RowModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RowModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rowIndex, rowIndex) ||
                other.rowIndex == rowIndex) &&
            (identical(other.sheetId, sheetId) || other.sheetId == sheetId) &&
            (identical(other.isItemRow, isItemRow) ||
                other.isItemRow == isItemRow) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.cells, cells));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, rowIndex, sheetId, isItemRow,
      itemId, createdAt, updatedAt, const DeepCollectionEquality().hash(cells));

  @override
  String toString() {
    return 'RowModel(id: $id, rowIndex: $rowIndex, sheetId: $sheetId, isItemRow: $isItemRow, itemId: $itemId, createdAt: $createdAt, updatedAt: $updatedAt, cells: $cells)';
  }
}

/// @nodoc
abstract mixin class $RowModelCopyWith<$Res> {
  factory $RowModelCopyWith(RowModel value, $Res Function(RowModel) _then) =
      _$RowModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      int rowIndex,
      String sheetId,
      bool isItemRow,
      String? itemId,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Cells') List<CellModel> cells});
}

/// @nodoc
class _$RowModelCopyWithImpl<$Res> implements $RowModelCopyWith<$Res> {
  _$RowModelCopyWithImpl(this._self, this._then);

  final RowModel _self;
  final $Res Function(RowModel) _then;

  /// Create a copy of RowModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rowIndex = null,
    Object? sheetId = null,
    Object? isItemRow = null,
    Object? itemId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? cells = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rowIndex: null == rowIndex
          ? _self.rowIndex
          : rowIndex // ignore: cast_nullable_to_non_nullable
              as int,
      sheetId: null == sheetId
          ? _self.sheetId
          : sheetId // ignore: cast_nullable_to_non_nullable
              as String,
      isItemRow: null == isItemRow
          ? _self.isItemRow
          : isItemRow // ignore: cast_nullable_to_non_nullable
              as bool,
      itemId: freezed == itemId
          ? _self.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cells: null == cells
          ? _self.cells
          : cells // ignore: cast_nullable_to_non_nullable
              as List<CellModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _RowModel implements RowModel {
  const _RowModel(
      {required this.id,
      required this.rowIndex,
      required this.sheetId,
      required this.isItemRow,
      this.itemId,
      required this.createdAt,
      required this.updatedAt,
      @JsonKey(name: 'Cells') final List<CellModel> cells = const []})
      : _cells = cells;
  factory _RowModel.fromJson(Map<String, dynamic> json) =>
      _$RowModelFromJson(json);

  @override
  final String id;
  @override
  final int rowIndex;
  @override
  final String sheetId;
  @override
  final bool isItemRow;
  @override
  final String? itemId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<CellModel> _cells;
  @override
  @JsonKey(name: 'Cells')
  List<CellModel> get cells {
    if (_cells is EqualUnmodifiableListView) return _cells;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cells);
  }

  /// Create a copy of RowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RowModelCopyWith<_RowModel> get copyWith =>
      __$RowModelCopyWithImpl<_RowModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RowModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RowModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rowIndex, rowIndex) ||
                other.rowIndex == rowIndex) &&
            (identical(other.sheetId, sheetId) || other.sheetId == sheetId) &&
            (identical(other.isItemRow, isItemRow) ||
                other.isItemRow == isItemRow) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._cells, _cells));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      rowIndex,
      sheetId,
      isItemRow,
      itemId,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_cells));

  @override
  String toString() {
    return 'RowModel(id: $id, rowIndex: $rowIndex, sheetId: $sheetId, isItemRow: $isItemRow, itemId: $itemId, createdAt: $createdAt, updatedAt: $updatedAt, cells: $cells)';
  }
}

/// @nodoc
abstract mixin class _$RowModelCopyWith<$Res>
    implements $RowModelCopyWith<$Res> {
  factory _$RowModelCopyWith(_RowModel value, $Res Function(_RowModel) _then) =
      __$RowModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      int rowIndex,
      String sheetId,
      bool isItemRow,
      String? itemId,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Cells') List<CellModel> cells});
}

/// @nodoc
class __$RowModelCopyWithImpl<$Res> implements _$RowModelCopyWith<$Res> {
  __$RowModelCopyWithImpl(this._self, this._then);

  final _RowModel _self;
  final $Res Function(_RowModel) _then;

  /// Create a copy of RowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? rowIndex = null,
    Object? sheetId = null,
    Object? isItemRow = null,
    Object? itemId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? cells = null,
  }) {
    return _then(_RowModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rowIndex: null == rowIndex
          ? _self.rowIndex
          : rowIndex // ignore: cast_nullable_to_non_nullable
              as int,
      sheetId: null == sheetId
          ? _self.sheetId
          : sheetId // ignore: cast_nullable_to_non_nullable
              as String,
      isItemRow: null == isItemRow
          ? _self.isItemRow
          : isItemRow // ignore: cast_nullable_to_non_nullable
              as bool,
      itemId: freezed == itemId
          ? _self.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cells: null == cells
          ? _self._cells
          : cells // ignore: cast_nullable_to_non_nullable
              as List<CellModel>,
    ));
  }
}

// dart format on
