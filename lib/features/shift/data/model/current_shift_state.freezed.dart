// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'current_shift_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CurrentShiftState {
  ShiftModel? get shift;
  bool get isShiftActive;
  String? get error;

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CurrentShiftStateCopyWith<CurrentShiftState> get copyWith =>
      _$CurrentShiftStateCopyWithImpl<CurrentShiftState>(
          this as CurrentShiftState, _$identity);

  /// Serializes this CurrentShiftState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CurrentShiftState &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.isShiftActive, isShiftActive) ||
                other.isShiftActive == isShiftActive) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, shift, isShiftActive, error);

  @override
  String toString() {
    return 'CurrentShiftState(shift: $shift, isShiftActive: $isShiftActive, error: $error)';
  }
}

/// @nodoc
abstract mixin class $CurrentShiftStateCopyWith<$Res> {
  factory $CurrentShiftStateCopyWith(
          CurrentShiftState value, $Res Function(CurrentShiftState) _then) =
      _$CurrentShiftStateCopyWithImpl;
  @useResult
  $Res call({ShiftModel? shift, bool isShiftActive, String? error});

  $ShiftModelCopyWith<$Res>? get shift;
}

/// @nodoc
class _$CurrentShiftStateCopyWithImpl<$Res>
    implements $CurrentShiftStateCopyWith<$Res> {
  _$CurrentShiftStateCopyWithImpl(this._self, this._then);

  final CurrentShiftState _self;
  final $Res Function(CurrentShiftState) _then;

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shift = freezed,
    Object? isShiftActive = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      shift: freezed == shift
          ? _self.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as ShiftModel?,
      isShiftActive: null == isShiftActive
          ? _self.isShiftActive
          : isShiftActive // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShiftModelCopyWith<$Res>? get shift {
    if (_self.shift == null) {
      return null;
    }

    return $ShiftModelCopyWith<$Res>(_self.shift!, (value) {
      return _then(_self.copyWith(shift: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _CurrentShiftState implements CurrentShiftState {
  const _CurrentShiftState(
      {this.shift, this.isShiftActive = false, this.error});
  factory _CurrentShiftState.fromJson(Map<String, dynamic> json) =>
      _$CurrentShiftStateFromJson(json);

  @override
  final ShiftModel? shift;
  @override
  @JsonKey()
  final bool isShiftActive;
  @override
  final String? error;

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CurrentShiftStateCopyWith<_CurrentShiftState> get copyWith =>
      __$CurrentShiftStateCopyWithImpl<_CurrentShiftState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CurrentShiftStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CurrentShiftState &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.isShiftActive, isShiftActive) ||
                other.isShiftActive == isShiftActive) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, shift, isShiftActive, error);

  @override
  String toString() {
    return 'CurrentShiftState(shift: $shift, isShiftActive: $isShiftActive, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$CurrentShiftStateCopyWith<$Res>
    implements $CurrentShiftStateCopyWith<$Res> {
  factory _$CurrentShiftStateCopyWith(
          _CurrentShiftState value, $Res Function(_CurrentShiftState) _then) =
      __$CurrentShiftStateCopyWithImpl;
  @override
  @useResult
  $Res call({ShiftModel? shift, bool isShiftActive, String? error});

  @override
  $ShiftModelCopyWith<$Res>? get shift;
}

/// @nodoc
class __$CurrentShiftStateCopyWithImpl<$Res>
    implements _$CurrentShiftStateCopyWith<$Res> {
  __$CurrentShiftStateCopyWithImpl(this._self, this._then);

  final _CurrentShiftState _self;
  final $Res Function(_CurrentShiftState) _then;

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? shift = freezed,
    Object? isShiftActive = null,
    Object? error = freezed,
  }) {
    return _then(_CurrentShiftState(
      shift: freezed == shift
          ? _self.shift
          : shift // ignore: cast_nullable_to_non_nullable
              as ShiftModel?,
      isShiftActive: null == isShiftActive
          ? _self.isShiftActive
          : isShiftActive // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of CurrentShiftState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShiftModelCopyWith<$Res>? get shift {
    if (_self.shift == null) {
      return null;
    }

    return $ShiftModelCopyWith<$Res>(_self.shift!, (value) {
      return _then(_self.copyWith(shift: value));
    });
  }
}

// dart format on
