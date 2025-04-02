// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sheet_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SheetState {
  SheetModel? get sheet;
  String? get error;

  /// Create a copy of SheetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SheetStateCopyWith<SheetState> get copyWith =>
      _$SheetStateCopyWithImpl<SheetState>(this as SheetState, _$identity);

  /// Serializes this SheetState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SheetState &&
            (identical(other.sheet, sheet) || other.sheet == sheet) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sheet, error);

  @override
  String toString() {
    return 'SheetState(sheet: $sheet, error: $error)';
  }
}

/// @nodoc
abstract mixin class $SheetStateCopyWith<$Res> {
  factory $SheetStateCopyWith(
          SheetState value, $Res Function(SheetState) _then) =
      _$SheetStateCopyWithImpl;
  @useResult
  $Res call({SheetModel? sheet, String? error});

  $SheetModelCopyWith<$Res>? get sheet;
}

/// @nodoc
class _$SheetStateCopyWithImpl<$Res> implements $SheetStateCopyWith<$Res> {
  _$SheetStateCopyWithImpl(this._self, this._then);

  final SheetState _self;
  final $Res Function(SheetState) _then;

  /// Create a copy of SheetState
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
              as SheetModel?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of SheetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SheetModelCopyWith<$Res>? get sheet {
    if (_self.sheet == null) {
      return null;
    }

    return $SheetModelCopyWith<$Res>(_self.sheet!, (value) {
      return _then(_self.copyWith(sheet: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _SheetState implements SheetState {
  const _SheetState({this.sheet, this.error});
  factory _SheetState.fromJson(Map<String, dynamic> json) =>
      _$SheetStateFromJson(json);

  @override
  final SheetModel? sheet;
  @override
  final String? error;

  /// Create a copy of SheetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SheetStateCopyWith<_SheetState> get copyWith =>
      __$SheetStateCopyWithImpl<_SheetState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SheetStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SheetState &&
            (identical(other.sheet, sheet) || other.sheet == sheet) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sheet, error);

  @override
  String toString() {
    return 'SheetState(sheet: $sheet, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$SheetStateCopyWith<$Res>
    implements $SheetStateCopyWith<$Res> {
  factory _$SheetStateCopyWith(
          _SheetState value, $Res Function(_SheetState) _then) =
      __$SheetStateCopyWithImpl;
  @override
  @useResult
  $Res call({SheetModel? sheet, String? error});

  @override
  $SheetModelCopyWith<$Res>? get sheet;
}

/// @nodoc
class __$SheetStateCopyWithImpl<$Res> implements _$SheetStateCopyWith<$Res> {
  __$SheetStateCopyWithImpl(this._self, this._then);

  final _SheetState _self;
  final $Res Function(_SheetState) _then;

  /// Create a copy of SheetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sheet = freezed,
    Object? error = freezed,
  }) {
    return _then(_SheetState(
      sheet: freezed == sheet
          ? _self.sheet
          : sheet // ignore: cast_nullable_to_non_nullable
              as SheetModel?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of SheetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SheetModelCopyWith<$Res>? get sheet {
    if (_self.sheet == null) {
      return null;
    }

    return $SheetModelCopyWith<$Res>(_self.sheet!, (value) {
      return _then(_self.copyWith(sheet: value));
    });
  }
}

// dart format on
