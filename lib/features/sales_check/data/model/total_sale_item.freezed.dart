// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'total_sale_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TotalSaleItem {
  String get id;
  String get saleId;
  double get quantity;
  ProductInfo get product;
  String get priceType; // e.g., "KG", "50KG"
  double get unitPrice;
  double get totalAmount;
  PaymentMethod get paymentMethod;
  bool get isSpecialPrice;
  bool get isDiscounted; // Add this field
  double? get discountedPrice; // Add this field for discounted unit price
  DateTime get saleDate;
  String get formattedTime; // e.g., "14:30"
  String get formattedSale;

  /// Create a copy of TotalSaleItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TotalSaleItemCopyWith<TotalSaleItem> get copyWith =>
      _$TotalSaleItemCopyWithImpl<TotalSaleItem>(
          this as TotalSaleItem, _$identity);

  /// Serializes this TotalSaleItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TotalSaleItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.priceType, priceType) ||
                other.priceType == priceType) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.isDiscounted, isDiscounted) ||
                other.isDiscounted == isDiscounted) &&
            (identical(other.discountedPrice, discountedPrice) ||
                other.discountedPrice == discountedPrice) &&
            (identical(other.saleDate, saleDate) ||
                other.saleDate == saleDate) &&
            (identical(other.formattedTime, formattedTime) ||
                other.formattedTime == formattedTime) &&
            (identical(other.formattedSale, formattedSale) ||
                other.formattedSale == formattedSale));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      saleId,
      quantity,
      product,
      priceType,
      unitPrice,
      totalAmount,
      paymentMethod,
      isSpecialPrice,
      isDiscounted,
      discountedPrice,
      saleDate,
      formattedTime,
      formattedSale);

  @override
  String toString() {
    return 'TotalSaleItem(id: $id, saleId: $saleId, quantity: $quantity, product: $product, priceType: $priceType, unitPrice: $unitPrice, totalAmount: $totalAmount, paymentMethod: $paymentMethod, isSpecialPrice: $isSpecialPrice, isDiscounted: $isDiscounted, discountedPrice: $discountedPrice, saleDate: $saleDate, formattedTime: $formattedTime, formattedSale: $formattedSale)';
  }
}

/// @nodoc
abstract mixin class $TotalSaleItemCopyWith<$Res> {
  factory $TotalSaleItemCopyWith(
          TotalSaleItem value, $Res Function(TotalSaleItem) _then) =
      _$TotalSaleItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String saleId,
      double quantity,
      ProductInfo product,
      String priceType,
      double unitPrice,
      double totalAmount,
      PaymentMethod paymentMethod,
      bool isSpecialPrice,
      bool isDiscounted,
      double? discountedPrice,
      DateTime saleDate,
      String formattedTime,
      String formattedSale});

  $ProductInfoCopyWith<$Res> get product;
}

