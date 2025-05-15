// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleItem {
  String get id;
  String get productId;
  Product get product;
  double get quantity;
  double? get discountedPrice;
  @JsonKey(name: 'SackPrice')
  SackPrice? get sackPrice;
  String? get sackPriceId;
  SackType? get sackType;
  PerKiloPrice? get perKiloPrice;
  String? get perKiloPriceId;
  String get saleId;
  bool get isGantang;
  bool get isSpecialPrice;
  bool get isDiscounted;
  String get createdAt;
  String get updatedAt;

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SaleItemCopyWith<SaleItem> get copyWith =>
      _$SaleItemCopyWithImpl<SaleItem>(this as SaleItem, _$identity);

  /// Serializes this SaleItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SaleItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.discountedPrice, discountedPrice) ||
                other.discountedPrice == discountedPrice) &&
            (identical(other.sackPrice, sackPrice) ||
                other.sackPrice == sackPrice) &&
            (identical(other.sackPriceId, sackPriceId) ||
                other.sackPriceId == sackPriceId) &&
            (identical(other.sackType, sackType) ||
                other.sackType == sackType) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.perKiloPriceId, perKiloPriceId) ||
                other.perKiloPriceId == perKiloPriceId) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            (identical(other.isGantang, isGantang) ||
                other.isGantang == isGantang) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.isDiscounted, isDiscounted) ||
                other.isDiscounted == isDiscounted) &&
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
      productId,
      product,
      quantity,
      discountedPrice,
      sackPrice,
      sackPriceId,
      sackType,
      perKiloPrice,
      perKiloPriceId,
      saleId,
      isGantang,
      isSpecialPrice,
      isDiscounted,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'SaleItem(id: $id, productId: $productId, product: $product, quantity: $quantity, discountedPrice: $discountedPrice, sackPrice: $sackPrice, sackPriceId: $sackPriceId, sackType: $sackType, perKiloPrice: $perKiloPrice, perKiloPriceId: $perKiloPriceId, saleId: $saleId, isGantang: $isGantang, isSpecialPrice: $isSpecialPrice, isDiscounted: $isDiscounted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $SaleItemCopyWith<$Res> {
  factory $SaleItemCopyWith(SaleItem value, $Res Function(SaleItem) _then) =
      _$SaleItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String productId,
      Product product,
      double quantity,
      double? discountedPrice,
      @JsonKey(name: 'SackPrice') SackPrice? sackPrice,
      String? sackPriceId,
      SackType? sackType,
      PerKiloPrice? perKiloPrice,
      String? perKiloPriceId,
      String saleId,
      bool isGantang,
      bool isSpecialPrice,
      bool isDiscounted,
      String createdAt,
      String updatedAt});

  $ProductCopyWith<$Res> get product;
  $SackPriceCopyWith<$Res>? get sackPrice;
  $PerKiloPriceCopyWith<$Res>? get perKiloPrice;
}

/// @nodoc
class _$SaleItemCopyWithImpl<$Res> implements $SaleItemCopyWith<$Res> {
  _$SaleItemCopyWithImpl(this._self, this._then);

  final SaleItem _self;
  final $Res Function(SaleItem) _then;

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? product = null,
    Object? quantity = null,
    Object? discountedPrice = freezed,
    Object? sackPrice = freezed,
    Object? sackPriceId = freezed,
    Object? sackType = freezed,
    Object? perKiloPrice = freezed,
    Object? perKiloPriceId = freezed,
    Object? saleId = null,
    Object? isGantang = null,
    Object? isSpecialPrice = null,
    Object? isDiscounted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      discountedPrice: freezed == discountedPrice
          ? _self.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      sackPrice: freezed == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as SackPrice?,
      sackPriceId: freezed == sackPriceId
          ? _self.sackPriceId
          : sackPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      sackType: freezed == sackType
          ? _self.sackType
          : sackType // ignore: cast_nullable_to_non_nullable
              as SackType?,
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as PerKiloPrice?,
      perKiloPriceId: freezed == perKiloPriceId
          ? _self.perKiloPriceId
          : perKiloPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      saleId: null == saleId
          ? _self.saleId
          : saleId // ignore: cast_nullable_to_non_nullable
              as String,
      isGantang: null == isGantang
          ? _self.isGantang
          : isGantang // ignore: cast_nullable_to_non_nullable
              as bool,
      isSpecialPrice: null == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool,
      isDiscounted: null == isDiscounted
          ? _self.isDiscounted
          : isDiscounted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res> get product {
    return $ProductCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }

  /// Create a copy of SaleItem
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

  /// Create a copy of SaleItem
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
}

