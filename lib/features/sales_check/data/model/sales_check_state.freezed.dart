// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_check_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalesCheckState {
// Filters
  SalesCheckFilterDto? get groupedSalesFilters;
  TotalSalesFilterDto? get totalSalesFilters; // Results
  List<GroupedSalesCheckItem>? get groupedSales;
  TotalSalesCheck? get totalSales; // Status
  String? get error;
  bool get isLoading;

  /// Create a copy of SalesCheckState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SalesCheckStateCopyWith<SalesCheckState> get copyWith =>
      _$SalesCheckStateCopyWithImpl<SalesCheckState>(
          this as SalesCheckState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SalesCheckState &&
            (identical(other.groupedSalesFilters, groupedSalesFilters) ||
                other.groupedSalesFilters == groupedSalesFilters) &&
            (identical(other.totalSalesFilters, totalSalesFilters) ||
                other.totalSalesFilters == totalSalesFilters) &&
            const DeepCollectionEquality()
                .equals(other.groupedSales, groupedSales) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      groupedSalesFilters,
      totalSalesFilters,
      const DeepCollectionEquality().hash(groupedSales),
      totalSales,
      error,
      isLoading);

  @override
  String toString() {
    return 'SalesCheckState(groupedSalesFilters: $groupedSalesFilters, totalSalesFilters: $totalSalesFilters, groupedSales: $groupedSales, totalSales: $totalSales, error: $error, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class $SalesCheckStateCopyWith<$Res> {
  factory $SalesCheckStateCopyWith(
          SalesCheckState value, $Res Function(SalesCheckState) _then) =
      _$SalesCheckStateCopyWithImpl;
  @useResult
  $Res call(
      {SalesCheckFilterDto? groupedSalesFilters,
      TotalSalesFilterDto? totalSalesFilters,
      List<GroupedSalesCheckItem>? groupedSales,
      TotalSalesCheck? totalSales,
      String? error,
      bool isLoading});

  $TotalSalesCheckCopyWith<$Res>? get totalSales;
}

