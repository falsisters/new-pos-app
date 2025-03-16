// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_shift_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateShiftRequestModel {
  List<String> get employees;

  /// Create a copy of CreateShiftRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateShiftRequestModelCopyWith<CreateShiftRequestModel> get copyWith =>
      _$CreateShiftRequestModelCopyWithImpl<CreateShiftRequestModel>(
          this as CreateShiftRequestModel, _$identity);

  /// Serializes this CreateShiftRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateShiftRequestModel &&
            const DeepCollectionEquality().equals(other.employees, employees));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(employees));

  @override
  String toString() {
    return 'CreateShiftRequestModel(employees: $employees)';
  }
}

/// @nodoc
abstract mixin class $CreateShiftRequestModelCopyWith<$Res> {
  factory $CreateShiftRequestModelCopyWith(CreateShiftRequestModel value,
          $Res Function(CreateShiftRequestModel) _then) =
      _$CreateShiftRequestModelCopyWithImpl;
  @useResult
  $Res call({List<String> employees});
}

/// @nodoc
class _$CreateShiftRequestModelCopyWithImpl<$Res>
    implements $CreateShiftRequestModelCopyWith<$Res> {
  _$CreateShiftRequestModelCopyWithImpl(this._self, this._then);

  final CreateShiftRequestModel _self;
  final $Res Function(CreateShiftRequestModel) _then;

  /// Create a copy of CreateShiftRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employees = null,
  }) {
    return _then(_self.copyWith(
      employees: null == employees
          ? _self.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CreateShiftRequestModel implements CreateShiftRequestModel {
  const _CreateShiftRequestModel({required final List<String> employees})
      : _employees = employees;
  factory _CreateShiftRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateShiftRequestModelFromJson(json);

  final List<String> _employees;
  @override
  List<String> get employees {
    if (_employees is EqualUnmodifiableListView) return _employees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employees);
  }

  /// Create a copy of CreateShiftRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateShiftRequestModelCopyWith<_CreateShiftRequestModel> get copyWith =>
      __$CreateShiftRequestModelCopyWithImpl<_CreateShiftRequestModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateShiftRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateShiftRequestModel &&
            const DeepCollectionEquality()
                .equals(other._employees, _employees));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_employees));

  @override
  String toString() {
    return 'CreateShiftRequestModel(employees: $employees)';
  }
}

/// @nodoc
abstract mixin class _$CreateShiftRequestModelCopyWith<$Res>
    implements $CreateShiftRequestModelCopyWith<$Res> {
  factory _$CreateShiftRequestModelCopyWith(_CreateShiftRequestModel value,
          $Res Function(_CreateShiftRequestModel) _then) =
      __$CreateShiftRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<String> employees});
}

/// @nodoc
class __$CreateShiftRequestModelCopyWithImpl<$Res>
    implements _$CreateShiftRequestModelCopyWith<$Res> {
  __$CreateShiftRequestModelCopyWithImpl(this._self, this._then);

  final _CreateShiftRequestModel _self;
  final $Res Function(_CreateShiftRequestModel) _then;

  /// Create a copy of CreateShiftRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? employees = null,
  }) {
    return _then(_CreateShiftRequestModel(
      employees: null == employees
          ? _self._employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
