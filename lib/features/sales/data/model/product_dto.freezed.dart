// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductDto {
  String get id;
  String get name;
  @NullableDecimalConverter()
  Decimal? get price;
  @NullableDecimalConverter()
  Decimal? get discountedPrice;
  bool? get isDiscounted;
  bool? get isGantang;
  bool? get isSpecialPrice;
  PerKiloPriceDto? get perKiloPrice;
  SackPriceDto? get sackPrice;

  /// Create a copy of ProductDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductDtoCopyWith<ProductDto> get copyWith =>
      _$ProductDtoCopyWithImpl<ProductDto>(this as ProductDto, _$identity);

  /// Serializes this ProductDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discountedPrice, discountedPrice) ||
                other.discountedPrice == discountedPrice) &&
            (identical(other.isDiscounted, isDiscounted) ||
                other.isDiscounted == isDiscounted) &&
            (identical(other.isGantang, isGantang) ||
                other.isGantang == isGantang) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.sackPrice, sackPrice) ||
                other.sackPrice == sackPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, price, discountedPrice,
      isDiscounted, isGantang, isSpecialPrice, perKiloPrice, sackPrice);

  @override
  String toString() {
    return 'ProductDto(id: $id, name: $name, price: $price, discountedPrice: $discountedPrice, isDiscounted: $isDiscounted, isGantang: $isGantang, isSpecialPrice: $isSpecialPrice, perKiloPrice: $perKiloPrice, sackPrice: $sackPrice)';
  }
}

/// @nodoc
abstract mixin class $ProductDtoCopyWith<$Res> {
  factory $ProductDtoCopyWith(
          ProductDto value, $Res Function(ProductDto) _then) =
      _$ProductDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      @NullableDecimalConverter() Decimal? price,
      @NullableDecimalConverter() Decimal? discountedPrice,
      bool? isDiscounted,
      bool? isGantang,
      bool? isSpecialPrice,
      PerKiloPriceDto? perKiloPrice,
      SackPriceDto? sackPrice});

  $PerKiloPriceDtoCopyWith<$Res>? get perKiloPrice;
  $SackPriceDtoCopyWith<$Res>? get sackPrice;
}

/// @nodoc
class _$ProductDtoCopyWithImpl<$Res> implements $ProductDtoCopyWith<$Res> {
  _$ProductDtoCopyWithImpl(this._self, this._then);

  final ProductDto _self;
  final $Res Function(ProductDto) _then;

