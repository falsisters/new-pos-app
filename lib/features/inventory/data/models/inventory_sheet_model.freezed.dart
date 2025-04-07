// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_sheet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventorySheetModel {
  String get id;
  String get name;
  String get inventoryId;
  int get columns;
  DateTime get createdAt;
  DateTime get updatedAt;
  @JsonKey(name: 'Rows')
  List<InventoryRowModel> get rows;

  /// Create a copy of InventorySheetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InventorySheetModelCopyWith<InventorySheetModel> get copyWith =>
      _$InventorySheetModelCopyWithImpl<InventorySheetModel>(
          this as InventorySheetModel, _$identity);

  /// Serializes this InventorySheetModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InventorySheetModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.columns, columns) || other.columns == columns) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.rows, rows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, inventoryId, columns,
      createdAt, updatedAt, const DeepCollectionEquality().hash(rows));

  @override
  String toString() {
    return 'InventorySheetModel(id: $id, name: $name, inventoryId: $inventoryId, columns: $columns, createdAt: $createdAt, updatedAt: $updatedAt, rows: $rows)';
  }
}

/// @nodoc
abstract mixin class $InventorySheetModelCopyWith<$Res> {
  factory $InventorySheetModelCopyWith(
          InventorySheetModel value, $Res Function(InventorySheetModel) _then) =
      _$InventorySheetModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String inventoryId,
      int columns,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Rows') List<InventoryRowModel> rows});
}

/// @nodoc
class _$InventorySheetModelCopyWithImpl<$Res>
    implements $InventorySheetModelCopyWith<$Res> {
  _$InventorySheetModelCopyWithImpl(this._self, this._then);

  final InventorySheetModel _self;
  final $Res Function(InventorySheetModel) _then;

  /// Create a copy of InventorySheetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inventoryId = null,
    Object? columns = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? rows = null,
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
      inventoryId: null == inventoryId
          ? _self.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as String,
      columns: null == columns
          ? _self.columns
          : columns // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rows: null == rows
          ? _self.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<InventoryRowModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _InventorySheetModel implements InventorySheetModel {
  const _InventorySheetModel(
      {required this.id,
      required this.name,
      required this.inventoryId,
      required this.columns,
      required this.createdAt,
      required this.updatedAt,
      @JsonKey(name: 'Rows') final List<InventoryRowModel> rows = const []})
      : _rows = rows;
  factory _InventorySheetModel.fromJson(Map<String, dynamic> json) =>
      _$InventorySheetModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String inventoryId;
  @override
  final int columns;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<InventoryRowModel> _rows;
  @override
  @JsonKey(name: 'Rows')
  List<InventoryRowModel> get rows {
    if (_rows is EqualUnmodifiableListView) return _rows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rows);
  }

  /// Create a copy of InventorySheetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InventorySheetModelCopyWith<_InventorySheetModel> get copyWith =>
      __$InventorySheetModelCopyWithImpl<_InventorySheetModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InventorySheetModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InventorySheetModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.columns, columns) || other.columns == columns) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._rows, _rows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, inventoryId, columns,
      createdAt, updatedAt, const DeepCollectionEquality().hash(_rows));

  @override
  String toString() {
    return 'InventorySheetModel(id: $id, name: $name, inventoryId: $inventoryId, columns: $columns, createdAt: $createdAt, updatedAt: $updatedAt, rows: $rows)';
  }
}

/// @nodoc
abstract mixin class _$InventorySheetModelCopyWith<$Res>
    implements $InventorySheetModelCopyWith<$Res> {
  factory _$InventorySheetModelCopyWith(_InventorySheetModel value,
          $Res Function(_InventorySheetModel) _then) =
      __$InventorySheetModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String inventoryId,
      int columns,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Rows') List<InventoryRowModel> rows});
}

/// @nodoc
class __$InventorySheetModelCopyWithImpl<$Res>
    implements _$InventorySheetModelCopyWith<$Res> {
  __$InventorySheetModelCopyWithImpl(this._self, this._then);

  final _InventorySheetModel _self;
  final $Res Function(_InventorySheetModel) _then;

  /// Create a copy of InventorySheetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inventoryId = null,
    Object? columns = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? rows = null,
  }) {
    return _then(_InventorySheetModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      inventoryId: null == inventoryId
          ? _self.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as String,
      columns: null == columns
          ? _self.columns
          : columns // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rows: null == rows
          ? _self._rows
          : rows // ignore: cast_nullable_to_non_nullable
              as List<InventoryRowModel>,
    ));
  }
}

// dart format on
