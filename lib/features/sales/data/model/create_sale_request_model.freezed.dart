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
  double get totalAmount;
  PaymentMethod get paymentMethod;
  @JsonKey(name: 'saleItem')
  List<ProductDto> get saleItems;

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
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality().equals(other.saleItems, saleItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalAmount, paymentMethod,
      const DeepCollectionEquality().hash(saleItems));

  @override
  String toString() {
    return 'CreateSaleRequestModel(totalAmount: $totalAmount, paymentMethod: $paymentMethod, saleItems: $saleItems)';
  }
}

/// @nodoc
abstract mixin class $CreateSaleRequestModelCopyWith<$Res> {
  factory $CreateSaleRequestModelCopyWith(CreateSaleRequestModel value,
          $Res Function(CreateSaleRequestModel) _then) =
      _$CreateSaleRequestModelCopyWithImpl;
  @useResult
  $Res call(
      {double totalAmount,
      PaymentMethod paymentMethod,
      @JsonKey(name: 'saleItem') List<ProductDto> saleItems});
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
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? saleItems = null,
  }) {
    return _then(_self.copyWith(
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      saleItems: null == saleItems
          ? _self.saleItems
          : saleItems // ignore: cast_nullable_to_non_nullable
              as List<ProductDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CreateSaleRequestModel implements CreateSaleRequestModel {
  const _CreateSaleRequestModel(
      {required this.totalAmount,
      required this.paymentMethod,
      @JsonKey(name: 'saleItem') required final List<ProductDto> saleItems})
      : _saleItems = saleItems;
  factory _CreateSaleRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateSaleRequestModelFromJson(json);

  @override
  final double totalAmount;
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
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality()
                .equals(other._saleItems, _saleItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalAmount, paymentMethod,
      const DeepCollectionEquality().hash(_saleItems));

  @override
  String toString() {
    return 'CreateSaleRequestModel(totalAmount: $totalAmount, paymentMethod: $paymentMethod, saleItems: $saleItems)';
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
      {double totalAmount,
      PaymentMethod paymentMethod,
      @JsonKey(name: 'saleItem') List<ProductDto> saleItems});
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
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? saleItems = null,
  }) {
    return _then(_CreateSaleRequestModel(
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      saleItems: null == saleItems
          ? _self._saleItems
          : saleItems // ignore: cast_nullable_to_non_nullable
              as List<ProductDto>,
    ));
  }
}

// dart format on
