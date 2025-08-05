// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_item_check.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleItemCheck {
  String get id;
  @DecimalConverter()
  Decimal get quantity;
  String
      get productId; // Consider adding ProductDto product if the backend endpoint includes it
// required ProductDto product,
  String? get sackPriceId; // Added to align with SaleItem schema
  String? get perKiloPriceId; // Added to align with SaleItem schema
  String?
      get sackType; // Added to align with SaleItem schema (e.g., "FIFTY_KG", "TWENTY_FIVE_KG", "FIVE_KG")
  String get saleId;
  bool get isGantang;
  bool get isSpecialPrice;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of SaleItemCheck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SaleItemCheckCopyWith<SaleItemCheck> get copyWith =>
      _$SaleItemCheckCopyWithImpl<SaleItemCheck>(
          this as SaleItemCheck, _$identity);

  /// Serializes this SaleItemCheck to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SaleItemCheck &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sackPriceId, sackPriceId) ||
                other.sackPriceId == sackPriceId) &&
            (identical(other.perKiloPriceId, perKiloPriceId) ||
                other.perKiloPriceId == perKiloPriceId) &&
            (identical(other.sackType, sackType) ||
                other.sackType == sackType) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            (identical(other.isGantang, isGantang) ||
                other.isGantang == isGantang) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
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
      perKiloPriceId,
      sackType,
      saleId,
      isGantang,
      isSpecialPrice,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'SaleItemCheck(id: $id, quantity: $quantity, productId: $productId, sackPriceId: $sackPriceId, perKiloPriceId: $perKiloPriceId, sackType: $sackType, saleId: $saleId, isGantang: $isGantang, isSpecialPrice: $isSpecialPrice, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $SaleItemCheckCopyWith<$Res> {
  factory $SaleItemCheckCopyWith(
          SaleItemCheck value, $Res Function(SaleItemCheck) _then) =
      _$SaleItemCheckCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      @DecimalConverter() Decimal quantity,
      String productId,
      String? sackPriceId,
      String? perKiloPriceId,
      String? sackType,
      String saleId,
      bool isGantang,
      bool isSpecialPrice,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$SaleItemCheckCopyWithImpl<$Res>
    implements $SaleItemCheckCopyWith<$Res> {
  _$SaleItemCheckCopyWithImpl(this._self, this._then);

  final SaleItemCheck _self;
  final $Res Function(SaleItemCheck) _then;

  /// Create a copy of SaleItemCheck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? productId = null,
    Object? sackPriceId = freezed,
    Object? perKiloPriceId = freezed,
    Object? sackType = freezed,
    Object? saleId = null,
    Object? isGantang = null,
    Object? isSpecialPrice = null,
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
              as Decimal,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      sackPriceId: freezed == sackPriceId
          ? _self.sackPriceId
          : sackPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      perKiloPriceId: freezed == perKiloPriceId
          ? _self.perKiloPriceId
          : perKiloPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      sackType: freezed == sackType
          ? _self.sackType
          : sackType // ignore: cast_nullable_to_non_nullable
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
}

/// @nodoc
@JsonSerializable()
class _SaleItemCheck implements SaleItemCheck {
  const _SaleItemCheck(
      {required this.id,
      @DecimalConverter() required this.quantity,
      required this.productId,
      this.sackPriceId,
      this.perKiloPriceId,
      this.sackType,
      required this.saleId,
      this.isGantang = false,
      this.isSpecialPrice = false,
      required this.createdAt,
      required this.updatedAt});
  factory _SaleItemCheck.fromJson(Map<String, dynamic> json) =>
      _$SaleItemCheckFromJson(json);

  @override
  final String id;
  @override
  @DecimalConverter()
  final Decimal quantity;
  @override
  final String productId;
// Consider adding ProductDto product if the backend endpoint includes it
// required ProductDto product,
  @override
  final String? sackPriceId;
// Added to align with SaleItem schema
  @override
  final String? perKiloPriceId;
// Added to align with SaleItem schema
  @override
  final String? sackType;
// Added to align with SaleItem schema (e.g., "FIFTY_KG", "TWENTY_FIVE_KG", "FIVE_KG")
  @override
  final String saleId;
  @override
  @JsonKey()
  final bool isGantang;
  @override
  @JsonKey()
  final bool isSpecialPrice;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of SaleItemCheck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SaleItemCheckCopyWith<_SaleItemCheck> get copyWith =>
      __$SaleItemCheckCopyWithImpl<_SaleItemCheck>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SaleItemCheckToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SaleItemCheck &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sackPriceId, sackPriceId) ||
                other.sackPriceId == sackPriceId) &&
            (identical(other.perKiloPriceId, perKiloPriceId) ||
                other.perKiloPriceId == perKiloPriceId) &&
            (identical(other.sackType, sackType) ||
                other.sackType == sackType) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            (identical(other.isGantang, isGantang) ||
                other.isGantang == isGantang) &&
            (identical(other.isSpecialPrice, isSpecialPrice) ||
                other.isSpecialPrice == isSpecialPrice) &&
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
      perKiloPriceId,
      sackType,
      saleId,
      isGantang,
      isSpecialPrice,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'SaleItemCheck(id: $id, quantity: $quantity, productId: $productId, sackPriceId: $sackPriceId, perKiloPriceId: $perKiloPriceId, sackType: $sackType, saleId: $saleId, isGantang: $isGantang, isSpecialPrice: $isSpecialPrice, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$SaleItemCheckCopyWith<$Res>
    implements $SaleItemCheckCopyWith<$Res> {
  factory _$SaleItemCheckCopyWith(
          _SaleItemCheck value, $Res Function(_SaleItemCheck) _then) =
      __$SaleItemCheckCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      @DecimalConverter() Decimal quantity,
      String productId,
      String? sackPriceId,
      String? perKiloPriceId,
      String? sackType,
      String saleId,
      bool isGantang,
      bool isSpecialPrice,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$SaleItemCheckCopyWithImpl<$Res>
    implements _$SaleItemCheckCopyWith<$Res> {
  __$SaleItemCheckCopyWithImpl(this._self, this._then);

  final _SaleItemCheck _self;
  final $Res Function(_SaleItemCheck) _then;

  /// Create a copy of SaleItemCheck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? productId = null,
    Object? sackPriceId = freezed,
    Object? perKiloPriceId = freezed,
    Object? sackType = freezed,
    Object? saleId = null,
    Object? isGantang = null,
    Object? isSpecialPrice = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_SaleItemCheck(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      sackPriceId: freezed == sackPriceId
          ? _self.sackPriceId
          : sackPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      perKiloPriceId: freezed == perKiloPriceId
          ? _self.perKiloPriceId
          : perKiloPriceId // ignore: cast_nullable_to_non_nullable
              as String?,
      sackType: freezed == sackType
          ? _self.sackType
          : sackType // ignore: cast_nullable_to_non_nullable
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
}

// dart format on