/// @nodoc
@JsonSerializable()
class _SaleItem implements SaleItem {
  const _SaleItem(
      {required this.id,
      required this.productId,
      required this.product,
      required this.quantity,
      this.discountedPrice,
      @JsonKey(name: 'SackPrice') this.sackPrice,
      this.sackPriceId,
      this.sackType,
      this.perKiloPrice,
      this.perKiloPriceId,
      required this.saleId,
      required this.isGantang,
      required this.isSpecialPrice,
      required this.isDiscounted,
      required this.createdAt,
      required this.updatedAt});
  factory _SaleItem.fromJson(Map<String, dynamic> json) =>
      _$SaleItemFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final Product product;
  @override
  final double quantity;
  @override
  final double? discountedPrice;
  @override
  @JsonKey(name: 'SackPrice')
  final SackPrice? sackPrice;
  @override
  final String? sackPriceId;
  @override
  final SackType? sackType;
  @override
  final PerKiloPrice? perKiloPrice;
  @override
  final String? perKiloPriceId;
  @override
  final String saleId;
  @override
  final bool isGantang;
  @override
  final bool isSpecialPrice;
  @override
  final bool isDiscounted;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SaleItemCopyWith<_SaleItem> get copyWith =>
      __$SaleItemCopyWithImpl<_SaleItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SaleItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SaleItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.discountedPrice, discountedPrice) ||
                other.discountedPrice == discountedPrice) &&
            (identical(other.sackPrice, sackPrice) ||
                other.sackPrice == sackPrice) &&
            (identical(other.sackPriceId, sackPriceId) ||
                other.sackPriceId == sackPriceId) &&
            (identical(other.sackType, sackType) ||
                other.sackType == sackType) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.perKiloPriceId, perKiloPriceId) ||
                other.perKiloPriceId == perKiloPriceId) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            (identical(other.isGantang, isGantang) ||
                other.isGantang == isGantang) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.isDiscounted, isDiscounted) ||
                other.isDiscounted == isDiscounted) &&
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
      productId,
      product,
      quantity,
      discountedPrice,
      sackPrice,
      sackPriceId,
      sackType,
      perKiloPrice,
      perKiloPriceId,
      saleId,
      isGantang,
      isSpecialPrice,
      isDiscounted,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'SaleItem(id: $id, productId: $productId, product: $product, quantity: $quantity, discountedPrice: $discountedPrice, sackPrice: $sackPrice, sackPriceId: $sackPriceId, sackType: $sackType, perKiloPrice: $perKiloPrice, perKiloPriceId: $perKiloPriceId, saleId: $saleId, isGantang: $isGantang, isSpecialPrice: $isSpecialPrice, isDiscounted: $isDiscounted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$SaleItemCopyWith<$Res>
    implements $SaleItemCopyWith<$Res> {
  factory _$SaleItemCopyWith(_SaleItem value, $Res Function(_SaleItem) _then) =
      __$SaleItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      Product product,
      double quantity,
      double? discountedPrice,
      @JsonKey(name: 'SackPrice') SackPrice? sackPrice,
      String? sackPriceId,
      SackType? sackType,
      PerKiloPrice? perKiloPrice,
      String? perKiloPriceId,
      String saleId,
      bool isGantang,
      bool isSpecialPrice,
      bool isDiscounted,
      String createdAt,
      String updatedAt});

  @override
  $ProductCopyWith<$Res> get product;
  @override
  $SackPriceCopyWith<$Res>? get sackPrice;
  @override
  $PerKiloPriceCopyWith<$Res>? get perKiloPrice;
}

/// @nodoc
class __$SaleItemCopyWithImpl<$Res> implements _$SaleItemCopyWith<$Res> {
  __$SaleItemCopyWithImpl(this._self, this._then);

  final _SaleItem _self;
  final $Res Function(_SaleItem) _then;

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? product = null,
    Object? quantity = null,
    Object? discountedPrice = freezed,
    Object? sackPrice = freezed,
    Object? sackPriceId = freezed,
    Object? sackType = freezed,
    Object? perKiloPrice = freezed,
    Object? perKiloPriceId = freezed,
    Object? saleId = null,
    Object? isGantang = null,
    Object? isSpecialPrice = null,
    Object? isDiscounted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_SaleItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      discountedPrice: freezed == discountedPrice
          ? _self.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      sackPrice: freezed == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as SackPrice?,
      sackPriceId: freezed == sackPriceId
          ? _self.sackPriceId
          : sackPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      sackType: freezed == sackType
          ? _self.sackType
          : sackType // ignore: cast_nullable_to_non_nullable
              as SackType?,
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as PerKiloPrice?,
      perKiloPriceId: freezed == perKiloPriceId
          ? _self.perKiloPriceId
          : perKiloPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      saleId: null == saleId
          ? _self.saleId
          : saleId // ignore: cast_nullable_to_non_nullable
              as String,
      isGantang: null == isGantang
          ? _self.isGantang
          : isGantang // ignore: cast_nullable_to_non_nullable
              as bool,
      isSpecialPrice: null == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool,
      isDiscounted: null == isDiscounted
          ? _self.isDiscounted
          : isDiscounted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of SaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res> get product {
    return $ProductCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }

  /// Create a copy of SaleItem
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

  /// Create a copy of SaleItem
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
}

// dart format on
