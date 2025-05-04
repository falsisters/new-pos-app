// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_count_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillCountState {
  BillCountModel? get billCount;
  String? get error;

  /// Create a copy of BillCountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BillCountStateCopyWith<BillCountState> get copyWith =>
      _$BillCountStateCopyWithImpl<BillCountState>(
          this as BillCountState, _$identity);

  /// Serializes this BillCountState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BillCountState &&
            (identical(other.billCount, billCount) ||
                other.billCount == billCount) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, billCount, error);

  @override
  String toString() {
    return 'BillCountState(billCount: $billCount, error: $error)';
  }
}

/// @nodoc
abstract mixin class $BillCountStateCopyWith<$Res> {
  factory $BillCountStateCopyWith(
          BillCountState value, $Res Function(BillCountState) _then) =
      _$BillCountStateCopyWithImpl;
  @useResult
  $Res call({BillCountModel? billCount, String? error});

  $BillCountModelCopyWith<$Res>? get billCount;
}

/// @nodoc
class _$BillCountStateCopyWithImpl<$Res>
    implements $BillCountStateCopyWith<$Res> {
  _$BillCountStateCopyWithImpl(this._self, this._then);

  final BillCountState _self;
  final $Res Function(BillCountState) _then;

  /// Create a copy of BillCountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billCount = freezed,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      billCount: freezed == billCount
          ? _self.billCount
          : billCount // ignore: cast_nullable_to_non_nullable
              as BillCountModel?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of BillCountState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BillCountModelCopyWith<$Res>? get billCount {
    if (_self.billCount == null) {
      return null;
    }

    return $BillCountModelCopyWith<$Res>(_self.billCount!, (value) {
      return _then(_self.copyWith(billCount: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _BillCountState implements BillCountState {
  const _BillCountState({this.billCount, this.error});
  factory _BillCountState.fromJson(Map<String, dynamic> json) =>
      _$BillCountStateFromJson(json);

  @override
  final BillCountModel? billCount;
  @override
  final String? error;

  /// Create a copy of BillCountState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BillCountStateCopyWith<_BillCountState> get copyWith =>
      __$BillCountStateCopyWithImpl<_BillCountState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BillCountStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BillCountState &&
            (identical(other.billCount, billCount) ||
                other.billCount == billCount) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, billCount, error);

  @override
  String toString() {
    return 'BillCountState(billCount: $billCount, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$BillCountStateCopyWith<$Res>
    implements $BillCountStateCopyWith<$Res> {
  factory _$BillCountStateCopyWith(
          _BillCountState value, $Res Function(_BillCountState) _then) =
      __$BillCountStateCopyWithImpl;
  @override
  @useResult
  $Res call({BillCountModel? billCount, String? error});

  @override
  $BillCountModelCopyWith<$Res>? get billCount;
}

/// @nodoc
class __$BillCountStateCopyWithImpl<$Res>
    implements _$BillCountStateCopyWith<$Res> {
  __$BillCountStateCopyWithImpl(this._self, this._then);

  final _BillCountState _self;
  final $Res Function(_BillCountState) _then;

  /// Create a copy of BillCountState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? billCount = freezed,
    Object? error = freezed,
  }) {
    return _then(_BillCountState(
      billCount: freezed == billCount
          ? _self.billCount
          : billCount // ignore: cast_nullable_to_non_nullable
              as BillCountModel?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of BillCountState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BillCountModelCopyWith<$Res>? get billCount {
    if (_self.billCount == null) {
      return null;
    }

    return $BillCountModelCopyWith<$Res>(_self.billCount!, (value) {
      return _then(_self.copyWith(billCount: value));
    });
  }
}

// dart format on
