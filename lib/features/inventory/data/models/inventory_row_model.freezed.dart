// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_row_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryRowModel {
  String get id;
  int get rowIndex;
  String get inventorySheetId;
  bool get isItemRow;
  String? get itemId;
  DateTime get createdAt;
  DateTime get updatedAt;
  @JsonKey(name: 'Cells')
  List<InventoryCellModel> get cells;

  /// Create a copy of InventoryRowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InventoryRowModelCopyWith<InventoryRowModel> get copyWith =>
      _$InventoryRowModelCopyWithImpl<InventoryRowModel>(
          this as InventoryRowModel, _$identity);

  /// Serializes this InventoryRowModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InventoryRowModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rowIndex, rowIndex) ||
                other.rowIndex == rowIndex) &&
            (identical(other.inventorySheetId, inventorySheetId) ||
                other.inventorySheetId == inventorySheetId) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      id,
      rowIndex,
      inventorySheetId,
      isItemRow,
      itemId,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(cells));

  @override
  String toString() {
    return 'InventoryRowModel(id: $id, rowIndex: $rowIndex, inventorySheetId: $inventorySheetId, isItemRow: $isItemRow, itemId: $itemId, createdAt: $createdAt, updatedAt: $updatedAt, cells: $cells)';
  }
}

/// @nodoc
abstract mixin class $InventoryRowModelCopyWith<$Res> {
  factory $InventoryRowModelCopyWith(
          InventoryRowModel value, $Res Function(InventoryRowModel) _then) =
      _$InventoryRowModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      int rowIndex,
      String inventorySheetId,
      bool isItemRow,
      String? itemId,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Cells') List<InventoryCellModel> cells});
}

/// @nodoc
class _$InventoryRowModelCopyWithImpl<$Res>
    implements $InventoryRowModelCopyWith<$Res> {
  _$InventoryRowModelCopyWithImpl(this._self, this._then);

  final InventoryRowModel _self;
  final $Res Function(InventoryRowModel) _then;

  /// Create a copy of InventoryRowModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rowIndex = null,
    Object? inventorySheetId = null,
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
      inventorySheetId: null == inventorySheetId
          ? _self.inventorySheetId
          : inventorySheetId // ignore: cast_nullable_to_non_nullable
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
              as List<InventoryCellModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _InventoryRowModel implements InventoryRowModel {
  const _InventoryRowModel(
      {required this.id,
      required this.rowIndex,
      required this.inventorySheetId,
      required this.isItemRow,
      this.itemId,
      required this.createdAt,
      required this.updatedAt,
      @JsonKey(name: 'Cells') final List<InventoryCellModel> cells = const []})
      : _cells = cells;
  factory _InventoryRowModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryRowModelFromJson(json);

  @override
  final String id;
  @override
  final int rowIndex;
  @override
  final String inventorySheetId;
  @override
  final bool isItemRow;
  @override
  final String? itemId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<InventoryCellModel> _cells;
  @override
  @JsonKey(name: 'Cells')
  List<InventoryCellModel> get cells {
    if (_cells is EqualUnmodifiableListView) return _cells;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cells);
  }

  /// Create a copy of InventoryRowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InventoryRowModelCopyWith<_InventoryRowModel> get copyWith =>
      __$InventoryRowModelCopyWithImpl<_InventoryRowModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InventoryRowModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InventoryRowModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rowIndex, rowIndex) ||
                other.rowIndex == rowIndex) &&
            (identical(other.inventorySheetId, inventorySheetId) ||
                other.inventorySheetId == inventorySheetId) &&
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
      inventorySheetId,
      isItemRow,
      itemId,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_cells));

  @override
  String toString() {
    return 'InventoryRowModel(id: $id, rowIndex: $rowIndex, inventorySheetId: $inventorySheetId, isItemRow: $isItemRow, itemId: $itemId, createdAt: $createdAt, updatedAt: $updatedAt, cells: $cells)';
  }
}

/// @nodoc
abstract mixin class _$InventoryRowModelCopyWith<$Res>
    implements $InventoryRowModelCopyWith<$Res> {
  factory _$InventoryRowModelCopyWith(
          _InventoryRowModel value, $Res Function(_InventoryRowModel) _then) =
      __$InventoryRowModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      int rowIndex,
      String inventorySheetId,
      bool isItemRow,
      String? itemId,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Cells') List<InventoryCellModel> cells});
}

/// @nodoc
class __$InventoryRowModelCopyWithImpl<$Res>
    implements _$InventoryRowModelCopyWith<$Res> {
  __$InventoryRowModelCopyWithImpl(this._self, this._then);

  final _InventoryRowModel _self;
  final $Res Function(_InventoryRowModel) _then;

  /// Create a copy of InventoryRowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? rowIndex = null,
    Object? inventorySheetId = null,
    Object? isItemRow = null,
    Object? itemId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? cells = null,
  }) {
    return _then(_InventoryRowModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rowIndex: null == rowIndex
          ? _self.rowIndex
          : rowIndex // ignore: cast_nullable_to_non_nullable
              as int,
      inventorySheetId: null == inventorySheetId
          ? _self.inventorySheetId
          : inventorySheetId // ignore: cast_nullable_to_non_nullable
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
              as List<InventoryCellModel>,
    ));
  }
}

// dart format on
