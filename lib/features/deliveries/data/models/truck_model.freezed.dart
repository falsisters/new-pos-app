// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truck_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TruckModel {
  List<DeliveryProductDtoModel> get products;

  /// Create a copy of TruckModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TruckModelCopyWith<TruckModel> get copyWith =>
      _$TruckModelCopyWithImpl<TruckModel>(this as TruckModel, _$identity);

  /// Serializes this TruckModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TruckModel &&
            const DeepCollectionEquality().equals(other.products, products));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(products));

  @override
  String toString() {
    return 'TruckModel(products: $products)';
  }
}

/// @nodoc
abstract mixin class $TruckModelCopyWith<$Res> {
  factory $TruckModelCopyWith(
          TruckModel value, $Res Function(TruckModel) _then) =
      _$TruckModelCopyWithImpl;
  @useResult
  $Res call({List<DeliveryProductDtoModel> products});
}

/// @nodoc
class _$TruckModelCopyWithImpl<$Res> implements $TruckModelCopyWith<$Res> {
  _$TruckModelCopyWithImpl(this._self, this._then);

  final TruckModel _self;
  final $Res Function(TruckModel) _then;

  /// Create a copy of TruckModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
  }) {
    return _then(_self.copyWith(
      products: null == products
          ? _self.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<DeliveryProductDtoModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TruckModel extends TruckModel {
  const _TruckModel({final List<DeliveryProductDtoModel> products = const []})
      : _products = products,
        super._();
  factory _TruckModel.fromJson(Map<String, dynamic> json) =>
      _$TruckModelFromJson(json);

  final List<DeliveryProductDtoModel> _products;
  @override
  @JsonKey()
  List<DeliveryProductDtoModel> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  /// Create a copy of TruckModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TruckModelCopyWith<_TruckModel> get copyWith =>
      __$TruckModelCopyWithImpl<_TruckModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TruckModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TruckModel &&
            const DeepCollectionEquality().equals(other._products, _products));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_products));

  @override
  String toString() {
    return 'TruckModel(products: $products)';
  }
}

/// @nodoc
abstract mixin class _$TruckModelCopyWith<$Res>
    implements $TruckModelCopyWith<$Res> {
  factory _$TruckModelCopyWith(
          _TruckModel value, $Res Function(_TruckModel) _then) =
      __$TruckModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<DeliveryProductDtoModel> products});
}

/// @nodoc
class __$TruckModelCopyWithImpl<$Res> implements _$TruckModelCopyWith<$Res> {
  __$TruckModelCopyWithImpl(this._self, this._then);

  final _TruckModel _self;
  final $Res Function(_TruckModel) _then;

  /// Create a copy of TruckModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? products = null,
  }) {
    return _then(_TruckModel(
      products: null == products
          ? _self._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<DeliveryProductDtoModel>,
    ));
  }
}

// dart format on
