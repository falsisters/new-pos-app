// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profits_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfitsState {
// Filter
  ProfitFilterDto? get filters; // Result
  ProfitResponse? get profitResponse; // Status
  String? get error;
  bool get isLoading;

  /// Create a copy of ProfitsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfitsStateCopyWith<ProfitsState> get copyWith =>
      _$ProfitsStateCopyWithImpl<ProfitsState>(
          this as ProfitsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfitsState &&
            (identical(other.filters, filters) || other.filters == filters) &&
            (identical(other.profitResponse, profitResponse) ||
                other.profitResponse == profitResponse) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, filters, profitResponse, error, isLoading);

  @override
  String toString() {
    return 'ProfitsState(filters: $filters, profitResponse: $profitResponse, error: $error, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class $ProfitsStateCopyWith<$Res> {
  factory $ProfitsStateCopyWith(
          ProfitsState value, $Res Function(ProfitsState) _then) =
      _$ProfitsStateCopyWithImpl;
  @useResult
  $Res call(
      {ProfitFilterDto? filters,
      ProfitResponse? profitResponse,
      String? error,
      bool isLoading});

  $ProfitResponseCopyWith<$Res>? get profitResponse;
}

/// @nodoc
class _$ProfitsStateCopyWithImpl<$Res> implements $ProfitsStateCopyWith<$Res> {
  _$ProfitsStateCopyWithImpl(this._self, this._then);

  final ProfitsState _self;
  final $Res Function(ProfitsState) _then;

  /// Create a copy of ProfitsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filters = freezed,
    Object? profitResponse = freezed,
    Object? error = freezed,
    Object? isLoading = null,
  }) {
    return _then(_self.copyWith(
      filters: freezed == filters
          ? _self.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as ProfitFilterDto?,
      profitResponse: freezed == profitResponse
          ? _self.profitResponse
          : profitResponse // ignore: cast_nullable_to_non_nullable
              as ProfitResponse?,
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

  /// Create a copy of ProfitsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfitResponseCopyWith<$Res>? get profitResponse {
    if (_self.profitResponse == null) {
      return null;
    }

    return $ProfitResponseCopyWith<$Res>(_self.profitResponse!, (value) {
      return _then(_self.copyWith(profitResponse: value));
    });
  }
}

/// @nodoc

class _ProfitsState implements ProfitsState {
  const _ProfitsState(
      {this.filters, this.profitResponse, this.error, this.isLoading = false});

// Filter
  @override
  final ProfitFilterDto? filters;
// Result
  @override
  final ProfitResponse? profitResponse;
// Status
  @override
  final String? error;
  @override
  @JsonKey()
  final bool isLoading;

  /// Create a copy of ProfitsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfitsStateCopyWith<_ProfitsState> get copyWith =>
      __$ProfitsStateCopyWithImpl<_ProfitsState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfitsState &&
            (identical(other.filters, filters) || other.filters == filters) &&
            (identical(other.profitResponse, profitResponse) ||
                other.profitResponse == profitResponse) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, filters, profitResponse, error, isLoading);

  @override
  String toString() {
    return 'ProfitsState(filters: $filters, profitResponse: $profitResponse, error: $error, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class _$ProfitsStateCopyWith<$Res>
    implements $ProfitsStateCopyWith<$Res> {
  factory _$ProfitsStateCopyWith(
          _ProfitsState value, $Res Function(_ProfitsState) _then) =
      __$ProfitsStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ProfitFilterDto? filters,
      ProfitResponse? profitResponse,
      String? error,
      bool isLoading});

  @override
  $ProfitResponseCopyWith<$Res>? get profitResponse;
}

/// @nodoc
class __$ProfitsStateCopyWithImpl<$Res>
    implements _$ProfitsStateCopyWith<$Res> {
  __$ProfitsStateCopyWithImpl(this._self, this._then);

  final _ProfitsState _self;
  final $Res Function(_ProfitsState) _then;

  /// Create a copy of ProfitsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? filters = freezed,
    Object? profitResponse = freezed,
    Object? error = freezed,
    Object? isLoading = null,
  }) {
    return _then(_ProfitsState(
      filters: freezed == filters
          ? _self.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as ProfitFilterDto?,
      profitResponse: freezed == profitResponse
          ? _self.profitResponse
          : profitResponse // ignore: cast_nullable_to_non_nullable
              as ProfitResponse?,
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

  /// Create a copy of ProfitsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfitResponseCopyWith<$Res>? get profitResponse {
    if (_self.profitResponse == null) {
      return null;
    }

    return $ProfitResponseCopyWith<$Res>(_self.profitResponse!, (value) {
      return _then(_self.copyWith(profitResponse: value));
    });
  }
}

// dart format on
