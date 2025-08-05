// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profit_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfitItem {
  String get id;
  String get productId;
  String get productName;
  @DecimalConverter()
  Decimal get quantity;
  @DecimalConverter()
  Decimal get profitPerUnit;
  @DecimalConverter()
  Decimal get totalProfit;
  String get priceType;
  String get formattedPriceType;
  PaymentMethod get paymentMethod;
  bool get isSpecialPrice;
  DateTime get saleDate;
  bool get isAsin;

  /// Create a copy of ProfitItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfitItemCopyWith<ProfitItem> get copyWith =>
      _$ProfitItemCopyWithImpl<ProfitItem>(this as ProfitItem, _$identity);

  /// Serializes this ProfitItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfitItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.profitPerUnit, profitPerUnit) ||
                other.profitPerUnit == profitPerUnit) &&
            (identical(other.totalProfit, totalProfit) ||
                other.totalProfit == totalProfit) &&
            (identical(other.priceType, priceType) ||
                other.priceType == priceType) &&
            (identical(other.formattedPriceType, formattedPriceType) ||
                other.formattedPriceType == formattedPriceType) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.saleDate, saleDate) ||
                other.saleDate == saleDate) &&
            (identical(other.isAsin, isAsin) || other.isAsin == isAsin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      productName,
      quantity,
      profitPerUnit,
      totalProfit,
      priceType,
      formattedPriceType,
      paymentMethod,
      isSpecialPrice,
      saleDate,
      isAsin);

  @override
  String toString() {
    return 'ProfitItem(id: $id, productId: $productId, productName: $productName, quantity: $quantity, profitPerUnit: $profitPerUnit, totalProfit: $totalProfit, priceType: $priceType, formattedPriceType: $formattedPriceType, paymentMethod: $paymentMethod, isSpecialPrice: $isSpecialPrice, saleDate: $saleDate, isAsin: $isAsin)';
  }
}

/// @nodoc
abstract mixin class $ProfitItemCopyWith<$Res> {
  factory $ProfitItemCopyWith(
          ProfitItem value, $Res Function(ProfitItem) _then) =
      _$ProfitItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String productId,
      String productName,
      @DecimalConverter() Decimal quantity,
      @DecimalConverter() Decimal profitPerUnit,
      @DecimalConverter() Decimal totalProfit,
      String priceType,
      String formattedPriceType,
      PaymentMethod paymentMethod,
      bool isSpecialPrice,
      DateTime saleDate,
      bool isAsin});
}

/// @nodoc
class _$ProfitItemCopyWithImpl<$Res> implements $ProfitItemCopyWith<$Res> {
  _$ProfitItemCopyWithImpl(this._self, this._then);

  final ProfitItem _self;
  final $Res Function(ProfitItem) _then;

