// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expenses_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpensesState {
  InventorySheetModel? get sheet;
  String? get error;

  /// Create a copy of ExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpensesStateCopyWith<ExpensesState> get copyWith =>
      _$ExpensesStateCopyWithImpl<ExpensesState>(
          this as ExpensesState, _$identity);

  /// Serializes this ExpensesState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExpensesState &&
            (identical(other.sheet, sheet) || other.sheet == sheet) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sheet, error);

  @override
  String toString() {
    return 'ExpensesState(sheet: $sheet, error: $error)';
  }
}

/// @nodoc
abstract mixin class $ExpensesStateCopyWith<$Res> {
  factory $ExpensesStateCopyWith(
          ExpensesState value, $Res Function(ExpensesState) _then) =
      _$ExpensesStateCopyWithImpl;
  @useResult
  $Res call({InventorySheetModel? sheet, String? error});

  $InventorySheetModelCopyWith<$Res>? get sheet;
}

/// @nodoc
class _$ExpensesStateCopyWithImpl<$Res>
    implements $ExpensesStateCopyWith<$Res> {
  _$ExpensesStateCopyWithImpl(this._self, this._then);

  final ExpensesState _self;
  final $Res Function(ExpensesState) _then;

  /// Create a copy of ExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sheet = freezed,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      sheet: freezed == sheet
          ? _self.sheet
          : sheet // ignore: cast_nullable_to_non_nullable
              as InventorySheetModel?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of ExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InventorySheetModelCopyWith<$Res>? get sheet {
    if (_self.sheet == null) {
      return null;
    }

    return $InventorySheetModelCopyWith<$Res>(_self.sheet!, (value) {
      return _then(_self.copyWith(sheet: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _ExpensesState implements ExpensesState {
  const _ExpensesState({this.sheet, this.error});
  factory _ExpensesState.fromJson(Map<String, dynamic> json) =>
      _$ExpensesStateFromJson(json);

  @override
  final InventorySheetModel? sheet;
  @override
  final String? error;

  /// Create a copy of ExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpensesStateCopyWith<_ExpensesState> get copyWith =>
      __$ExpensesStateCopyWithImpl<_ExpensesState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExpensesStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExpensesState &&
            (identical(other.sheet, sheet) || other.sheet == sheet) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sheet, error);

  @override
  String toString() {
    return 'ExpensesState(sheet: $sheet, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$ExpensesStateCopyWith<$Res>
    implements $ExpensesStateCopyWith<$Res> {
  factory _$ExpensesStateCopyWith(
          _ExpensesState value, $Res Function(_ExpensesState) _then) =
      __$ExpensesStateCopyWithImpl;
  @override
  @useResult
  $Res call({InventorySheetModel? sheet, String? error});

  @override
  $InventorySheetModelCopyWith<$Res>? get sheet;
}

/// @nodoc
class __$ExpensesStateCopyWithImpl<$Res>
    implements _$ExpensesStateCopyWith<$Res> {
  __$ExpensesStateCopyWithImpl(this._self, this._then);

  final _ExpensesState _self;
  final $Res Function(_ExpensesState) _then;

  /// Create a copy of ExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sheet = freezed,
    Object? error = freezed,
  }) {
    return _then(_ExpensesState(
      sheet: freezed == sheet
          ? _self.sheet
          : sheet // ignore: cast_nullable_to_non_nullable
              as InventorySheetModel?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of ExpensesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InventorySheetModelCopyWith<$Res>? get sheet {
    if (_self.sheet == null) {
      return null;
    }

    return $InventorySheetModelCopyWith<$Res>(_self.sheet!, (value) {
      return _then(_self.copyWith(sheet: value));
    });
  }
}

// dart format on
