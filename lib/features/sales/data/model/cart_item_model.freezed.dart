// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartItemModel {
  ProductDto get product;
  bool? get isGantang;
  bool? get isSpecialPrice;
  double get price;
  int get quantity;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CartItemModelCopyWith<CartItemModel> get copyWith =>
      _$CartItemModelCopyWithImpl<CartItemModel>(
          this as CartItemModel, _$identity);

  /// Serializes this CartItemModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CartItemModel &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.isGantang, isGantang) ||
                other.isGantang == isGantang) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, product, isGantang, isSpecialPrice, price, quantity);

  @override
  String toString() {
    return 'CartItemModel(product: $product, isGantang: $isGantang, isSpecialPrice: $isSpecialPrice, price: $price, quantity: $quantity)';
  }
}

/// @nodoc
abstract mixin class $CartItemModelCopyWith<$Res> {
  factory $CartItemModelCopyWith(
          CartItemModel value, $Res Function(CartItemModel) _then) =
      _$CartItemModelCopyWithImpl;
  @useResult
  $Res call(
      {ProductDto product,
      bool? isGantang,
      bool? isSpecialPrice,
      double price,
      int quantity});

  $ProductDtoCopyWith<$Res> get product;
}

/// @nodoc
class _$CartItemModelCopyWithImpl<$Res>
    implements $CartItemModelCopyWith<$Res> {
  _$CartItemModelCopyWithImpl(this._self, this._then);

  final CartItemModel _self;
  final $Res Function(CartItemModel) _then;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
    Object? isGantang = freezed,
    Object? isSpecialPrice = freezed,
    Object? price = null,
    Object? quantity = null,
  }) {
    return _then(_self.copyWith(
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductDto,
      isGantang: freezed == isGantang
          ? _self.isGantang
          : isGantang // ignore: cast_nullable_to_non_nullable
              as bool?,
      isSpecialPrice: freezed == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductDtoCopyWith<$Res> get product {
    return $ProductDtoCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _CartItemModel extends CartItemModel {
  const _CartItemModel(
      {required this.product,
      this.isGantang,
      this.isSpecialPrice,
      required this.price,
      required this.quantity})
      : super._();
  factory _CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  @override
  final ProductDto product;
  @override
  final bool? isGantang;
  @override
  final bool? isSpecialPrice;
  @override
  final double price;
  @override
  final int quantity;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CartItemModelCopyWith<_CartItemModel> get copyWith =>
      __$CartItemModelCopyWithImpl<_CartItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CartItemModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CartItemModel &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.isGantang, isGantang) ||
                other.isGantang == isGantang) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, product, isGantang, isSpecialPrice, price, quantity);

  @override
  String toString() {
    return 'CartItemModel(product: $product, isGantang: $isGantang, isSpecialPrice: $isSpecialPrice, price: $price, quantity: $quantity)';
  }
}

/// @nodoc
abstract mixin class _$CartItemModelCopyWith<$Res>
    implements $CartItemModelCopyWith<$Res> {
  factory _$CartItemModelCopyWith(
          _CartItemModel value, $Res Function(_CartItemModel) _then) =
      __$CartItemModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ProductDto product,
      bool? isGantang,
      bool? isSpecialPrice,
      double price,
      int quantity});

  @override
  $ProductDtoCopyWith<$Res> get product;
}

/// @nodoc
class __$CartItemModelCopyWithImpl<$Res>
    implements _$CartItemModelCopyWith<$Res> {
  __$CartItemModelCopyWithImpl(this._self, this._then);

  final _CartItemModel _self;
  final $Res Function(_CartItemModel) _then;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? product = null,
    Object? isGantang = freezed,
    Object? isSpecialPrice = freezed,
    Object? price = null,
    Object? quantity = null,
  }) {
    return _then(_CartItemModel(
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductDto,
      isGantang: freezed == isGantang
          ? _self.isGantang
          : isGantang // ignore: cast_nullable_to_non_nullable
              as bool?,
      isSpecialPrice: freezed == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductDtoCopyWith<$Res> get product {
    return $ProductDtoCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }
}

// dart format on
