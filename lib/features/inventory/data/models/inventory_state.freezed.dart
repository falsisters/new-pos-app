// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryState {
  InventorySheetModel? get sheet;
  String? get error;

  /// Create a copy of InventoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InventoryStateCopyWith<InventoryState> get copyWith =>
      _$InventoryStateCopyWithImpl<InventoryState>(
          this as InventoryState, _$identity);

  /// Serializes this InventoryState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InventoryState &&
            (identical(other.sheet, sheet) || other.sheet == sheet) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sheet, error);

  @override
  String toString() {
    return 'InventoryState(sheet: $sheet, error: $error)';
  }
}

/// @nodoc
abstract mixin class $InventoryStateCopyWith<$Res> {
  factory $InventoryStateCopyWith(
          InventoryState value, $Res Function(InventoryState) _then) =
      _$InventoryStateCopyWithImpl;
  @useResult
  $Res call({InventorySheetModel? sheet, String? error});

  $InventorySheetModelCopyWith<$Res>? get sheet;
}

/// @nodoc
class _$InventoryStateCopyWithImpl<$Res>
    implements $InventoryStateCopyWith<$Res> {
  _$InventoryStateCopyWithImpl(this._self, this._then);

  final InventoryState _self;
  final $Res Function(InventoryState) _then;

  /// Create a copy of InventoryState
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

  /// Create a copy of InventoryState
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
class _InventoryState implements InventoryState {
  const _InventoryState({this.sheet, this.error});
  factory _InventoryState.fromJson(Map<String, dynamic> json) =>
      _$InventoryStateFromJson(json);

  @override
  final InventorySheetModel? sheet;
  @override
  final String? error;

  /// Create a copy of InventoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InventoryStateCopyWith<_InventoryState> get copyWith =>
      __$InventoryStateCopyWithImpl<_InventoryState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InventoryStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InventoryState &&
            (identical(other.sheet, sheet) || other.sheet == sheet) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sheet, error);

  @override
  String toString() {
    return 'InventoryState(sheet: $sheet, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$InventoryStateCopyWith<$Res>
    implements $InventoryStateCopyWith<$Res> {
  factory _$InventoryStateCopyWith(
          _InventoryState value, $Res Function(_InventoryState) _then) =
      __$InventoryStateCopyWithImpl;
  @override
  @useResult
  $Res call({InventorySheetModel? sheet, String? error});

  @override
  $InventorySheetModelCopyWith<$Res>? get sheet;
}

/// @nodoc
class __$InventoryStateCopyWithImpl<$Res>
    implements _$InventoryStateCopyWith<$Res> {
  __$InventoryStateCopyWithImpl(this._self, this._then);

  final _InventoryState _self;
  final $Res Function(_InventoryState) _then;

  /// Create a copy of InventoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sheet = freezed,
    Object? error = freezed,
  }) {
    return _then(_InventoryState(
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

  /// Create a copy of InventoryState
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
