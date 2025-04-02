// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kahon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KahonModel {
  String get id;
  String get name;
  String get cashierId;
  DateTime get createdAt;
  DateTime get updatedAt;
  @JsonKey(name: 'KahonItems')
  List<KahonItemModel> get kahonItems;
  @JsonKey(name: 'Sheets')
  List<SheetModel> get sheets;

  /// Create a copy of KahonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KahonModelCopyWith<KahonModel> get copyWith =>
      _$KahonModelCopyWithImpl<KahonModel>(this as KahonModel, _$identity);

  /// Serializes this KahonModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KahonModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other.kahonItems, kahonItems) &&
            const DeepCollectionEquality().equals(other.sheets, sheets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      cashierId,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(kahonItems),
      const DeepCollectionEquality().hash(sheets));

  @override
  String toString() {
    return 'KahonModel(id: $id, name: $name, cashierId: $cashierId, createdAt: $createdAt, updatedAt: $updatedAt, kahonItems: $kahonItems, sheets: $sheets)';
  }
}

/// @nodoc
abstract mixin class $KahonModelCopyWith<$Res> {
  factory $KahonModelCopyWith(
          KahonModel value, $Res Function(KahonModel) _then) =
      _$KahonModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String cashierId,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'KahonItems') List<KahonItemModel> kahonItems,
      @JsonKey(name: 'Sheets') List<SheetModel> sheets});
}

/// @nodoc
class _$KahonModelCopyWithImpl<$Res> implements $KahonModelCopyWith<$Res> {
  _$KahonModelCopyWithImpl(this._self, this._then);

  final KahonModel _self;
  final $Res Function(KahonModel) _then;

  /// Create a copy of KahonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cashierId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? kahonItems = null,
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
      kahonItems: null == kahonItems
          ? _self.kahonItems
          : kahonItems // ignore: cast_nullable_to_non_nullable
              as List<KahonItemModel>,
      sheets: null == sheets
          ? _self.sheets
          : sheets // ignore: cast_nullable_to_non_nullable
              as List<SheetModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _KahonModel implements KahonModel {
  const _KahonModel(
      {required this.id,
      required this.name,
      required this.cashierId,
      required this.createdAt,
      required this.updatedAt,
      @JsonKey(name: 'KahonItems')
      final List<KahonItemModel> kahonItems = const [],
      @JsonKey(name: 'Sheets') final List<SheetModel> sheets = const []})
      : _kahonItems = kahonItems,
        _sheets = sheets;
  factory _KahonModel.fromJson(Map<String, dynamic> json) =>
      _$KahonModelFromJson(json);

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
  final List<KahonItemModel> _kahonItems;
  @override
  @JsonKey(name: 'KahonItems')
  List<KahonItemModel> get kahonItems {
    if (_kahonItems is EqualUnmodifiableListView) return _kahonItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_kahonItems);
  }

  final List<SheetModel> _sheets;
  @override
  @JsonKey(name: 'Sheets')
  List<SheetModel> get sheets {
    if (_sheets is EqualUnmodifiableListView) return _sheets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sheets);
  }

  /// Create a copy of KahonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KahonModelCopyWith<_KahonModel> get copyWith =>
      __$KahonModelCopyWithImpl<_KahonModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$KahonModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KahonModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._kahonItems, _kahonItems) &&
            const DeepCollectionEquality().equals(other._sheets, _sheets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      cashierId,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_kahonItems),
      const DeepCollectionEquality().hash(_sheets));

  @override
  String toString() {
    return 'KahonModel(id: $id, name: $name, cashierId: $cashierId, createdAt: $createdAt, updatedAt: $updatedAt, kahonItems: $kahonItems, sheets: $sheets)';
  }
}

/// @nodoc
abstract mixin class _$KahonModelCopyWith<$Res>
    implements $KahonModelCopyWith<$Res> {
  factory _$KahonModelCopyWith(
          _KahonModel value, $Res Function(_KahonModel) _then) =
      __$KahonModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String cashierId,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'KahonItems') List<KahonItemModel> kahonItems,
      @JsonKey(name: 'Sheets') List<SheetModel> sheets});
}

/// @nodoc
class __$KahonModelCopyWithImpl<$Res> implements _$KahonModelCopyWith<$Res> {
  __$KahonModelCopyWithImpl(this._self, this._then);

  final _KahonModel _self;
  final $Res Function(_KahonModel) _then;

  /// Create a copy of KahonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cashierId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? kahonItems = null,
    Object? sheets = null,
  }) {
    return _then(_KahonModel(
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
      kahonItems: null == kahonItems
          ? _self._kahonItems
          : kahonItems // ignore: cast_nullable_to_non_nullable
              as List<KahonItemModel>,
      sheets: null == sheets
          ? _self._sheets
          : sheets // ignore: cast_nullable_to_non_nullable
              as List<SheetModel>,
    ));
  }
}

// dart format on
