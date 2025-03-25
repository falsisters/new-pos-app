// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_per_kilo_price_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditPerKiloPriceRequest {
  EditPerKiloPriceDto get perKiloPrice;

  /// Create a copy of EditPerKiloPriceRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EditPerKiloPriceRequestCopyWith<EditPerKiloPriceRequest> get copyWith =>
      _$EditPerKiloPriceRequestCopyWithImpl<EditPerKiloPriceRequest>(
          this as EditPerKiloPriceRequest, _$identity);

  /// Serializes this EditPerKiloPriceRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EditPerKiloPriceRequest &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, perKiloPrice);

  @override
  String toString() {
    return 'EditPerKiloPriceRequest(perKiloPrice: $perKiloPrice)';
  }
}

/// @nodoc
abstract mixin class $EditPerKiloPriceRequestCopyWith<$Res> {
  factory $EditPerKiloPriceRequestCopyWith(EditPerKiloPriceRequest value,
          $Res Function(EditPerKiloPriceRequest) _then) =
      _$EditPerKiloPriceRequestCopyWithImpl;
  @useResult
  $Res call({EditPerKiloPriceDto perKiloPrice});

  $EditPerKiloPriceDtoCopyWith<$Res> get perKiloPrice;
}

/// @nodoc
class _$EditPerKiloPriceRequestCopyWithImpl<$Res>
    implements $EditPerKiloPriceRequestCopyWith<$Res> {
  _$EditPerKiloPriceRequestCopyWithImpl(this._self, this._then);

  final EditPerKiloPriceRequest _self;
  final $Res Function(EditPerKiloPriceRequest) _then;

  /// Create a copy of EditPerKiloPriceRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? perKiloPrice = null,
  }) {
    return _then(_self.copyWith(
      perKiloPrice: null == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as EditPerKiloPriceDto,
    ));
  }

  /// Create a copy of EditPerKiloPriceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EditPerKiloPriceDtoCopyWith<$Res> get perKiloPrice {
    return $EditPerKiloPriceDtoCopyWith<$Res>(_self.perKiloPrice, (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _EditPerKiloPriceRequest implements EditPerKiloPriceRequest {
  const _EditPerKiloPriceRequest({required this.perKiloPrice});
  factory _EditPerKiloPriceRequest.fromJson(Map<String, dynamic> json) =>
      _$EditPerKiloPriceRequestFromJson(json);

  @override
  final EditPerKiloPriceDto perKiloPrice;

  /// Create a copy of EditPerKiloPriceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EditPerKiloPriceRequestCopyWith<_EditPerKiloPriceRequest> get copyWith =>
      __$EditPerKiloPriceRequestCopyWithImpl<_EditPerKiloPriceRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EditPerKiloPriceRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EditPerKiloPriceRequest &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, perKiloPrice);

  @override
  String toString() {
    return 'EditPerKiloPriceRequest(perKiloPrice: $perKiloPrice)';
  }
}

/// @nodoc
abstract mixin class _$EditPerKiloPriceRequestCopyWith<$Res>
    implements $EditPerKiloPriceRequestCopyWith<$Res> {
  factory _$EditPerKiloPriceRequestCopyWith(_EditPerKiloPriceRequest value,
          $Res Function(_EditPerKiloPriceRequest) _then) =
      __$EditPerKiloPriceRequestCopyWithImpl;
  @override
  @useResult
  $Res call({EditPerKiloPriceDto perKiloPrice});

  @override
  $EditPerKiloPriceDtoCopyWith<$Res> get perKiloPrice;
}

/// @nodoc
class __$EditPerKiloPriceRequestCopyWithImpl<$Res>
    implements _$EditPerKiloPriceRequestCopyWith<$Res> {
  __$EditPerKiloPriceRequestCopyWithImpl(this._self, this._then);

  final _EditPerKiloPriceRequest _self;
  final $Res Function(_EditPerKiloPriceRequest) _then;

  /// Create a copy of EditPerKiloPriceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? perKiloPrice = null,
  }) {
    return _then(_EditPerKiloPriceRequest(
      perKiloPrice: null == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as EditPerKiloPriceDto,
    ));
  }

  /// Create a copy of EditPerKiloPriceRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EditPerKiloPriceDtoCopyWith<$Res> get perKiloPrice {
    return $EditPerKiloPriceDtoCopyWith<$Res>(_self.perKiloPrice, (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }
}

// dart format on
