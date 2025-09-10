// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseState {
  ExpenseList? get expenseList;
  bool get isLoading;
  String? get error;

  /// Create a copy of ExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpenseStateCopyWith<ExpenseState> get copyWith =>
      _$ExpenseStateCopyWithImpl<ExpenseState>(
          this as ExpenseState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExpenseState &&
            (identical(other.expenseList, expenseList) ||
                other.expenseList == expenseList) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, expenseList, isLoading, error);

  @override
  String toString() {
    return 'ExpenseState(expenseList: $expenseList, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class $ExpenseStateCopyWith<$Res> {
  factory $ExpenseStateCopyWith(
          ExpenseState value, $Res Function(ExpenseState) _then) =
      _$ExpenseStateCopyWithImpl;
  @useResult
  $Res call({ExpenseList? expenseList, bool isLoading, String? error});

  $ExpenseListCopyWith<$Res>? get expenseList;
}

/// @nodoc
class _$ExpenseStateCopyWithImpl<$Res> implements $ExpenseStateCopyWith<$Res> {
  _$ExpenseStateCopyWithImpl(this._self, this._then);

  final ExpenseState _self;
  final $Res Function(ExpenseState) _then;

  /// Create a copy of ExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expenseList = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      expenseList: freezed == expenseList
          ? _self.expenseList
          : expenseList // ignore: cast_nullable_to_non_nullable
              as ExpenseList?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of ExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExpenseListCopyWith<$Res>? get expenseList {
    if (_self.expenseList == null) {
      return null;
    }

    return $ExpenseListCopyWith<$Res>(_self.expenseList!, (value) {
      return _then(_self.copyWith(expenseList: value));
    });
  }
}

/// @nodoc

class _ExpenseState implements ExpenseState {
  const _ExpenseState({this.expenseList, this.isLoading = false, this.error});

  @override
  final ExpenseList? expenseList;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  /// Create a copy of ExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpenseStateCopyWith<_ExpenseState> get copyWith =>
      __$ExpenseStateCopyWithImpl<_ExpenseState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExpenseState &&
            (identical(other.expenseList, expenseList) ||
                other.expenseList == expenseList) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, expenseList, isLoading, error);

  @override
  String toString() {
    return 'ExpenseState(expenseList: $expenseList, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$ExpenseStateCopyWith<$Res>
    implements $ExpenseStateCopyWith<$Res> {
  factory _$ExpenseStateCopyWith(
          _ExpenseState value, $Res Function(_ExpenseState) _then) =
      __$ExpenseStateCopyWithImpl;
  @override
  @useResult
  $Res call({ExpenseList? expenseList, bool isLoading, String? error});

  @override
  $ExpenseListCopyWith<$Res>? get expenseList;
}

/// @nodoc
class __$ExpenseStateCopyWithImpl<$Res>
    implements _$ExpenseStateCopyWith<$Res> {
  __$ExpenseStateCopyWithImpl(this._self, this._then);

  final _ExpenseState _self;
  final $Res Function(_ExpenseState) _then;

  /// Create a copy of ExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? expenseList = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_ExpenseState(
      expenseList: freezed == expenseList
          ? _self.expenseList
          : expenseList // ignore: cast_nullable_to_non_nullable
              as ExpenseList?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of ExpenseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExpenseListCopyWith<$Res>? get expenseList {
    if (_self.expenseList == null) {
      return null;
    }

    return $ExpenseListCopyWith<$Res>(_self.expenseList!, (value) {
      return _then(_self.copyWith(expenseList: value));
    });
  }
}

// dart format on
