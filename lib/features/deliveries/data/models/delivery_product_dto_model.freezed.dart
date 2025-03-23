// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_product_dto_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryProductDtoModel {
  String get id;
  String get name;
  DeliveryPerKiloPriceDtoModel? get perKiloPrice;
  DeliverySackPriceDtoModel? get sackPrice;

  /// Create a copy of DeliveryProductDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeliveryProductDtoModelCopyWith<DeliveryProductDtoModel> get copyWith =>
      _$DeliveryProductDtoModelCopyWithImpl<DeliveryProductDtoModel>(
          this as DeliveryProductDtoModel, _$identity);

  /// Serializes this DeliveryProductDtoModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeliveryProductDtoModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.sackPrice, sackPrice) ||
                other.sackPrice == sackPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, perKiloPrice, sackPrice);

  @override
  String toString() {
    return 'DeliveryProductDtoModel(id: $id, name: $name, perKiloPrice: $perKiloPrice, sackPrice: $sackPrice)';
  }
}

/// @nodoc
abstract mixin class $DeliveryProductDtoModelCopyWith<$Res> {
  factory $DeliveryProductDtoModelCopyWith(DeliveryProductDtoModel value,
          $Res Function(DeliveryProductDtoModel) _then) =
      _$DeliveryProductDtoModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      DeliveryPerKiloPriceDtoModel? perKiloPrice,
      DeliverySackPriceDtoModel? sackPrice});

  $DeliveryPerKiloPriceDtoModelCopyWith<$Res>? get perKiloPrice;
  $DeliverySackPriceDtoModelCopyWith<$Res>? get sackPrice;
}

/// @nodoc
class _$DeliveryProductDtoModelCopyWithImpl<$Res>
    implements $DeliveryProductDtoModelCopyWith<$Res> {
  _$DeliveryProductDtoModelCopyWithImpl(this._self, this._then);

  final DeliveryProductDtoModel _self;
  final $Res Function(DeliveryProductDtoModel) _then;

  /// Create a copy of DeliveryProductDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? perKiloPrice = freezed,
    Object? sackPrice = freezed,
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
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as DeliveryPerKiloPriceDtoModel?,
      sackPrice: freezed == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as DeliverySackPriceDtoModel?,
    ));
  }

  /// Create a copy of DeliveryProductDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeliveryPerKiloPriceDtoModelCopyWith<$Res>? get perKiloPrice {
    if (_self.perKiloPrice == null) {
      return null;
    }

    return $DeliveryPerKiloPriceDtoModelCopyWith<$Res>(_self.perKiloPrice!,
        (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }

  /// Create a copy of DeliveryProductDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeliverySackPriceDtoModelCopyWith<$Res>? get sackPrice {
    if (_self.sackPrice == null) {
      return null;
    }

    return $DeliverySackPriceDtoModelCopyWith<$Res>(_self.sackPrice!, (value) {
      return _then(_self.copyWith(sackPrice: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _DeliveryProductDtoModel implements DeliveryProductDtoModel {
  const _DeliveryProductDtoModel(
      {required this.id,
      required this.name,
      this.perKiloPrice,
      this.sackPrice});
  factory _DeliveryProductDtoModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryProductDtoModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DeliveryPerKiloPriceDtoModel? perKiloPrice;
  @override
  final DeliverySackPriceDtoModel? sackPrice;

  /// Create a copy of DeliveryProductDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeliveryProductDtoModelCopyWith<_DeliveryProductDtoModel> get copyWith =>
      __$DeliveryProductDtoModelCopyWithImpl<_DeliveryProductDtoModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeliveryProductDtoModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeliveryProductDtoModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.sackPrice, sackPrice) ||
                other.sackPrice == sackPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, perKiloPrice, sackPrice);

  @override
  String toString() {
    return 'DeliveryProductDtoModel(id: $id, name: $name, perKiloPrice: $perKiloPrice, sackPrice: $sackPrice)';
  }
}

/// @nodoc
abstract mixin class _$DeliveryProductDtoModelCopyWith<$Res>
    implements $DeliveryProductDtoModelCopyWith<$Res> {
  factory _$DeliveryProductDtoModelCopyWith(_DeliveryProductDtoModel value,
          $Res Function(_DeliveryProductDtoModel) _then) =
      __$DeliveryProductDtoModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      DeliveryPerKiloPriceDtoModel? perKiloPrice,
      DeliverySackPriceDtoModel? sackPrice});

  @override
  $DeliveryPerKiloPriceDtoModelCopyWith<$Res>? get perKiloPrice;
  @override
  $DeliverySackPriceDtoModelCopyWith<$Res>? get sackPrice;
}

/// @nodoc
class __$DeliveryProductDtoModelCopyWithImpl<$Res>
    implements _$DeliveryProductDtoModelCopyWith<$Res> {
  __$DeliveryProductDtoModelCopyWithImpl(this._self, this._then);

  final _DeliveryProductDtoModel _self;
  final $Res Function(_DeliveryProductDtoModel) _then;

  /// Create a copy of DeliveryProductDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? perKiloPrice = freezed,
    Object? sackPrice = freezed,
  }) {
    return _then(_DeliveryProductDtoModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as DeliveryPerKiloPriceDtoModel?,
      sackPrice: freezed == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as DeliverySackPriceDtoModel?,
    ));
  }

  /// Create a copy of DeliveryProductDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeliveryPerKiloPriceDtoModelCopyWith<$Res>? get perKiloPrice {
    if (_self.perKiloPrice == null) {
      return null;
    }

    return $DeliveryPerKiloPriceDtoModelCopyWith<$Res>(_self.perKiloPrice!,
        (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }

  /// Create a copy of DeliveryProductDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeliverySackPriceDtoModelCopyWith<$Res>? get sackPrice {
    if (_self.sackPrice == null) {
      return null;
    }

    return $DeliverySackPriceDtoModelCopyWith<$Res>(_self.sackPrice!, (value) {
      return _then(_self.copyWith(sackPrice: value));
    });
  }
}

// dart format on
