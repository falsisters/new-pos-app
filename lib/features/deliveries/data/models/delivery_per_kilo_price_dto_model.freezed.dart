// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_per_kilo_price_dto_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryPerKiloPriceDtoModel {
  String get id;
  double get quantity;

  /// Create a copy of DeliveryPerKiloPriceDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeliveryPerKiloPriceDtoModelCopyWith<DeliveryPerKiloPriceDtoModel>
      get copyWith => _$DeliveryPerKiloPriceDtoModelCopyWithImpl<
              DeliveryPerKiloPriceDtoModel>(
          this as DeliveryPerKiloPriceDtoModel, _$identity);

  /// Serializes this DeliveryPerKiloPriceDtoModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeliveryPerKiloPriceDtoModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, quantity);

  @override
  String toString() {
    return 'DeliveryPerKiloPriceDtoModel(id: $id, quantity: $quantity)';
  }
}

/// @nodoc
abstract mixin class $DeliveryPerKiloPriceDtoModelCopyWith<$Res> {
  factory $DeliveryPerKiloPriceDtoModelCopyWith(
          DeliveryPerKiloPriceDtoModel value,
          $Res Function(DeliveryPerKiloPriceDtoModel) _then) =
      _$DeliveryPerKiloPriceDtoModelCopyWithImpl;
  @useResult
  $Res call({String id, double quantity});
}

/// @nodoc
class _$DeliveryPerKiloPriceDtoModelCopyWithImpl<$Res>
    implements $DeliveryPerKiloPriceDtoModelCopyWith<$Res> {
  _$DeliveryPerKiloPriceDtoModelCopyWithImpl(this._self, this._then);

  final DeliveryPerKiloPriceDtoModel _self;
  final $Res Function(DeliveryPerKiloPriceDtoModel) _then;

  /// Create a copy of DeliveryPerKiloPriceDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _DeliveryPerKiloPriceDtoModel implements DeliveryPerKiloPriceDtoModel {
  const _DeliveryPerKiloPriceDtoModel(
      {required this.id, required this.quantity});
  factory _DeliveryPerKiloPriceDtoModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryPerKiloPriceDtoModelFromJson(json);

  @override
  final String id;
  @override
  final double quantity;

  /// Create a copy of DeliveryPerKiloPriceDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeliveryPerKiloPriceDtoModelCopyWith<_DeliveryPerKiloPriceDtoModel>
      get copyWith => __$DeliveryPerKiloPriceDtoModelCopyWithImpl<
          _DeliveryPerKiloPriceDtoModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeliveryPerKiloPriceDtoModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeliveryPerKiloPriceDtoModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, quantity);

  @override
  String toString() {
    return 'DeliveryPerKiloPriceDtoModel(id: $id, quantity: $quantity)';
  }
}

/// @nodoc
abstract mixin class _$DeliveryPerKiloPriceDtoModelCopyWith<$Res>
    implements $DeliveryPerKiloPriceDtoModelCopyWith<$Res> {
  factory _$DeliveryPerKiloPriceDtoModelCopyWith(
          _DeliveryPerKiloPriceDtoModel value,
          $Res Function(_DeliveryPerKiloPriceDtoModel) _then) =
      __$DeliveryPerKiloPriceDtoModelCopyWithImpl;
  @override
  @useResult
  $Res call({String id, double quantity});
}

/// @nodoc
class __$DeliveryPerKiloPriceDtoModelCopyWithImpl<$Res>
    implements _$DeliveryPerKiloPriceDtoModelCopyWith<$Res> {
  __$DeliveryPerKiloPriceDtoModelCopyWithImpl(this._self, this._then);

  final _DeliveryPerKiloPriceDtoModel _self;
  final $Res Function(_DeliveryPerKiloPriceDtoModel) _then;

  /// Create a copy of DeliveryPerKiloPriceDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? quantity = null,
  }) {
    return _then(_DeliveryPerKiloPriceDtoModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