/// @nodoc
class _$TotalSaleItemCopyWithImpl<$Res>
    implements $TotalSaleItemCopyWith<$Res> {
  _$TotalSaleItemCopyWithImpl(this._self, this._then);

  final TotalSaleItem _self;
  final $Res Function(TotalSaleItem) _then;

  /// Create a copy of TotalSaleItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? saleId = null,
    Object? quantity = null,
    Object? product = null,
    Object? priceType = null,
    Object? unitPrice = null,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? isSpecialPrice = null,
    Object? isDiscounted = null,
    Object? discountedPrice = freezed,
    Object? saleDate = null,
    Object? formattedTime = null,
    Object? formattedSale = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      saleId: null == saleId
          ? _self.saleId
          : saleId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductInfo,
      priceType: null == priceType
          ? _self.priceType
          : priceType // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _self.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      isSpecialPrice: null == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool,
      isDiscounted: null == isDiscounted
          ? _self.isDiscounted
          : isDiscounted // ignore: cast_nullable_to_non_nullable
              as bool,
      discountedPrice: freezed == discountedPrice
          ? _self.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      saleDate: null == saleDate
          ? _self.saleDate
          : saleDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      formattedTime: null == formattedTime
          ? _self.formattedTime
          : formattedTime // ignore: cast_nullable_to_non_nullable
              as String,
      formattedSale: null == formattedSale
          ? _self.formattedSale
          : formattedSale // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of TotalSaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductInfoCopyWith<$Res> get product {
    return $ProductInfoCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TotalSaleItem implements TotalSaleItem {
  const _TotalSaleItem(
      {required this.id,
      required this.saleId,
      required this.quantity,
      required this.product,
      required this.priceType,
      required this.unitPrice,
      required this.totalAmount,
      required this.paymentMethod,
      required this.isSpecialPrice,
      required this.isDiscounted,
      this.discountedPrice,
      required this.saleDate,
      required this.formattedTime,
      required this.formattedSale});
  factory _TotalSaleItem.fromJson(Map<String, dynamic> json) =>
      _$TotalSaleItemFromJson(json);

  @override
  final String id;
  @override
  final String saleId;
  @override
  final double quantity;
  @override
  final ProductInfo product;
  @override
  final String priceType;
// e.g., "KG", "50KG"
  @override
  final double unitPrice;
  @override
  final double totalAmount;
  @override
  final PaymentMethod paymentMethod;
  @override
  final bool isSpecialPrice;
  @override
  final bool isDiscounted;
// Add this field
  @override
  final double? discountedPrice;
// Add this field for discounted unit price
  @override
  final DateTime saleDate;
  @override
  final String formattedTime;
// e.g., "14:30"
  @override
  final String formattedSale;

  /// Create a copy of TotalSaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TotalSaleItemCopyWith<_TotalSaleItem> get copyWith =>
      __$TotalSaleItemCopyWithImpl<_TotalSaleItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TotalSaleItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TotalSaleItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.priceType, priceType) ||
                other.priceType == priceType) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.isDiscounted, isDiscounted) ||
                other.isDiscounted == isDiscounted) &&
            (identical(other.discountedPrice, discountedPrice) ||
                other.discountedPrice == discountedPrice) &&
            (identical(other.saleDate, saleDate) ||
                other.saleDate == saleDate) &&
            (identical(other.formattedTime, formattedTime) ||
                other.formattedTime == formattedTime) &&
            (identical(other.formattedSale, formattedSale) ||
                other.formattedSale == formattedSale));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      saleId,
      quantity,
      product,
      priceType,
      unitPrice,
      totalAmount,
      paymentMethod,
      isSpecialPrice,
      isDiscounted,
      discountedPrice,
      saleDate,
      formattedTime,
      formattedSale);

  @override
  String toString() {
    return 'TotalSaleItem(id: $id, saleId: $saleId, quantity: $quantity, product: $product, priceType: $priceType, unitPrice: $unitPrice, totalAmount: $totalAmount, paymentMethod: $paymentMethod, isSpecialPrice: $isSpecialPrice, isDiscounted: $isDiscounted, discountedPrice: $discountedPrice, saleDate: $saleDate, formattedTime: $formattedTime, formattedSale: $formattedSale)';
  }
}

/// @nodoc
abstract mixin class _$TotalSaleItemCopyWith<$Res>
    implements $TotalSaleItemCopyWith<$Res> {
  factory _$TotalSaleItemCopyWith(
          _TotalSaleItem value, $Res Function(_TotalSaleItem) _then) =
      __$TotalSaleItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String saleId,
      double quantity,
      ProductInfo product,
      String priceType,
      double unitPrice,
      double totalAmount,
      PaymentMethod paymentMethod,
      bool isSpecialPrice,
      bool isDiscounted,
      double? discountedPrice,
      DateTime saleDate,
      String formattedTime,
      String formattedSale});

  @override
  $ProductInfoCopyWith<$Res> get product;
}

/// @nodoc
class __$TotalSaleItemCopyWithImpl<$Res>
    implements _$TotalSaleItemCopyWith<$Res> {
  __$TotalSaleItemCopyWithImpl(this._self, this._then);

  final _TotalSaleItem _self;
  final $Res Function(_TotalSaleItem) _then;

  /// Create a copy of TotalSaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? saleId = null,
    Object? quantity = null,
    Object? product = null,
    Object? priceType = null,
    Object? unitPrice = null,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? isSpecialPrice = null,
    Object? isDiscounted = null,
    Object? discountedPrice = freezed,
    Object? saleDate = null,
    Object? formattedTime = null,
    Object? formattedSale = null,
  }) {
    return _then(_TotalSaleItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      saleId: null == saleId
          ? _self.saleId
          : saleId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductInfo,
      priceType: null == priceType
          ? _self.priceType
          : priceType // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _self.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      isSpecialPrice: null == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool,
      isDiscounted: null == isDiscounted
          ? _self.isDiscounted
          : isDiscounted // ignore: cast_nullable_to_non_nullable
              as bool,
      discountedPrice: freezed == discountedPrice
          ? _self.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      saleDate: null == saleDate
          ? _self.saleDate
          : saleDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      formattedTime: null == formattedTime
          ? _self.formattedTime
          : formattedTime // ignore: cast_nullable_to_non_nullable
              as String,
      formattedSale: null == formattedSale
          ? _self.formattedSale
          : formattedSale // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of TotalSaleItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductInfoCopyWith<$Res> get product {
    return $ProductInfoCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }
}

// dart format on
