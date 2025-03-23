// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_delivery_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateDeliveryRequestModel {
  String get driverName;
  DateTime get deliveryTimeStart;
  @JsonKey(name: 'deliveryItem')
  List<DeliveryProductDtoModel> get deliveryItems;

  /// Create a copy of CreateDeliveryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateDeliveryRequestModelCopyWith<CreateDeliveryRequestModel>
      get copyWith =>
          _$CreateDeliveryRequestModelCopyWithImpl<CreateDeliveryRequestModel>(
              this as CreateDeliveryRequestModel, _$identity);

  /// Serializes this CreateDeliveryRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateDeliveryRequestModel &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.deliveryTimeStart, deliveryTimeStart) ||
                other.deliveryTimeStart == deliveryTimeStart) &&
            const DeepCollectionEquality()
                .equals(other.deliveryItems, deliveryItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, driverName, deliveryTimeStart,
      const DeepCollectionEquality().hash(deliveryItems));

  @override
  String toString() {
    return 'CreateDeliveryRequestModel(driverName: $driverName, deliveryTimeStart: $deliveryTimeStart, deliveryItems: $deliveryItems)';
  }
}

/// @nodoc
abstract mixin class $CreateDeliveryRequestModelCopyWith<$Res> {
  factory $CreateDeliveryRequestModelCopyWith(CreateDeliveryRequestModel value,
          $Res Function(CreateDeliveryRequestModel) _then) =
      _$CreateDeliveryRequestModelCopyWithImpl;
  @useResult
  $Res call(
      {String driverName,
      DateTime deliveryTimeStart,
      @JsonKey(name: 'deliveryItem')
      List<DeliveryProductDtoModel> deliveryItems});
}

/// @nodoc
class _$CreateDeliveryRequestModelCopyWithImpl<$Res>
    implements $CreateDeliveryRequestModelCopyWith<$Res> {
  _$CreateDeliveryRequestModelCopyWithImpl(this._self, this._then);

  final CreateDeliveryRequestModel _self;
  final $Res Function(CreateDeliveryRequestModel) _then;

  /// Create a copy of CreateDeliveryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? driverName = null,
    Object? deliveryTimeStart = null,
    Object? deliveryItems = null,
  }) {
    return _then(_self.copyWith(
      driverName: null == driverName
          ? _self.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryTimeStart: null == deliveryTimeStart
          ? _self.deliveryTimeStart
          : deliveryTimeStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deliveryItems: null == deliveryItems
          ? _self.deliveryItems
          : deliveryItems // ignore: cast_nullable_to_non_nullable
              as List<DeliveryProductDtoModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CreateDeliveryRequestModel implements CreateDeliveryRequestModel {
  const _CreateDeliveryRequestModel(
      {required this.driverName,
      required this.deliveryTimeStart,
      @JsonKey(name: 'deliveryItem')
      required final List<DeliveryProductDtoModel> deliveryItems})
      : _deliveryItems = deliveryItems;
  factory _CreateDeliveryRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateDeliveryRequestModelFromJson(json);

  @override
  final String driverName;
  @override
  final DateTime deliveryTimeStart;
  final List<DeliveryProductDtoModel> _deliveryItems;
  @override
  @JsonKey(name: 'deliveryItem')
  List<DeliveryProductDtoModel> get deliveryItems {
    if (_deliveryItems is EqualUnmodifiableListView) return _deliveryItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deliveryItems);
  }

  /// Create a copy of CreateDeliveryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateDeliveryRequestModelCopyWith<_CreateDeliveryRequestModel>
      get copyWith => __$CreateDeliveryRequestModelCopyWithImpl<
          _CreateDeliveryRequestModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateDeliveryRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateDeliveryRequestModel &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.deliveryTimeStart, deliveryTimeStart) ||
                other.deliveryTimeStart == deliveryTimeStart) &&
            const DeepCollectionEquality()
                .equals(other._deliveryItems, _deliveryItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, driverName, deliveryTimeStart,
      const DeepCollectionEquality().hash(_deliveryItems));

  @override
  String toString() {
    return 'CreateDeliveryRequestModel(driverName: $driverName, deliveryTimeStart: $deliveryTimeStart, deliveryItems: $deliveryItems)';
  }
}

/// @nodoc
abstract mixin class _$CreateDeliveryRequestModelCopyWith<$Res>
    implements $CreateDeliveryRequestModelCopyWith<$Res> {
  factory _$CreateDeliveryRequestModelCopyWith(
          _CreateDeliveryRequestModel value,
          $Res Function(_CreateDeliveryRequestModel) _then) =
      __$CreateDeliveryRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String driverName,
      DateTime deliveryTimeStart,
      @JsonKey(name: 'deliveryItem')
      List<DeliveryProductDtoModel> deliveryItems});
}

/// @nodoc
class __$CreateDeliveryRequestModelCopyWithImpl<$Res>
    implements _$CreateDeliveryRequestModelCopyWith<$Res> {
  __$CreateDeliveryRequestModelCopyWithImpl(this._self, this._then);

  final _CreateDeliveryRequestModel _self;
  final $Res Function(_CreateDeliveryRequestModel) _then;

  /// Create a copy of CreateDeliveryRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? driverName = null,
    Object? deliveryTimeStart = null,
    Object? deliveryItems = null,
  }) {
    return _then(_CreateDeliveryRequestModel(
      driverName: null == driverName
          ? _self.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryTimeStart: null == deliveryTimeStart
          ? _self.deliveryTimeStart
          : deliveryTimeStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deliveryItems: null == deliveryItems
          ? _self._deliveryItems
          : deliveryItems // ignore: cast_nullable_to_non_nullable
              as List<DeliveryProductDtoModel>,
    ));
  }
}

// dart format on
