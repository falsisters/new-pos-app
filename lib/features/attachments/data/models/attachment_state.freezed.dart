// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttachmentState {
  List<AttachmentModel> get attachments;
  String? get error;

  /// Create a copy of AttachmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AttachmentStateCopyWith<AttachmentState> get copyWith =>
      _$AttachmentStateCopyWithImpl<AttachmentState>(
          this as AttachmentState, _$identity);

  /// Serializes this AttachmentState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AttachmentState &&
            const DeepCollectionEquality()
                .equals(other.attachments, attachments) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(attachments), error);

  @override
  String toString() {
    return 'AttachmentState(attachments: $attachments, error: $error)';
  }
}

/// @nodoc
abstract mixin class $AttachmentStateCopyWith<$Res> {
  factory $AttachmentStateCopyWith(
          AttachmentState value, $Res Function(AttachmentState) _then) =
      _$AttachmentStateCopyWithImpl;
  @useResult
  $Res call({List<AttachmentModel> attachments, String? error});
}

/// @nodoc
class _$AttachmentStateCopyWithImpl<$Res>
    implements $AttachmentStateCopyWith<$Res> {
  _$AttachmentStateCopyWithImpl(this._self, this._then);

  final AttachmentState _self;
  final $Res Function(AttachmentState) _then;

  /// Create a copy of AttachmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachments = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      attachments: null == attachments
          ? _self.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<AttachmentModel>,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AttachmentState implements AttachmentState {
  const _AttachmentState(
      {required final List<AttachmentModel> attachments, this.error})
      : _attachments = attachments;
  factory _AttachmentState.fromJson(Map<String, dynamic> json) =>
      _$AttachmentStateFromJson(json);

  final List<AttachmentModel> _attachments;
  @override
  List<AttachmentModel> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final String? error;

  /// Create a copy of AttachmentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AttachmentStateCopyWith<_AttachmentState> get copyWith =>
      __$AttachmentStateCopyWithImpl<_AttachmentState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AttachmentStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AttachmentState &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_attachments), error);

  @override
  String toString() {
    return 'AttachmentState(attachments: $attachments, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$AttachmentStateCopyWith<$Res>
    implements $AttachmentStateCopyWith<$Res> {
  factory _$AttachmentStateCopyWith(
          _AttachmentState value, $Res Function(_AttachmentState) _then) =
      __$AttachmentStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<AttachmentModel> attachments, String? error});
}

/// @nodoc
class __$AttachmentStateCopyWithImpl<$Res>
    implements _$AttachmentStateCopyWith<$Res> {
  __$AttachmentStateCopyWithImpl(this._self, this._then);

  final _AttachmentState _self;
  final $Res Function(_AttachmentState) _then;

  /// Create a copy of AttachmentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? attachments = null,
    Object? error = freezed,
  }) {
    return _then(_AttachmentState(
      attachments: null == attachments
          ? _self._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<AttachmentModel>,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
