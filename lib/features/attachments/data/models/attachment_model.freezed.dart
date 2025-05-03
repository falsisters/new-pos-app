// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttachmentModel {
  String get id;
  String get name;
  String get url;
  AttachmentType get type;

  /// Create a copy of AttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AttachmentModelCopyWith<AttachmentModel> get copyWith =>
      _$AttachmentModelCopyWithImpl<AttachmentModel>(
          this as AttachmentModel, _$identity);

  /// Serializes this AttachmentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AttachmentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, url, type);

  @override
  String toString() {
    return 'AttachmentModel(id: $id, name: $name, url: $url, type: $type)';
  }
}

/// @nodoc
abstract mixin class $AttachmentModelCopyWith<$Res> {
  factory $AttachmentModelCopyWith(
          AttachmentModel value, $Res Function(AttachmentModel) _then) =
      _$AttachmentModelCopyWithImpl;
  @useResult
  $Res call({String id, String name, String url, AttachmentType type});
}

/// @nodoc
class _$AttachmentModelCopyWithImpl<$Res>
    implements $AttachmentModelCopyWith<$Res> {
  _$AttachmentModelCopyWithImpl(this._self, this._then);

  final AttachmentModel _self;
  final $Res Function(AttachmentModel) _then;

  /// Create a copy of AttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? type = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AttachmentType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AttachmentModel implements AttachmentModel {
  const _AttachmentModel(
      {required this.id,
      required this.name,
      required this.url,
      required this.type});
  factory _AttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$AttachmentModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String url;
  @override
  final AttachmentType type;

  /// Create a copy of AttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AttachmentModelCopyWith<_AttachmentModel> get copyWith =>
      __$AttachmentModelCopyWithImpl<_AttachmentModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AttachmentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AttachmentModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, url, type);

  @override
  String toString() {
    return 'AttachmentModel(id: $id, name: $name, url: $url, type: $type)';
  }
}

/// @nodoc
abstract mixin class _$AttachmentModelCopyWith<$Res>
    implements $AttachmentModelCopyWith<$Res> {
  factory _$AttachmentModelCopyWith(
          _AttachmentModel value, $Res Function(_AttachmentModel) _then) =
      __$AttachmentModelCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name, String url, AttachmentType type});
}

/// @nodoc
class __$AttachmentModelCopyWithImpl<$Res>
    implements _$AttachmentModelCopyWith<$Res> {
  __$AttachmentModelCopyWithImpl(this._self, this._then);

  final _AttachmentModel _self;
  final $Res Function(_AttachmentModel) _then;

  /// Create a copy of AttachmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? type = null,
  }) {
    return _then(_AttachmentModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AttachmentType,
    ));
  }
}

// dart format on
