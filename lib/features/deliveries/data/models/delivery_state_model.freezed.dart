// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryStateModel {
  TruckModel get truck;
  String? get error;

  /// Create a copy of DeliveryStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeliveryStateModelCopyWith<DeliveryStateModel> get copyWith =>
      _$DeliveryStateModelCopyWithImpl<DeliveryStateModel>(
          this as DeliveryStateModel, _$identity);

  /// Serializes this DeliveryStateModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeliveryStateModel &&
            (identical(other.truck, truck) || other.truck == truck) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, truck, error);

  @override
  String toString() {
    return 'DeliveryStateModel(truck: $truck, error: $error)';
  }
}

/// @nodoc
abstract mixin class $DeliveryStateModelCopyWith<$Res> {
  factory $DeliveryStateModelCopyWith(
          DeliveryStateModel value, $Res Function(DeliveryStateModel) _then) =
      _$DeliveryStateModelCopyWithImpl;
  @useResult
  $Res call({TruckModel truck, String? error});

  $TruckModelCopyWith<$Res> get truck;
}

/// @nodoc
class _$DeliveryStateModelCopyWithImpl<$Res>
    implements $DeliveryStateModelCopyWith<$Res> {
  _$DeliveryStateModelCopyWithImpl(this._self, this._then);

  final DeliveryStateModel _self;
  final $Res Function(DeliveryStateModel) _then;

  /// Create a copy of DeliveryStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? truck = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      truck: null == truck
          ? _self.truck
          : truck // ignore: cast_nullable_to_non_nullable
              as TruckModel,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of DeliveryStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TruckModelCopyWith<$Res> get truck {
    return $TruckModelCopyWith<$Res>(_self.truck, (value) {
      return _then(_self.copyWith(truck: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _DeliveryStateModel implements DeliveryStateModel {
  const _DeliveryStateModel({required this.truck, this.error});
  factory _DeliveryStateModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryStateModelFromJson(json);

  @override
  final TruckModel truck;
  @override
  final String? error;

  /// Create a copy of DeliveryStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeliveryStateModelCopyWith<_DeliveryStateModel> get copyWith =>
      __$DeliveryStateModelCopyWithImpl<_DeliveryStateModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeliveryStateModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeliveryStateModel &&
            (identical(other.truck, truck) || other.truck == truck) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, truck, error);

  @override
  String toString() {
    return 'DeliveryStateModel(truck: $truck, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$DeliveryStateModelCopyWith<$Res>
    implements $DeliveryStateModelCopyWith<$Res> {
  factory _$DeliveryStateModelCopyWith(
          _DeliveryStateModel value, $Res Function(_DeliveryStateModel) _then) =
      __$DeliveryStateModelCopyWithImpl;
  @override
  @useResult
  $Res call({TruckModel truck, String? error});

  @override
  $TruckModelCopyWith<$Res> get truck;
}

/// @nodoc
class __$DeliveryStateModelCopyWithImpl<$Res>
    implements _$DeliveryStateModelCopyWith<$Res> {
  __$DeliveryStateModelCopyWithImpl(this._self, this._then);

  final _DeliveryStateModel _self;
  final $Res Function(_DeliveryStateModel) _then;

  /// Create a copy of DeliveryStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? truck = null,
    Object? error = freezed,
  }) {
    return _then(_DeliveryStateModel(
      truck: null == truck
          ? _self.truck
          : truck // ignore: cast_nullable_to_non_nullable
              as TruckModel,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of DeliveryStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TruckModelCopyWith<$Res> get truck {
    return $TruckModelCopyWith<$Res>(_self.truck, (value) {
      return _then(_self.copyWith(truck: value));
    });
  }
}

// dart format on
