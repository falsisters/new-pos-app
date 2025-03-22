// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthState {
  CashierJwtModel? get cashier;
  bool get isAuthenticated;
  String? get error;
  bool get isLoading;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthStateCopyWith<AuthState> get copyWith =>
      _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);

  /// Serializes this AuthState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthState &&
            (identical(other.cashier, cashier) || other.cashier == cashier) &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, cashier, isAuthenticated, error, isLoading);

  @override
  String toString() {
    return 'AuthState(cashier: $cashier, isAuthenticated: $isAuthenticated, error: $error, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) =
      _$AuthStateCopyWithImpl;
  @useResult
  $Res call(
      {CashierJwtModel? cashier,
      bool isAuthenticated,
      String? error,
      bool isLoading});

  $CashierJwtModelCopyWith<$Res>? get cashier;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res> implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashier = freezed,
    Object? isAuthenticated = null,
    Object? error = freezed,
    Object? isLoading = null,
  }) {
    return _then(_self.copyWith(
      cashier: freezed == cashier
          ? _self.cashier
          : cashier // ignore: cast_nullable_to_non_nullable
              as CashierJwtModel?,
      isAuthenticated: null == isAuthenticated
          ? _self.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
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

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CashierJwtModelCopyWith<$Res>? get cashier {
    if (_self.cashier == null) {
      return null;
    }

    return $CashierJwtModelCopyWith<$Res>(_self.cashier!, (value) {
      return _then(_self.copyWith(cashier: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _AuthState implements AuthState {
  const _AuthState(
      {this.cashier,
      this.isAuthenticated = false,
      this.error,
      this.isLoading = false});
  factory _AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  @override
  final CashierJwtModel? cashier;
  @override
  @JsonKey()
  final bool isAuthenticated;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool isLoading;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthStateCopyWith<_AuthState> get copyWith =>
      __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthState &&
            (identical(other.cashier, cashier) || other.cashier == cashier) &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, cashier, isAuthenticated, error, isLoading);

  @override
  String toString() {
    return 'AuthState(cashier: $cashier, isAuthenticated: $isAuthenticated, error: $error, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(
          _AuthState value, $Res Function(_AuthState) _then) =
      __$AuthStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {CashierJwtModel? cashier,
      bool isAuthenticated,
      String? error,
      bool isLoading});

  @override
  $CashierJwtModelCopyWith<$Res>? get cashier;
}

/// @nodoc
class __$AuthStateCopyWithImpl<$Res> implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cashier = freezed,
    Object? isAuthenticated = null,
    Object? error = freezed,
    Object? isLoading = null,
  }) {
    return _then(_AuthState(
      cashier: freezed == cashier
          ? _self.cashier
          : cashier // ignore: cast_nullable_to_non_nullable
              as CashierJwtModel?,
      isAuthenticated: null == isAuthenticated
          ? _self.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
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

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CashierJwtModelCopyWith<$Res>? get cashier {
    if (_self.cashier == null) {
      return null;
    }

    return $CashierJwtModelCopyWith<$Res>(_self.cashier!, (value) {
      return _then(_self.copyWith(cashier: value));
    });
  }
}

// dart format on
