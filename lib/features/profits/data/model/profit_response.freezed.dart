// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profit_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfitResponse {
  ProfitCategory get sacks;
  ProfitCategory get asin;
  @DecimalConverter()
  Decimal get overallTotal;
  @JsonKey(name: 'rawItems')
  List<ProfitItem> get items;

  /// Create a copy of ProfitResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfitResponseCopyWith<ProfitResponse> get copyWith =>
      _$ProfitResponseCopyWithImpl<ProfitResponse>(
          this as ProfitResponse, _$identity);

  /// Serializes this ProfitResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfitResponse &&
            (identical(other.sacks, sacks) || other.sacks == sacks) &&
            (identical(other.asin, asin) || other.asin == asin) &&
            (identical(other.overallTotal, overallTotal) ||
                other.overallTotal == overallTotal) &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sacks, asin, overallTotal,
      const DeepCollectionEquality().hash(items));

  @override
  String toString() {
    return 'ProfitResponse(sacks: $sacks, asin: $asin, overallTotal: $overallTotal, items: $items)';
  }
}

/// @nodoc
abstract mixin class $ProfitResponseCopyWith<$Res> {
  factory $ProfitResponseCopyWith(
          ProfitResponse value, $Res Function(ProfitResponse) _then) =
      _$ProfitResponseCopyWithImpl;
  @useResult
  $Res call(
      {ProfitCategory sacks,
      ProfitCategory asin,
      @DecimalConverter() Decimal overallTotal,
      @JsonKey(name: 'rawItems') List<ProfitItem> items});

  $ProfitCategoryCopyWith<$Res> get sacks;
  $ProfitCategoryCopyWith<$Res> get asin;
}

/// @nodoc
class _$ProfitResponseCopyWithImpl<$Res>
    implements $ProfitResponseCopyWith<$Res> {
  _$ProfitResponseCopyWithImpl(this._self, this._then);

  final ProfitResponse _self;
  final $Res Function(ProfitResponse) _then;

  /// Create a copy of ProfitResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sacks = null,
    Object? asin = null,
    Object? overallTotal = null,
    Object? items = null,
  }) {
    return _then(_self.copyWith(
      sacks: null == sacks
          ? _self.sacks
          : sacks // ignore: cast_nullable_to_non_nullable
              as ProfitCategory,
      asin: null == asin
          ? _self.asin
          : asin // ignore: cast_nullable_to_non_nullable
              as ProfitCategory,
      overallTotal: null == overallTotal
          ? _self.overallTotal
          : overallTotal // ignore: cast_nullable_to_non_nullable
              as Decimal,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ProfitItem>,
    ));
  }

  /// Create a copy of ProfitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfitCategoryCopyWith<$Res> get sacks {
    return $ProfitCategoryCopyWith<$Res>(_self.sacks, (value) {
      return _then(_self.copyWith(sacks: value));
    });
  }

  /// Create a copy of ProfitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfitCategoryCopyWith<$Res> get asin {
    return $ProfitCategoryCopyWith<$Res>(_self.asin, (value) {
      return _then(_self.copyWith(asin: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _ProfitResponse implements ProfitResponse {
  const _ProfitResponse(
      {required this.sacks,
      required this.asin,
      @DecimalConverter() required this.overallTotal,
      @JsonKey(name: 'rawItems') required final List<ProfitItem> items})
      : _items = items;
  factory _ProfitResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfitResponseFromJson(json);

  @override
  final ProfitCategory sacks;
  @override
  final ProfitCategory asin;
  @override
  @DecimalConverter()
  final Decimal overallTotal;
  final List<ProfitItem> _items;
  @override
  @JsonKey(name: 'rawItems')
  List<ProfitItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of ProfitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfitResponseCopyWith<_ProfitResponse> get copyWith =>
      __$ProfitResponseCopyWithImpl<_ProfitResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfitResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfitResponse &&
            (identical(other.sacks, sacks) || other.sacks == sacks) &&
            (identical(other.asin, asin) || other.asin == asin) &&
            (identical(other.overallTotal, overallTotal) ||
                other.overallTotal == overallTotal) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sacks, asin, overallTotal,
      const DeepCollectionEquality().hash(_items));

  @override
  String toString() {
    return 'ProfitResponse(sacks: $sacks, asin: $asin, overallTotal: $overallTotal, items: $items)';
  }
}

/// @nodoc
abstract mixin class _$ProfitResponseCopyWith<$Res>
    implements $ProfitResponseCopyWith<$Res> {
  factory _$ProfitResponseCopyWith(
          _ProfitResponse value, $Res Function(_ProfitResponse) _then) =
      __$ProfitResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ProfitCategory sacks,
      ProfitCategory asin,
      @DecimalConverter() Decimal overallTotal,
      @JsonKey(name: 'rawItems') List<ProfitItem> items});

  @override
  $ProfitCategoryCopyWith<$Res> get sacks;
  @override
  $ProfitCategoryCopyWith<$Res> get asin;
}

/// @nodoc
class __$ProfitResponseCopyWithImpl<$Res>
    implements _$ProfitResponseCopyWith<$Res> {
  __$ProfitResponseCopyWithImpl(this._self, this._then);

  final _ProfitResponse _self;
  final $Res Function(_ProfitResponse) _then;

  /// Create a copy of ProfitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sacks = null,
    Object? asin = null,
    Object? overallTotal = null,
    Object? items = null,
  }) {
    return _then(_ProfitResponse(
      sacks: null == sacks
          ? _self.sacks
          : sacks // ignore: cast_nullable_to_non_nullable
              as ProfitCategory,
      asin: null == asin
          ? _self.asin
          : asin // ignore: cast_nullable_to_non_nullable
              as ProfitCategory,
      overallTotal: null == overallTotal
          ? _self.overallTotal
          : overallTotal // ignore: cast_nullable_to_non_nullable
              as Decimal,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ProfitItem>,
    ));
  }

  /// Create a copy of ProfitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfitCategoryCopyWith<$Res> get sacks {
    return $ProfitCategoryCopyWith<$Res>(_self.sacks, (value) {
      return _then(_self.copyWith(sacks: value));
    });
  }

  /// Create a copy of ProfitResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfitCategoryCopyWith<$Res> get asin {
    return $ProfitCategoryCopyWith<$Res>(_self.asin, (value) {
      return _then(_self.copyWith(asin: value));
    });
  }
}

// dart format on
