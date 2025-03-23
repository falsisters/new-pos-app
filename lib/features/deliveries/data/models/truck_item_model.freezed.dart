// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truck_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TruckItemModel {
  DeliveryProductDtoModel get product;

  /// Create a copy of TruckItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TruckItemModelCopyWith<TruckItemModel> get copyWith =>
      _$TruckItemModelCopyWithImpl<TruckItemModel>(
          this as TruckItemModel, _$identity);

  /// Serializes this TruckItemModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TruckItemModel &&
            (identical(other.product, product) || other.product == product));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, product);

  @override
  String toString() {
    return 'TruckItemModel(product: $product)';
  }
}

/// @nodoc
abstract mixin class $TruckItemModelCopyWith<$Res> {
  factory $TruckItemModelCopyWith(
          TruckItemModel value, $Res Function(TruckItemModel) _then) =
      _$TruckItemModelCopyWithImpl;
  @useResult
  $Res call({DeliveryProductDtoModel product});

  $DeliveryProductDtoModelCopyWith<$Res> get product;
}

/// @nodoc
class _$TruckItemModelCopyWithImpl<$Res>
    implements $TruckItemModelCopyWith<$Res> {
  _$TruckItemModelCopyWithImpl(this._self, this._then);

  final TruckItemModel _self;
  final $Res Function(TruckItemModel) _then;

  /// Create a copy of TruckItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
  }) {
    return _then(_self.copyWith(
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as DeliveryProductDtoModel,
    ));
  }

  /// Create a copy of TruckItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeliveryProductDtoModelCopyWith<$Res> get product {
    return $DeliveryProductDtoModelCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TruckItemModel implements TruckItemModel {
  const _TruckItemModel({required this.product});
  factory _TruckItemModel.fromJson(Map<String, dynamic> json) =>
      _$TruckItemModelFromJson(json);

  @override
  final DeliveryProductDtoModel product;

  /// Create a copy of TruckItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TruckItemModelCopyWith<_TruckItemModel> get copyWith =>
      __$TruckItemModelCopyWithImpl<_TruckItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TruckItemModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TruckItemModel &&
            (identical(other.product, product) || other.product == product));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, product);

  @override
  String toString() {
    return 'TruckItemModel(product: $product)';
  }
}

/// @nodoc
abstract mixin class _$TruckItemModelCopyWith<$Res>
    implements $TruckItemModelCopyWith<$Res> {
  factory _$TruckItemModelCopyWith(
          _TruckItemModel value, $Res Function(_TruckItemModel) _then) =
      __$TruckItemModelCopyWithImpl;
  @override
  @useResult
  $Res call({DeliveryProductDtoModel product});

  @override
  $DeliveryProductDtoModelCopyWith<$Res> get product;
}

/// @nodoc
class __$TruckItemModelCopyWithImpl<$Res>
    implements _$TruckItemModelCopyWith<$Res> {
  __$TruckItemModelCopyWithImpl(this._self, this._then);

  final _TruckItemModel _self;
  final $Res Function(_TruckItemModel) _then;

  /// Create a copy of TruckItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? product = null,
  }) {
    return _then(_TruckItemModel(
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as DeliveryProductDtoModel,
    ));
  }

  /// Create a copy of TruckItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeliveryProductDtoModelCopyWith<$Res> get product {
    return $DeliveryProductDtoModelCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }
}

// dart format on
