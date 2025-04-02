// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sheet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SheetModel {
  String get id;
  String get name;
  String get kahonId;
  int get columns;
  DateTime get createdAt;
  DateTime get updatedAt;
  @JsonKey(name: 'Rows')
  List<RowModel> get rows;

  /// Create a copy of SheetModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SheetModelCopyWith<SheetModel> get copyWith =>
      _$SheetModelCopyWithImpl<SheetModel>(this as SheetModel, _$identity);

  /// Serializes this SheetModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SheetModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.kahonId, kahonId) || other.kahonId == kahonId) &&
            (identical(other.columns, columns) || other.columns == columns) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.rows, rows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, kahonId, columns,
      createdAt, updatedAt, const DeepCollectionEquality().hash(rows));

  @override
  String toString() {
    return 'SheetModel(id: $id, name: $name, kahonId: $kahonId, columns: $columns, createdAt: $createdAt, updatedAt: $updatedAt, rows: $rows)';
  }
}

/// @nodoc
abstract mixin class $SheetModelCopyWith<$Res> {
  factory $SheetModelCopyWith(
          SheetModel value, $Res Function(SheetModel) _then) =
      _$SheetModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String kahonId,
      int columns,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Rows') List<RowModel> rows});
}

/// @nodoc
class _$SheetModelCopyWithImpl<$Res> implements $SheetModelCopyWith<$Res> {
  _$SheetModelCopyWithImpl(this._self, this._then);

  final SheetModel _self;
  final $Res Function(SheetModel) _then;

  /// Create a copy of SheetModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? kahonId = null,
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
      kahonId: null == kahonId
          ? _self.kahonId
          : kahonId // ignore: cast_nullable_to_non_nullable
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
              as List<RowModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SheetModel implements SheetModel {
  const _SheetModel(
      {required this.id,
      required this.name,
      required this.kahonId,
      required this.columns,
      required this.createdAt,
      required this.updatedAt,
      @JsonKey(name: 'Rows') final List<RowModel> rows = const []})
      : _rows = rows;
  factory _SheetModel.fromJson(Map<String, dynamic> json) =>
      _$SheetModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String kahonId;
  @override
  final int columns;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<RowModel> _rows;
  @override
  @JsonKey(name: 'Rows')
  List<RowModel> get rows {
    if (_rows is EqualUnmodifiableListView) return _rows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rows);
  }

  /// Create a copy of SheetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SheetModelCopyWith<_SheetModel> get copyWith =>
      __$SheetModelCopyWithImpl<_SheetModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SheetModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SheetModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.kahonId, kahonId) || other.kahonId == kahonId) &&
            (identical(other.columns, columns) || other.columns == columns) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._rows, _rows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, kahonId, columns,
      createdAt, updatedAt, const DeepCollectionEquality().hash(_rows));

  @override
  String toString() {
    return 'SheetModel(id: $id, name: $name, kahonId: $kahonId, columns: $columns, createdAt: $createdAt, updatedAt: $updatedAt, rows: $rows)';
  }
}

/// @nodoc
abstract mixin class _$SheetModelCopyWith<$Res>
    implements $SheetModelCopyWith<$Res> {
  factory _$SheetModelCopyWith(
          _SheetModel value, $Res Function(_SheetModel) _then) =
      __$SheetModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String kahonId,
      int columns,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Rows') List<RowModel> rows});
}

/// @nodoc
class __$SheetModelCopyWithImpl<$Res> implements _$SheetModelCopyWith<$Res> {
  __$SheetModelCopyWithImpl(this._self, this._then);

  final _SheetModel _self;
  final $Res Function(_SheetModel) _then;

  /// Create a copy of SheetModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? kahonId = null,
    Object? columns = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? rows = null,
  }) {
    return _then(_SheetModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      kahonId: null == kahonId
          ? _self.kahonId
          : kahonId // ignore: cast_nullable_to_non_nullable
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
              as List<RowModel>,
    ));
  }
}

// dart format on