/// @nodoc
class _$SalesCheckStateCopyWithImpl<$Res>
    implements $SalesCheckStateCopyWith<$Res> {
  _$SalesCheckStateCopyWithImpl(this._self, this._then);

  final SalesCheckState _self;
  final $Res Function(SalesCheckState) _then;

  /// Create a copy of SalesCheckState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupedSalesFilters = freezed,
    Object? totalSalesFilters = freezed,
    Object? groupedSales = freezed,
    Object? totalSales = freezed,
    Object? error = freezed,
    Object? isLoading = null,
  }) {
    return _then(_self.copyWith(
      groupedSalesFilters: freezed == groupedSalesFilters
          ? _self.groupedSalesFilters
          : groupedSalesFilters // ignore: cast_nullable_to_non_nullable
              as SalesCheckFilterDto?,
      totalSalesFilters: freezed == totalSalesFilters
          ? _self.totalSalesFilters
          : totalSalesFilters // ignore: cast_nullable_to_non_nullable
              as TotalSalesFilterDto?,
      groupedSales: freezed == groupedSales
          ? _self.groupedSales
          : groupedSales // ignore: cast_nullable_to_non_nullable
              as List<GroupedSalesCheckItem>?,
      totalSales: freezed == totalSales
          ? _self.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as TotalSalesCheck?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of SalesCheckState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TotalSalesCheckCopyWith<$Res>? get totalSales {
    if (_self.totalSales == null) {
      return null;
    }

    return $TotalSalesCheckCopyWith<$Res>(_self.totalSales!, (value) {
      return _then(_self.copyWith(totalSales: value));
    });
  }
}

/// @nodoc

class _SalesCheckState implements SalesCheckState {
  const _SalesCheckState(
      {this.groupedSalesFilters,
      this.totalSalesFilters,
      final List<GroupedSalesCheckItem>? groupedSales,
      this.totalSales,
      this.error,
      this.isLoading = false})
      : _groupedSales = groupedSales;

// Filters
  @override
  final SalesCheckFilterDto? groupedSalesFilters;
  @override
  final TotalSalesFilterDto? totalSalesFilters;
// Results
  final List<GroupedSalesCheckItem>? _groupedSales;
// Results
  @override
  List<GroupedSalesCheckItem>? get groupedSales {
    final value = _groupedSales;
    if (value == null) return null;
    if (_groupedSales is EqualUnmodifiableListView) return _groupedSales;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final TotalSalesCheck? totalSales;
// Status
  @override
  final String? error;
  @override
  @JsonKey()
  final bool isLoading;

  /// Create a copy of SalesCheckState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SalesCheckStateCopyWith<_SalesCheckState> get copyWith =>
      __$SalesCheckStateCopyWithImpl<_SalesCheckState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SalesCheckState &&
            (identical(other.groupedSalesFilters, groupedSalesFilters) ||
                other.groupedSalesFilters == groupedSalesFilters) &&
            (identical(other.totalSalesFilters, totalSalesFilters) ||
                other.totalSalesFilters == totalSalesFilters) &&
            const DeepCollectionEquality()
                .equals(other._groupedSales, _groupedSales) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      groupedSalesFilters,
      totalSalesFilters,
      const DeepCollectionEquality().hash(_groupedSales),
      totalSales,
      error,
      isLoading);

  @override
  String toString() {
    return 'SalesCheckState(groupedSalesFilters: $groupedSalesFilters, totalSalesFilters: $totalSalesFilters, groupedSales: $groupedSales, totalSales: $totalSales, error: $error, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class _$SalesCheckStateCopyWith<$Res>
    implements $SalesCheckStateCopyWith<$Res> {
  factory _$SalesCheckStateCopyWith(
          _SalesCheckState value, $Res Function(_SalesCheckState) _then) =
      __$SalesCheckStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {SalesCheckFilterDto? groupedSalesFilters,
      TotalSalesFilterDto? totalSalesFilters,
      List<GroupedSalesCheckItem>? groupedSales,
      TotalSalesCheck? totalSales,
      String? error,
      bool isLoading});

  @override
  $TotalSalesCheckCopyWith<$Res>? get totalSales;
}

/// @nodoc
class __$SalesCheckStateCopyWithImpl<$Res>
    implements _$SalesCheckStateCopyWith<$Res> {
  __$SalesCheckStateCopyWithImpl(this._self, this._then);

  final _SalesCheckState _self;
  final $Res Function(_SalesCheckState) _then;

  /// Create a copy of SalesCheckState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? groupedSalesFilters = freezed,
    Object? totalSalesFilters = freezed,
    Object? groupedSales = freezed,
    Object? totalSales = freezed,
    Object? error = freezed,
    Object? isLoading = null,
  }) {
    return _then(_SalesCheckState(
      groupedSalesFilters: freezed == groupedSalesFilters
          ? _self.groupedSalesFilters
          : groupedSalesFilters // ignore: cast_nullable_to_non_nullable
              as SalesCheckFilterDto?,
      totalSalesFilters: freezed == totalSalesFilters
          ? _self.totalSalesFilters
          : totalSalesFilters // ignore: cast_nullable_to_non_nullable
              as TotalSalesFilterDto?,
      groupedSales: freezed == groupedSales
          ? _self._groupedSales
          : groupedSales // ignore: cast_nullable_to_non_nullable
              as List<GroupedSalesCheckItem>?,
      totalSales: freezed == totalSales
          ? _self.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as TotalSalesCheck?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of SalesCheckState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TotalSalesCheckCopyWith<$Res>? get totalSales {
    if (_self.totalSales == null) {
      return null;
    }

    return $TotalSalesCheckCopyWith<$Res>(_self.totalSales!, (value) {
      return _then(_self.copyWith(totalSales: value));
    });
  }
}

// dart format on
