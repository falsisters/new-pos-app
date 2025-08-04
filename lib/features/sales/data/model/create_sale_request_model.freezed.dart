// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_sale_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateSaleRequestModel {
  String? get orderId;
  @DecimalConverter()
  Decimal get totalAmount;
  PaymentMethod get paymentMethod;
  @JsonKey(name: 'saleItem')
  List<ProductDto> get saleItems;
  @NullableDecimalConverter()
  Decimal? get changeAmount;
  String? get cashierId;
  String? get cashierName;
  Map<String, dynamic>? get metadata;

  /// Create a copy of CreateSaleRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateSaleRequestModelCopyWith<CreateSaleRequestModel> get copyWith =>
      _$CreateSaleRequestModelCopyWithImpl<CreateSaleRequestModel>(
          this as CreateSaleRequestModel, _$identity);

  /// Serializes this CreateSaleRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateSaleRequestModel &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality().equals(other.saleItems, saleItems) &&
            (identical(other.changeAmount, changeAmount) ||
                other.changeAmount == changeAmount) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.cashierName, cashierName) ||
                other.cashierName == cashierName) &&
            const DeepCollectionEquality().equals(other.metadata, metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      orderId,
      totalAmount,
      paymentMethod,
      const DeepCollectionEquality().hash(saleItems),
      changeAmount,
      cashierId,
      cashierName,
      const DeepCollectionEquality().hash(metadata));

  @override
  String toString() {
    return 'CreateSaleRequestModel(orderId: $orderId, totalAmount: $totalAmount, paymentMethod: $paymentMethod, saleItems: $saleItems, changeAmount: $changeAmount, cashierId: $cashierId, cashierName: $cashierName, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class $CreateSaleRequestModelCopyWith<$Res> {
  factory $CreateSaleRequestModelCopyWith(CreateSaleRequestModel value,
          $Res Function(CreateSaleRequestModel) _then) =
      _$CreateSaleRequestModelCopyWithImpl;
  @useResult
  $Res call(
      {String? orderId,
      @DecimalConverter() Decimal totalAmount,
      PaymentMethod paymentMethod,
      @JsonKey(name: 'saleItem') List<ProductDto> saleItems,
      @NullableDecimalConverter() Decimal? changeAmount,
      String? cashierId,
      String? cashierName,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$CreateSaleRequestModelCopyWithImpl<$Res>
    implements $CreateSaleRequestModelCopyWith<$Res> {
  _$CreateSaleRequestModelCopyWithImpl(this._self, this._then);

  final CreateSaleRequestModel _self;
  final $Res Function(CreateSaleRequestModel) _then;

  /// Create a copy of CreateSaleRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = freezed,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? saleItems = null,
    Object? changeAmount = freezed,
    Object? cashierId = freezed,
    Object? cashierName = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_self.copyWith(
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      saleItems: null == saleItems
          ? _self.saleItems
          : saleItems // ignore: cast_nullable_to_non_nullable
              as List<ProductDto>,
      changeAmount: freezed == changeAmount
          ? _self.changeAmount
          : changeAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      cashierId: freezed == cashierId
          ? _self.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String?,
      cashierName: freezed == cashierName
          ? _self.cashierName
          : cashierName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CreateSaleRequestModel implements CreateSaleRequestModel {
  const _CreateSaleRequestModel(
      {this.orderId,
      @DecimalConverter() required this.totalAmount,
      required this.paymentMethod,
      @JsonKey(name: 'saleItem') required final List<ProductDto> saleItems,
      @NullableDecimalConverter() this.changeAmount,
      this.cashierId,
      this.cashierName,
      final Map<String, dynamic>? metadata})
      : _saleItems = saleItems,
        _metadata = metadata;
  factory _CreateSaleRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateSaleRequestModelFromJson(json);

  @override
  final String? orderId;
  @override
  @DecimalConverter()
  final Decimal totalAmount;
  @override
  final PaymentMethod paymentMethod;
  final List<ProductDto> _saleItems;
  @override
  @JsonKey(name: 'saleItem')
  List<ProductDto> get saleItems {
    if (_saleItems is EqualUnmodifiableListView) return _saleItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_saleItems);
  }

  @override
  @NullableDecimalConverter()
  final Decimal? changeAmount;
  @override
  final String? cashierId;
  @override
  final String? cashierName;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of CreateSaleRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateSaleRequestModelCopyWith<_CreateSaleRequestModel> get copyWith =>
      __$CreateSaleRequestModelCopyWithImpl<_CreateSaleRequestModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateSaleRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateSaleRequestModel &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality()
                .equals(other._saleItems, _saleItems) &&
            (identical(other.changeAmount, changeAmount) ||
                other.changeAmount == changeAmount) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.cashierName, cashierName) ||
                other.cashierName == cashierName) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      orderId,
      totalAmount,
      paymentMethod,
      const DeepCollectionEquality().hash(_saleItems),
      changeAmount,
      cashierId,
      cashierName,
      const DeepCollectionEquality().hash(_metadata));

  @override
  String toString() {
    return 'CreateSaleRequestModel(orderId: $orderId, totalAmount: $totalAmount, paymentMethod: $paymentMethod, saleItems: $saleItems, changeAmount: $changeAmount, cashierId: $cashierId, cashierName: $cashierName, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class _$CreateSaleRequestModelCopyWith<$Res>
    implements $CreateSaleRequestModelCopyWith<$Res> {
  factory _$CreateSaleRequestModelCopyWith(_CreateSaleRequestModel value,
          $Res Function(_CreateSaleRequestModel) _then) =
      __$CreateSaleRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? orderId,
      @DecimalConverter() Decimal totalAmount,
      PaymentMethod paymentMethod,
      @JsonKey(name: 'saleItem') List<ProductDto> saleItems,
      @NullableDecimalConverter() Decimal? changeAmount,
      String? cashierId,
      String? cashierName,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$CreateSaleRequestModelCopyWithImpl<$Res>
    implements _$CreateSaleRequestModelCopyWith<$Res> {
  __$CreateSaleRequestModelCopyWithImpl(this._self, this._then);

  final _CreateSaleRequestModel _self;
  final $Res Function(_CreateSaleRequestModel) _then;

  /// Create a copy of CreateSaleRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? orderId = freezed,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? saleItems = null,
    Object? changeAmount = freezed,
    Object? cashierId = freezed,
    Object? cashierName = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_CreateSaleRequestModel(
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      saleItems: null == saleItems
          ? _self._saleItems
          : saleItems // ignore: cast_nullable_to_non_nullable
              as List<ProductDto>,
      changeAmount: freezed == changeAmount
          ? _self.changeAmount
          : changeAmount // ignore: cast_nullable_to_non_nullable
              as Decimal?,
      cashierId: freezed == cashierId
          ? _self.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String?,
      cashierName: freezed == cashierName
          ? _self.cashierName
          : cashierName // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _self._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

// dart format on
