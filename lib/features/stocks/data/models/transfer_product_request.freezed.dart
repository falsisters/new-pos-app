// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_product_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferProductRequest {
  TransferProductDto get product;
  TransferType get transferType;

  /// Create a copy of TransferProductRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransferProductRequestCopyWith<TransferProductRequest> get copyWith =>
      _$TransferProductRequestCopyWithImpl<TransferProductRequest>(
          this as TransferProductRequest, _$identity);

  /// Serializes this TransferProductRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransferProductRequest &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.transferType, transferType) ||
                other.transferType == transferType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, product, transferType);

  @override
  String toString() {
    return 'TransferProductRequest(product: $product, transferType: $transferType)';
  }
}

/// @nodoc
abstract mixin class $TransferProductRequestCopyWith<$Res> {
  factory $TransferProductRequestCopyWith(TransferProductRequest value,
          $Res Function(TransferProductRequest) _then) =
      _$TransferProductRequestCopyWithImpl;
  @useResult
  $Res call({TransferProductDto product, TransferType transferType});

  $TransferProductDtoCopyWith<$Res> get product;
}

/// @nodoc
class _$TransferProductRequestCopyWithImpl<$Res>
    implements $TransferProductRequestCopyWith<$Res> {
  _$TransferProductRequestCopyWithImpl(this._self, this._then);

  final TransferProductRequest _self;
  final $Res Function(TransferProductRequest) _then;

  /// Create a copy of TransferProductRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
    Object? transferType = null,
  }) {
    return _then(_self.copyWith(
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as TransferProductDto,
      transferType: null == transferType
          ? _self.transferType
          : transferType // ignore: cast_nullable_to_non_nullable
              as TransferType,
    ));
  }

  /// Create a copy of TransferProductRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferProductDtoCopyWith<$Res> get product {
    return $TransferProductDtoCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TransferProductRequest implements TransferProductRequest {
  const _TransferProductRequest(
      {required this.product, required this.transferType});
  factory _TransferProductRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferProductRequestFromJson(json);

  @override
  final TransferProductDto product;
  @override
  final TransferType transferType;

  /// Create a copy of TransferProductRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransferProductRequestCopyWith<_TransferProductRequest> get copyWith =>
      __$TransferProductRequestCopyWithImpl<_TransferProductRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransferProductRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransferProductRequest &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.transferType, transferType) ||
                other.transferType == transferType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, product, transferType);

  @override
  String toString() {
    return 'TransferProductRequest(product: $product, transferType: $transferType)';
  }
}

/// @nodoc
abstract mixin class _$TransferProductRequestCopyWith<$Res>
    implements $TransferProductRequestCopyWith<$Res> {
  factory _$TransferProductRequestCopyWith(_TransferProductRequest value,
          $Res Function(_TransferProductRequest) _then) =
      __$TransferProductRequestCopyWithImpl;
  @override
  @useResult
  $Res call({TransferProductDto product, TransferType transferType});

  @override
  $TransferProductDtoCopyWith<$Res> get product;
}

/// @nodoc
class __$TransferProductRequestCopyWithImpl<$Res>
    implements _$TransferProductRequestCopyWith<$Res> {
  __$TransferProductRequestCopyWithImpl(this._self, this._then);

  final _TransferProductRequest _self;
  final $Res Function(_TransferProductRequest) _then;

  /// Create a copy of TransferProductRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? product = null,
    Object? transferType = null,
  }) {
    return _then(_TransferProductRequest(
      product: null == product
          ? _self.product
          : product // ignore: cast_nullable_to_non_nullable
              as TransferProductDto,
      transferType: null == transferType
          ? _self.transferType
          : transferType // ignore: cast_nullable_to_non_nullable
              as TransferType,
    ));
  }

  /// Create a copy of TransferProductRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferProductDtoCopyWith<$Res> get product {
    return $TransferProductDtoCopyWith<$Res>(_self.product, (value) {
      return _then(_self.copyWith(product: value));
    });
  }
}

// dart format on
