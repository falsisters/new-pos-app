// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferState {
  List<TransferModel> get transferList;
  bool get isLoading;
  String? get error;
  DateTime? get selectedDate;

  /// Create a copy of TransferState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransferStateCopyWith<TransferState> get copyWith =>
      _$TransferStateCopyWithImpl<TransferState>(
          this as TransferState, _$identity);

  /// Serializes this TransferState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransferState &&
            const DeepCollectionEquality()
                .equals(other.transferList, transferList) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(transferList),
      isLoading,
      error,
      selectedDate);

  @override
  String toString() {
    return 'TransferState(transferList: $transferList, isLoading: $isLoading, error: $error, selectedDate: $selectedDate)';
  }
}

/// @nodoc
abstract mixin class $TransferStateCopyWith<$Res> {
  factory $TransferStateCopyWith(
          TransferState value, $Res Function(TransferState) _then) =
      _$TransferStateCopyWithImpl;
  @useResult
  $Res call(
      {List<TransferModel> transferList,
      bool isLoading,
      String? error,
      DateTime? selectedDate});
}

/// @nodoc
class _$TransferStateCopyWithImpl<$Res>
    implements $TransferStateCopyWith<$Res> {
  _$TransferStateCopyWithImpl(this._self, this._then);

  final TransferState _self;
  final $Res Function(TransferState) _then;

  /// Create a copy of TransferState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferList = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedDate = freezed,
  }) {
    return _then(_self.copyWith(
      transferList: null == transferList
          ? _self.transferList
          : transferList // ignore: cast_nullable_to_non_nullable
              as List<TransferModel>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDate: freezed == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TransferState implements TransferState {
  const _TransferState(
      {final List<TransferModel> transferList = const [],
      this.isLoading = false,
      this.error,
      this.selectedDate})
      : _transferList = transferList;
  factory _TransferState.fromJson(Map<String, dynamic> json) =>
      _$TransferStateFromJson(json);

  final List<TransferModel> _transferList;
  @override
  @JsonKey()
  List<TransferModel> get transferList {
    if (_transferList is EqualUnmodifiableListView) return _transferList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transferList);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final DateTime? selectedDate;

  /// Create a copy of TransferState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransferStateCopyWith<_TransferState> get copyWith =>
      __$TransferStateCopyWithImpl<_TransferState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransferStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransferState &&
            const DeepCollectionEquality()
                .equals(other._transferList, _transferList) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_transferList),
      isLoading,
      error,
      selectedDate);

  @override
  String toString() {
    return 'TransferState(transferList: $transferList, isLoading: $isLoading, error: $error, selectedDate: $selectedDate)';
  }
}

/// @nodoc
abstract mixin class _$TransferStateCopyWith<$Res>
    implements $TransferStateCopyWith<$Res> {
  factory _$TransferStateCopyWith(
          _TransferState value, $Res Function(_TransferState) _then) =
      __$TransferStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<TransferModel> transferList,
      bool isLoading,
      String? error,
      DateTime? selectedDate});
}

/// @nodoc
class __$TransferStateCopyWithImpl<$Res>
    implements _$TransferStateCopyWith<$Res> {
  __$TransferStateCopyWithImpl(this._self, this._then);

  final _TransferState _self;
  final $Res Function(_TransferState) _then;

  /// Create a copy of TransferState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? transferList = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedDate = freezed,
  }) {
    return _then(_TransferState(
      transferList: null == transferList
          ? _self._transferList
          : transferList // ignore: cast_nullable_to_non_nullable
              as List<TransferModel>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDate: freezed == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
