// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped_sale_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupedSaleDetail {
  @DecimalConverter()
  Decimal get quantity;
  @DecimalConverter()
  Decimal get unitPrice;
  @DecimalConverter()
  Decimal get totalAmount;
  PaymentMethod get paymentMethod;
  bool get isSpecialPrice;
  bool get isDiscounted; // Add this field
  @NullableDecimalConverter()
  Decimal? get discountedPrice; // Add this field for discounted unit price
  String get formattedSale;

  /// Create a copy of GroupedSaleDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupedSaleDetailCopyWith<GroupedSaleDetail> get copyWith =>
      _$GroupedSaleDetailCopyWithImpl<GroupedSaleDetail>(
          this as GroupedSaleDetail, _$identity);

  /// Serializes this GroupedSaleDetail to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupedSaleDetail &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
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
            (identical(other.formattedSale, formattedSale) ||
                other.formattedSale == formattedSale));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      quantity,
      unitPrice,
      totalAmount,
      paymentMethod,
      isSpecialPrice,
      isDiscounted,
      discountedPrice,
      formattedSale);

  @override
  String toString() {
    return 'GroupedSaleDetail(quantity: $quantity, unitPrice: $unitPrice, totalAmount: $totalAmount, paymentMethod: $paymentMethod, isSpecialPrice: $isSpecialPrice, isDiscounted: $isDiscounted, discountedPrice: $discountedPrice, formattedSale: $formattedSale)';
  }
}

/// @nodoc
abstract mixin class $GroupedSaleDetailCopyWith<$Res> {
  factory $GroupedSaleDetailCopyWith(
          GroupedSaleDetail value, $Res Function(GroupedSaleDetail) _then) =
      _$GroupedSaleDetailCopyWithImpl;
  @useResult
  $Res call(
      {@DecimalConverter() Decimal quantity,
      @DecimalConverter() Decimal unitPrice,
      @DecimalConverter() Decimal totalAmount,
      PaymentMethod paymentMethod,
      bool isSpecialPrice,
      bool isDiscounted,
      @NullableDecimalConverter() Decimal? discountedPrice,
      String formattedSale});
}

/// @nodoc
class _$GroupedSaleDetailCopyWithImpl<$Res>
    implements $GroupedSaleDetailCopyWith<$Res> {
  _$GroupedSaleDetailCopyWithImpl(this._self, this._then);

  final GroupedSaleDetail _self;
  final $Res Function(GroupedSaleDetail) _then;

  /// Create a copy of GroupedSaleDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? isSpecialPrice = null,
    Object? isDiscounted = null,
    Object? discountedPrice = freezed,
    Object? formattedSale = null,
  }) {
    return _then(_self.copyWith(
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      unitPrice: null == unitPrice
          ? _self.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
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
              as Decimal?,
      formattedSale: null == formattedSale
          ? _self.formattedSale
          : formattedSale // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GroupedSaleDetail implements GroupedSaleDetail {
  const _GroupedSaleDetail(
      {@DecimalConverter() required this.quantity,
      @DecimalConverter() required this.unitPrice,
      @DecimalConverter() required this.totalAmount,
      required this.paymentMethod,
      required this.isSpecialPrice,
      required this.isDiscounted,
      @NullableDecimalConverter() this.discountedPrice,
      required this.formattedSale});
  factory _GroupedSaleDetail.fromJson(Map<String, dynamic> json) =>
      _$GroupedSaleDetailFromJson(json);

  @override
  @DecimalConverter()
  final Decimal quantity;
  @override
  @DecimalConverter()
  final Decimal unitPrice;
  @override
  @DecimalConverter()
  final Decimal totalAmount;
  @override
  final PaymentMethod paymentMethod;
  @override
  final bool isSpecialPrice;
  @override
  final bool isDiscounted;
// Add this field
  @override
  @NullableDecimalConverter()
  final Decimal? discountedPrice;
// Add this field for discounted unit price
  @override
  final String formattedSale;

  /// Create a copy of GroupedSaleDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupedSaleDetailCopyWith<_GroupedSaleDetail> get copyWith =>
      __$GroupedSaleDetailCopyWithImpl<_GroupedSaleDetail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupedSaleDetailToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupedSaleDetail &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
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
            (identical(other.formattedSale, formattedSale) ||
                other.formattedSale == formattedSale));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      quantity,
      unitPrice,
      totalAmount,
      paymentMethod,
      isSpecialPrice,
      isDiscounted,
      discountedPrice,
      formattedSale);

  @override
  String toString() {
    return 'GroupedSaleDetail(quantity: $quantity, unitPrice: $unitPrice, totalAmount: $totalAmount, paymentMethod: $paymentMethod, isSpecialPrice: $isSpecialPrice, isDiscounted: $isDiscounted, discountedPrice: $discountedPrice, formattedSale: $formattedSale)';
  }
}

/// @nodoc
abstract mixin class _$GroupedSaleDetailCopyWith<$Res>
    implements $GroupedSaleDetailCopyWith<$Res> {
  factory _$GroupedSaleDetailCopyWith(
          _GroupedSaleDetail value, $Res Function(_GroupedSaleDetail) _then) =
      __$GroupedSaleDetailCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@DecimalConverter() Decimal quantity,
      @DecimalConverter() Decimal unitPrice,
      @DecimalConverter() Decimal totalAmount,
      PaymentMethod paymentMethod,
      bool isSpecialPrice,
      bool isDiscounted,
      @NullableDecimalConverter() Decimal? discountedPrice,
      String formattedSale});
}

/// @nodoc
class __$GroupedSaleDetailCopyWithImpl<$Res>
    implements _$GroupedSaleDetailCopyWith<$Res> {
  __$GroupedSaleDetailCopyWithImpl(this._self, this._then);

  final _GroupedSaleDetail _self;
  final $Res Function(_GroupedSaleDetail) _then;

  /// Create a copy of GroupedSaleDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? quantity = null,
    Object? unitPrice = null,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? isSpecialPrice = null,
    Object? isDiscounted = null,
    Object? discountedPrice = freezed,
    Object? formattedSale = null,
  }) {
    return _then(_GroupedSaleDetail(
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      unitPrice: null == unitPrice
          ? _self.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
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
              as Decimal?,
      formattedSale: null == formattedSale
          ? _self.formattedSale
          : formattedSale // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
