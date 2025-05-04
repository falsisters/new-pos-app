// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profit_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfitCategory {
  List<GroupedProfitItem> get items;
  double get totalProfit;

  /// Create a copy of ProfitCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfitCategoryCopyWith<ProfitCategory> get copyWith =>
      _$ProfitCategoryCopyWithImpl<ProfitCategory>(
          this as ProfitCategory, _$identity);

  /// Serializes this ProfitCategory to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfitCategory &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.totalProfit, totalProfit) ||
                other.totalProfit == totalProfit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), totalProfit);

  @override
  String toString() {
    return 'ProfitCategory(items: $items, totalProfit: $totalProfit)';
  }
}

/// @nodoc
abstract mixin class $ProfitCategoryCopyWith<$Res> {
  factory $ProfitCategoryCopyWith(
          ProfitCategory value, $Res Function(ProfitCategory) _then) =
      _$ProfitCategoryCopyWithImpl;
  @useResult
  $Res call({List<GroupedProfitItem> items, double totalProfit});
}

/// @nodoc
class _$ProfitCategoryCopyWithImpl<$Res>
    implements $ProfitCategoryCopyWith<$Res> {
  _$ProfitCategoryCopyWithImpl(this._self, this._then);

  final ProfitCategory _self;
  final $Res Function(ProfitCategory) _then;

  /// Create a copy of ProfitCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? totalProfit = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<GroupedProfitItem>,
      totalProfit: null == totalProfit
          ? _self.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ProfitCategory implements ProfitCategory {
  const _ProfitCategory(
      {required final List<GroupedProfitItem> items, required this.totalProfit})
      : _items = items;
  factory _ProfitCategory.fromJson(Map<String, dynamic> json) =>
      _$ProfitCategoryFromJson(json);

  final List<GroupedProfitItem> _items;
  @override
  List<GroupedProfitItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double totalProfit;

  /// Create a copy of ProfitCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfitCategoryCopyWith<_ProfitCategory> get copyWith =>
      __$ProfitCategoryCopyWithImpl<_ProfitCategory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfitCategoryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfitCategory &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalProfit, totalProfit) ||
                other.totalProfit == totalProfit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), totalProfit);

  @override
  String toString() {
    return 'ProfitCategory(items: $items, totalProfit: $totalProfit)';
  }
}

/// @nodoc
abstract mixin class _$ProfitCategoryCopyWith<$Res>
    implements $ProfitCategoryCopyWith<$Res> {
  factory _$ProfitCategoryCopyWith(
          _ProfitCategory value, $Res Function(_ProfitCategory) _then) =
      __$ProfitCategoryCopyWithImpl;
  @override
  @useResult
  $Res call({List<GroupedProfitItem> items, double totalProfit});
}

/// @nodoc
class __$ProfitCategoryCopyWithImpl<$Res>
    implements _$ProfitCategoryCopyWith<$Res> {
  __$ProfitCategoryCopyWithImpl(this._self, this._then);

  final _ProfitCategory _self;
  final $Res Function(_ProfitCategory) _then;

  /// Create a copy of ProfitCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? totalProfit = null,
  }) {
    return _then(_ProfitCategory(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<GroupedProfitItem>,
      totalProfit: null == totalProfit
          ? _self.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
