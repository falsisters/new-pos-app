// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kahon_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KahonItemModel {
  String get id;
  String get name;
  double get quantity;
  String get kahonId;
  DateTime get createdAt;
  DateTime get updatedAt;
  @JsonKey(name: 'Cells')
  List<CellModel> get cells;

  /// Create a copy of KahonItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KahonItemModelCopyWith<KahonItemModel> get copyWith =>
      _$KahonItemModelCopyWithImpl<KahonItemModel>(
          this as KahonItemModel, _$identity);

  /// Serializes this KahonItemModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KahonItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.kahonId, kahonId) || other.kahonId == kahonId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.cells, cells));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity, kahonId,
      createdAt, updatedAt, const DeepCollectionEquality().hash(cells));

  @override
  String toString() {
    return 'KahonItemModel(id: $id, name: $name, quantity: $quantity, kahonId: $kahonId, createdAt: $createdAt, updatedAt: $updatedAt, cells: $cells)';
  }
}

/// @nodoc
abstract mixin class $KahonItemModelCopyWith<$Res> {
  factory $KahonItemModelCopyWith(
          KahonItemModel value, $Res Function(KahonItemModel) _then) =
      _$KahonItemModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      double quantity,
      String kahonId,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Cells') List<CellModel> cells});
}

/// @nodoc
class _$KahonItemModelCopyWithImpl<$Res>
    implements $KahonItemModelCopyWith<$Res> {
  _$KahonItemModelCopyWithImpl(this._self, this._then);

  final KahonItemModel _self;
  final $Res Function(KahonItemModel) _then;

  /// Create a copy of KahonItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? kahonId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? cells = null,
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
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      kahonId: null == kahonId
          ? _self.kahonId
          : kahonId // ignore: cast_nullable_to_non_nullable
              as String,
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
class _KahonItemModel implements KahonItemModel {
  const _KahonItemModel(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.kahonId,
      required this.createdAt,
      required this.updatedAt,
      @JsonKey(name: 'Cells') final List<CellModel> cells = const []})
      : _cells = cells;
  factory _KahonItemModel.fromJson(Map<String, dynamic> json) =>
      _$KahonItemModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double quantity;
  @override
  final String kahonId;
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

  /// Create a copy of KahonItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KahonItemModelCopyWith<_KahonItemModel> get copyWith =>
      __$KahonItemModelCopyWithImpl<_KahonItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$KahonItemModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KahonItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.kahonId, kahonId) || other.kahonId == kahonId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._cells, _cells));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity, kahonId,
      createdAt, updatedAt, const DeepCollectionEquality().hash(_cells));

  @override
  String toString() {
    return 'KahonItemModel(id: $id, name: $name, quantity: $quantity, kahonId: $kahonId, createdAt: $createdAt, updatedAt: $updatedAt, cells: $cells)';
  }
}

/// @nodoc
abstract mixin class _$KahonItemModelCopyWith<$Res>
    implements $KahonItemModelCopyWith<$Res> {
  factory _$KahonItemModelCopyWith(
          _KahonItemModel value, $Res Function(_KahonItemModel) _then) =
      __$KahonItemModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double quantity,
      String kahonId,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'Cells') List<CellModel> cells});
}

/// @nodoc
class __$KahonItemModelCopyWithImpl<$Res>
    implements _$KahonItemModelCopyWith<$Res> {
  __$KahonItemModelCopyWithImpl(this._self, this._then);

  final _KahonItemModel _self;
  final $Res Function(_KahonItemModel) _then;

  /// Create a copy of KahonItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? kahonId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? cells = null,
  }) {
    return _then(_KahonItemModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      kahonId: null == kahonId
          ? _self.kahonId
          : kahonId // ignore: cast_nullable_to_non_nullable
              as String,
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