  /// Create a copy of ProductDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = freezed,
    Object? discountedPrice = freezed,
    Object? isDiscounted = freezed,
    Object? isGantang = freezed,
    Object? isSpecialPrice = freezed,
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
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      discountedPrice: freezed == discountedPrice
          ? _self.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      isDiscounted: freezed == isDiscounted
          ? _self.isDiscounted
          : isDiscounted // ignore: cast_nullable_to_non_nullable
              as bool?,
      isGantang: freezed == isGantang
          ? _self.isGantang
          : isGantang // ignore: cast_nullable_to_non_nullable
              as bool?,
      isSpecialPrice: freezed == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool?,
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as PerKiloPriceDto?,
      sackPrice: freezed == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as SackPriceDto?,
    ));
  }

  /// Create a copy of ProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PerKiloPriceDtoCopyWith<$Res>? get perKiloPrice {
    if (_self.perKiloPrice == null) {
      return null;
    }

    return $PerKiloPriceDtoCopyWith<$Res>(_self.perKiloPrice!, (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }

  /// Create a copy of ProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SackPriceDtoCopyWith<$Res>? get sackPrice {
    if (_self.sackPrice == null) {
      return null;
    }

    return $SackPriceDtoCopyWith<$Res>(_self.sackPrice!, (value) {
      return _then(_self.copyWith(sackPrice: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _ProductDto implements ProductDto {
  const _ProductDto(
      {required this.id,
      required this.name,
      @NullableDecimalConverter() this.price,
      @NullableDecimalConverter() this.discountedPrice,
      this.isDiscounted,
      this.isGantang,
      this.isSpecialPrice,
      this.perKiloPrice,
      this.sackPrice});
  factory _ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @NullableDecimalConverter()
  final Decimal? price;
  @override
  @NullableDecimalConverter()
  final Decimal? discountedPrice;
  @override
  final bool? isDiscounted;
  @override
  final bool? isGantang;
  @override
  final bool? isSpecialPrice;
  @override
  final PerKiloPriceDto? perKiloPrice;
  @override
  final SackPriceDto? sackPrice;

  /// Create a copy of ProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductDtoCopyWith<_ProductDto> get copyWith =>
      __$ProductDtoCopyWithImpl<_ProductDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discountedPrice, discountedPrice) ||
                other.discountedPrice == discountedPrice) &&
            (identical(other.isDiscounted, isDiscounted) ||
                other.isDiscounted == isDiscounted) &&
            (identical(other.isGantang, isGantang) ||
                other.isGantang == isGantang) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.sackPrice, sackPrice) ||
                other.sackPrice == sackPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, price, discountedPrice,
      isDiscounted, isGantang, isSpecialPrice, perKiloPrice, sackPrice);

  @override
  String toString() {
    return 'ProductDto(id: $id, name: $name, price: $price, discountedPrice: $discountedPrice, isDiscounted: $isDiscounted, isGantang: $isGantang, isSpecialPrice: $isSpecialPrice, perKiloPrice: $perKiloPrice, sackPrice: $sackPrice)';
  }
}

/// @nodoc
abstract mixin class _$ProductDtoCopyWith<$Res>
    implements $ProductDtoCopyWith<$Res> {
  factory _$ProductDtoCopyWith(
          _ProductDto value, $Res Function(_ProductDto) _then) =
      __$ProductDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @NullableDecimalConverter() Decimal? price,
      @NullableDecimalConverter() Decimal? discountedPrice,
      bool? isDiscounted,
      bool? isGantang,
      bool? isSpecialPrice,
      PerKiloPriceDto? perKiloPrice,
      SackPriceDto? sackPrice});

  @override
  $PerKiloPriceDtoCopyWith<$Res>? get perKiloPrice;
  @override
  $SackPriceDtoCopyWith<$Res>? get sackPrice;
}

/// @nodoc
class __$ProductDtoCopyWithImpl<$Res> implements _$ProductDtoCopyWith<$Res> {
  __$ProductDtoCopyWithImpl(this._self, this._then);

  final _ProductDto _self;
  final $Res Function(_ProductDto) _then;

  /// Create a copy of ProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = freezed,
    Object? discountedPrice = freezed,
    Object? isDiscounted = freezed,
    Object? isGantang = freezed,
    Object? isSpecialPrice = freezed,
    Object? perKiloPrice = freezed,
    Object? sackPrice = freezed,
  }) {
    return _then(_ProductDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      discountedPrice: freezed == discountedPrice
          ? _self.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      isDiscounted: freezed == isDiscounted
          ? _self.isDiscounted
          : isDiscounted // ignore: cast_nullable_to_non_nullable
              as bool?,
      isGantang: freezed == isGantang
          ? _self.isGantang
          : isGantang // ignore: cast_nullable_to_non_nullable
              as bool?,
      isSpecialPrice: freezed == isSpecialPrice
          ? _self.isSpecialPrice
          : isSpecialPrice // ignore: cast_nullable_to_non_nullable
              as bool?,
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as PerKiloPriceDto?,
      sackPrice: freezed == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as SackPriceDto?,
    ));
  }

  /// Create a copy of ProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PerKiloPriceDtoCopyWith<$Res>? get perKiloPrice {
    if (_self.perKiloPrice == null) {
      return null;
    }

    return $PerKiloPriceDtoCopyWith<$Res>(_self.perKiloPrice!, (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }

  /// Create a copy of ProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SackPriceDtoCopyWith<$Res>? get sackPrice {
    if (_self.sackPrice == null) {
      return null;
    }

    return $SackPriceDtoCopyWith<$Res>(_self.sackPrice!, (value) {
      return _then(_self.copyWith(sackPrice: value));
    });
  }
}

// dart format on
