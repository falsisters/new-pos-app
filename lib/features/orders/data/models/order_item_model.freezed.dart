// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderItemModel {
  String get id;
  double get quantity;
  String get productId;
  String? get sackPriceId;
  @JsonKey(name: 'SackPrice')
  SackPrice? get sackPrice;
  String? get perKiloPriceId;
  PerKiloPrice? get perKiloPrice;
  bool get isSpecialPrice;
  String get orderId;
  OrderProduct get product;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      _$OrderItemModelCopyWithImpl<OrderItemModel>(
          this as OrderItemModel, _$identity);

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sackPriceId, sackPriceId) ||
                other.sackPriceId == sackPriceId) &&
            (identical(other.sackPrice, sackPrice) ||
                other.sackPrice == sackPrice) &&
            (identical(other.perKiloPriceId, perKiloPriceId) ||
                other.perKiloPriceId == perKiloPriceId) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      quantity,
      productId,
      sackPriceId,
      sackPrice,
      perKiloPriceId,
      perKiloPrice,
      isSpecialPrice,
      orderId,
      product,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'OrderItemModel(id: $id, quantity: $quantity, productId: $productId, sackPriceId: $sackPriceId, sackPrice: $sackPrice, perKiloPriceId: $perKiloPriceId, perKiloPrice: $perKiloPrice, isSpecialPrice: $isSpecialPrice, orderId: $orderId, product: $product, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
          OrderItemModel value, $Res Function(OrderItemModel) _then) =
      _$OrderItemModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      double quantity,
      String productId,
      String? sackPriceId,
      @JsonKey(name: 'SackPrice') SackPrice? sackPrice,
      String? perKiloPriceId,
      PerKiloPrice? perKiloPrice,
      bool isSpecialPrice,
      String orderId,
      OrderProduct product,
      DateTime createdAt,
      DateTime updatedAt});

  $SackPriceCopyWith<$Res>? get sackPrice;
  $PerKiloPriceCopyWith<$Res>? get perKiloPrice;
  $OrderProductCopyWith<$Res> get product;
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._self, this._then);

  final OrderItemModel _self;
  final $Res Function(OrderItemModel) _then;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? productId = null,
    Object? sackPriceId = freezed,
    Object? sackPrice = freezed,
    Object? perKiloPriceId = freezed,
    Object? perKiloPrice = freezed,
    Object? isSpecialPrice = null,
    Object? orderId = null,
    Object? product = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      sackPriceId: freezed == sackPriceId
          ? _self.sackPriceId
          : sackPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      sackPrice: freezed == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as SackPrice?,
      perKiloPriceId: freezed == perKiloPriceId
          ? _self.perKiloPriceId
          : perKiloPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as PerKiloPrice?,
      isSpecialPrice: null == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool,
      orderId: null == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as OrderProduct,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SackPriceCopyWith<$Res>? get sackPrice {
    if (_self.sackPrice == null) {
      return null;
    }

    return $SackPriceCopyWith<$Res>(_self.sackPrice!, (value) {
      return _then(_self.copyWith(sackPrice: value));
    });
  }

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PerKiloPriceCopyWith<$Res>? get perKiloPrice {
    if (_self.perKiloPrice == null) {
      return null;
    }

    return $PerKiloPriceCopyWith<$Res>(_self.perKiloPrice!, (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderProductCopyWith<$Res> get product {
    return $OrderProductCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _OrderItemModel implements OrderItemModel {
  const _OrderItemModel(
      {required this.id,
      required this.quantity,
      required this.productId,
      this.sackPriceId,
      @JsonKey(name: 'SackPrice') this.sackPrice,
      this.perKiloPriceId,
      this.perKiloPrice,
      required this.isSpecialPrice,
      required this.orderId,
      required this.product,
      required this.createdAt,
      required this.updatedAt});
  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  @override
  final String id;
  @override
  final double quantity;
  @override
  final String productId;
  @override
  final String? sackPriceId;
  @override
  @JsonKey(name: 'SackPrice')
  final SackPrice? sackPrice;
  @override
  final String? perKiloPriceId;
  @override
  final PerKiloPrice? perKiloPrice;
  @override
  final bool isSpecialPrice;
  @override
  final String orderId;
  @override
  final OrderProduct product;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderItemModelCopyWith<_OrderItemModel> get copyWith =>
      __$OrderItemModelCopyWithImpl<_OrderItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderItemModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sackPriceId, sackPriceId) ||
                other.sackPriceId == sackPriceId) &&
            (identical(other.sackPrice, sackPrice) ||
                other.sackPrice == sackPrice) &&
            (identical(other.perKiloPriceId, perKiloPriceId) ||
                other.perKiloPriceId == perKiloPriceId) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      quantity,
      productId,
      sackPriceId,
      sackPrice,
      perKiloPriceId,
      perKiloPrice,
      isSpecialPrice,
      orderId,
      product,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'OrderItemModel(id: $id, quantity: $quantity, productId: $productId, sackPriceId: $sackPriceId, sackPrice: $sackPrice, perKiloPriceId: $perKiloPriceId, perKiloPrice: $perKiloPrice, isSpecialPrice: $isSpecialPrice, orderId: $orderId, product: $product, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$OrderItemModelCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$OrderItemModelCopyWith(
          _OrderItemModel value, $Res Function(_OrderItemModel) _then) =
      __$OrderItemModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      double quantity,
      String productId,
      String? sackPriceId,
      @JsonKey(name: 'SackPrice') SackPrice? sackPrice,
      String? perKiloPriceId,
      PerKiloPrice? perKiloPrice,
      bool isSpecialPrice,
      String orderId,
      OrderProduct product,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $SackPriceCopyWith<$Res>? get sackPrice;
  @override
  $PerKiloPriceCopyWith<$Res>? get perKiloPrice;
  @override
  $OrderProductCopyWith<$Res> get product;
}

/// @nodoc
class __$OrderItemModelCopyWithImpl<$Res>
    implements _$OrderItemModelCopyWith<$Res> {
  __$OrderItemModelCopyWithImpl(this._self, this._then);

  final _OrderItemModel _self;
  final $Res Function(_OrderItemModel) _then;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? productId = null,
    Object? sackPriceId = freezed,
    Object? sackPrice = freezed,
    Object? perKiloPriceId = freezed,
    Object? perKiloPrice = freezed,
    Object? isSpecialPrice = null,
    Object? orderId = null,
    Object? product = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_OrderItemModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      sackPriceId: freezed == sackPriceId
          ? _self.sackPriceId
          : sackPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      sackPrice: freezed == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as SackPrice?,
      perKiloPriceId: freezed == perKiloPriceId
          ? _self.perKiloPriceId
          : perKiloPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as PerKiloPrice?,
      isSpecialPrice: null == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool,
      orderId: null == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as OrderProduct,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SackPriceCopyWith<$Res>? get sackPrice {
    if (_self.sackPrice == null) {
      return null;
    }

    return $SackPriceCopyWith<$Res>(_self.sackPrice!, (value) {
      return _then(_self.copyWith(sackPrice: value));
    });
  }

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PerKiloPriceCopyWith<$Res>? get perKiloPrice {
    if (_self.perKiloPrice == null) {
      return null;
    }

    return $PerKiloPriceCopyWith<$Res>(_self.perKiloPrice!, (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderProductCopyWith<$Res> get product {
    return $OrderProductCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }
}

// dart format on
