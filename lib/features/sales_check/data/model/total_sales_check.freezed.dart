// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'total_sales_check.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TotalSalesCheck {
  List<TotalSaleItem> get items;
  TotalSalesSummary get summary;

  /// Create a copy of TotalSalesCheck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TotalSalesCheckCopyWith<TotalSalesCheck> get copyWith =>
      _$TotalSalesCheckCopyWithImpl<TotalSalesCheck>(
          this as TotalSalesCheck, _$identity);

  /// Serializes this TotalSalesCheck to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TotalSalesCheck &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), summary);

  @override
  String toString() {
    return 'TotalSalesCheck(items: $items, summary: $summary)';
  }
}

/// @nodoc
abstract mixin class $TotalSalesCheckCopyWith<$Res> {
  factory $TotalSalesCheckCopyWith(
          TotalSalesCheck value, $Res Function(TotalSalesCheck) _then) =
      _$TotalSalesCheckCopyWithImpl;
  @useResult
  $Res call({List<TotalSaleItem> items, TotalSalesSummary summary});

  $TotalSalesSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$TotalSalesCheckCopyWithImpl<$Res>
    implements $TotalSalesCheckCopyWith<$Res> {
  _$TotalSalesCheckCopyWithImpl(this._self, this._then);

  final TotalSalesCheck _self;
  final $Res Function(TotalSalesCheck) _then;

  /// Create a copy of TotalSalesCheck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? summary = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TotalSaleItem>,
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as TotalSalesSummary,
    ));
  }

  /// Create a copy of TotalSalesCheck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TotalSalesSummaryCopyWith<$Res> get summary {
    return $TotalSalesSummaryCopyWith<$Res>(_self.summary, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TotalSalesCheck implements TotalSalesCheck {
  const _TotalSalesCheck(
      {required final List<TotalSaleItem> items, required this.summary})
      : _items = items;
  factory _TotalSalesCheck.fromJson(Map<String, dynamic> json) =>
      _$TotalSalesCheckFromJson(json);

  final List<TotalSaleItem> _items;
  @override
  List<TotalSaleItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final TotalSalesSummary summary;

  /// Create a copy of TotalSalesCheck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TotalSalesCheckCopyWith<_TotalSalesCheck> get copyWith =>
      __$TotalSalesCheckCopyWithImpl<_TotalSalesCheck>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TotalSalesCheckToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TotalSalesCheck &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), summary);

  @override
  String toString() {
    return 'TotalSalesCheck(items: $items, summary: $summary)';
  }
}

/// @nodoc
abstract mixin class _$TotalSalesCheckCopyWith<$Res>
    implements $TotalSalesCheckCopyWith<$Res> {
  factory _$TotalSalesCheckCopyWith(
          _TotalSalesCheck value, $Res Function(_TotalSalesCheck) _then) =
      __$TotalSalesCheckCopyWithImpl;
  @override
  @useResult
  $Res call({List<TotalSaleItem> items, TotalSalesSummary summary});

  @override
  $TotalSalesSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$TotalSalesCheckCopyWithImpl<$Res>
    implements _$TotalSalesCheckCopyWith<$Res> {
  __$TotalSalesCheckCopyWithImpl(this._self, this._then);

  final _TotalSalesCheck _self;
  final $Res Function(_TotalSalesCheck) _then;

  /// Create a copy of TotalSalesCheck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? summary = null,
  }) {
    return _then(_TotalSalesCheck(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TotalSaleItem>,
      summary: null == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as TotalSalesSummary,
    ));
  }

  /// Create a copy of TotalSalesCheck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TotalSalesSummaryCopyWith<$Res> get summary {
    return $TotalSalesSummaryCopyWith<$Res>(_self.summary, (value) {
      return _then(_self.copyWith(summary: value));
    });
  }
}

// dart format on