  /// Create a copy of ProfitItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? quantity = null,
    Object? profitPerUnit = null,
    Object? totalProfit = null,
    Object? priceType = null,
    Object? formattedPriceType = null,
    Object? paymentMethod = null,
    Object? isSpecialPrice = null,
    Object? saleDate = null,
    Object? isAsin = null,
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
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      profitPerUnit: null == profitPerUnit
          ? _self.profitPerUnit
          : profitPerUnit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalProfit: null == totalProfit
          ? _self.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      priceType: null == priceType
          ? _self.priceType
          : priceType // ignore: cast_nullable_to_non_nullable
              as String,
      formattedPriceType: null == formattedPriceType
          ? _self.formattedPriceType
          : formattedPriceType // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      isSpecialPrice: null == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool,
      saleDate: null == saleDate
          ? _self.saleDate
          : saleDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAsin: null == isAsin
          ? _self.isAsin
          : isAsin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ProfitItem implements ProfitItem {
  const _ProfitItem(
      {required this.id,
      required this.productId,
      required this.productName,
      @DecimalConverter() required this.quantity,
      @DecimalConverter() required this.profitPerUnit,
      @DecimalConverter() required this.totalProfit,
      required this.priceType,
      required this.formattedPriceType,
      required this.paymentMethod,
      required this.isSpecialPrice,
      required this.saleDate,
      required this.isAsin});
  factory _ProfitItem.fromJson(Map<String, dynamic> json) =>
      _$ProfitItemFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final String productName;
  @override
  @DecimalConverter()
  final Decimal quantity;
  @override
  @DecimalConverter()
  final Decimal profitPerUnit;
  @override
  @DecimalConverter()
  final Decimal totalProfit;
  @override
  final String priceType;
  @override
  final String formattedPriceType;
  @override
  final PaymentMethod paymentMethod;
  @override
  final bool isSpecialPrice;
  @override
  final DateTime saleDate;
  @override
  final bool isAsin;

  /// Create a copy of ProfitItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfitItemCopyWith<_ProfitItem> get copyWith =>
      __$ProfitItemCopyWithImpl<_ProfitItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfitItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfitItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.profitPerUnit, profitPerUnit) ||
                other.profitPerUnit == profitPerUnit) &&
            (identical(other.totalProfit, totalProfit) ||
                other.totalProfit == totalProfit) &&
            (identical(other.priceType, priceType) ||
                other.priceType == priceType) &&
            (identical(other.formattedPriceType, formattedPriceType) ||
                other.formattedPriceType == formattedPriceType) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.saleDate, saleDate) ||
                other.saleDate == saleDate) &&
            (identical(other.isAsin, isAsin) || other.isAsin == isAsin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      productName,
      quantity,
      profitPerUnit,
      totalProfit,
      priceType,
      formattedPriceType,
      paymentMethod,
      isSpecialPrice,
      saleDate,
      isAsin);

  @override
  String toString() {
    return 'ProfitItem(id: $id, productId: $productId, productName: $productName, quantity: $quantity, profitPerUnit: $profitPerUnit, totalProfit: $totalProfit, priceType: $priceType, formattedPriceType: $formattedPriceType, paymentMethod: $paymentMethod, isSpecialPrice: $isSpecialPrice, saleDate: $saleDate, isAsin: $isAsin)';
  }
}

/// @nodoc
abstract mixin class _$ProfitItemCopyWith<$Res>
    implements $ProfitItemCopyWith<$Res> {
  factory _$ProfitItemCopyWith(
          _ProfitItem value, $Res Function(_ProfitItem) _then) =
      __$ProfitItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      String productName,
      @DecimalConverter() Decimal quantity,
      @DecimalConverter() Decimal profitPerUnit,
      @DecimalConverter() Decimal totalProfit,
      String priceType,
      String formattedPriceType,
      PaymentMethod paymentMethod,
      bool isSpecialPrice,
      DateTime saleDate,
      bool isAsin});
}

/// @nodoc
class __$ProfitItemCopyWithImpl<$Res> implements _$ProfitItemCopyWith<$Res> {
  __$ProfitItemCopyWithImpl(this._self, this._then);

  final _ProfitItem _self;
  final $Res Function(_ProfitItem) _then;

  /// Create a copy of ProfitItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? quantity = null,
    Object? profitPerUnit = null,
    Object? totalProfit = null,
    Object? priceType = null,
    Object? formattedPriceType = null,
    Object? paymentMethod = null,
    Object? isSpecialPrice = null,
    Object? saleDate = null,
    Object? isAsin = null,
  }) {
    return _then(_ProfitItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      profitPerUnit: null == profitPerUnit
          ? _self.profitPerUnit
          : profitPerUnit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalProfit: null == totalProfit
          ? _self.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      priceType: null == priceType
          ? _self.priceType
          : priceType // ignore: cast_nullable_to_non_nullable
              as String,
      formattedPriceType: null == formattedPriceType
          ? _self.formattedPriceType
          : formattedPriceType // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      isSpecialPrice: null == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool,
      saleDate: null == saleDate
          ? _self.saleDate
          : saleDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAsin: null == isAsin
          ? _self.isAsin
          : isAsin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
