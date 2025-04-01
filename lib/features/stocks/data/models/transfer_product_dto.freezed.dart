// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_product_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferProductDto {
  String get id;
  TransferPerKiloPriceDto? get perKiloPrice;
  TransferSackPriceDto? get sackPrice;

  /// Create a copy of TransferProductDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransferProductDtoCopyWith<TransferProductDto> get copyWith =>
      _$TransferProductDtoCopyWithImpl<TransferProductDto>(
          this as TransferProductDto, _$identity);

  /// Serializes this TransferProductDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransferProductDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.sackPrice, sackPrice) ||
                other.sackPrice == sackPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, perKiloPrice, sackPrice);

  @override
  String toString() {
    return 'TransferProductDto(id: $id, perKiloPrice: $perKiloPrice, sackPrice: $sackPrice)';
  }
}

/// @nodoc
abstract mixin class $TransferProductDtoCopyWith<$Res> {
  factory $TransferProductDtoCopyWith(
          TransferProductDto value, $Res Function(TransferProductDto) _then) =
      _$TransferProductDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      TransferPerKiloPriceDto? perKiloPrice,
      TransferSackPriceDto? sackPrice});

  $TransferPerKiloPriceDtoCopyWith<$Res>? get perKiloPrice;
  $TransferSackPriceDtoCopyWith<$Res>? get sackPrice;
}

/// @nodoc
class _$TransferProductDtoCopyWithImpl<$Res>
    implements $TransferProductDtoCopyWith<$Res> {
  _$TransferProductDtoCopyWithImpl(this._self, this._then);

  final TransferProductDto _self;
  final $Res Function(TransferProductDto) _then;

  /// Create a copy of TransferProductDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? perKiloPrice = freezed,
    Object? sackPrice = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as TransferPerKiloPriceDto?,
      sackPrice: freezed == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as TransferSackPriceDto?,
    ));
  }

  /// Create a copy of TransferProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferPerKiloPriceDtoCopyWith<$Res>? get perKiloPrice {
    if (_self.perKiloPrice == null) {
      return null;
    }

    return $TransferPerKiloPriceDtoCopyWith<$Res>(_self.perKiloPrice!, (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }

  /// Create a copy of TransferProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferSackPriceDtoCopyWith<$Res>? get sackPrice {
    if (_self.sackPrice == null) {
      return null;
    }

    return $TransferSackPriceDtoCopyWith<$Res>(_self.sackPrice!, (value) {
      return _then(_self.copyWith(sackPrice: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TransferProductDto implements TransferProductDto {
  const _TransferProductDto(
      {required this.id, this.perKiloPrice, this.sackPrice});
  factory _TransferProductDto.fromJson(Map<String, dynamic> json) =>
      _$TransferProductDtoFromJson(json);

  @override
  final String id;
  @override
  final TransferPerKiloPriceDto? perKiloPrice;
  @override
  final TransferSackPriceDto? sackPrice;

  /// Create a copy of TransferProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransferProductDtoCopyWith<_TransferProductDto> get copyWith =>
      __$TransferProductDtoCopyWithImpl<_TransferProductDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransferProductDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransferProductDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.perKiloPrice, perKiloPrice) ||
                other.perKiloPrice == perKiloPrice) &&
            (identical(other.sackPrice, sackPrice) ||
                other.sackPrice == sackPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, perKiloPrice, sackPrice);

  @override
  String toString() {
    return 'TransferProductDto(id: $id, perKiloPrice: $perKiloPrice, sackPrice: $sackPrice)';
  }
}

/// @nodoc
abstract mixin class _$TransferProductDtoCopyWith<$Res>
    implements $TransferProductDtoCopyWith<$Res> {
  factory _$TransferProductDtoCopyWith(
          _TransferProductDto value, $Res Function(_TransferProductDto) _then) =
      __$TransferProductDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      TransferPerKiloPriceDto? perKiloPrice,
      TransferSackPriceDto? sackPrice});

  @override
  $TransferPerKiloPriceDtoCopyWith<$Res>? get perKiloPrice;
  @override
  $TransferSackPriceDtoCopyWith<$Res>? get sackPrice;
}

/// @nodoc
class __$TransferProductDtoCopyWithImpl<$Res>
    implements _$TransferProductDtoCopyWith<$Res> {
  __$TransferProductDtoCopyWithImpl(this._self, this._then);

  final _TransferProductDto _self;
  final $Res Function(_TransferProductDto) _then;

  /// Create a copy of TransferProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? perKiloPrice = freezed,
    Object? sackPrice = freezed,
  }) {
    return _then(_TransferProductDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      perKiloPrice: freezed == perKiloPrice
          ? _self.perKiloPrice
          : perKiloPrice // ignore: cast_nullable_to_non_nullable
              as TransferPerKiloPriceDto?,
      sackPrice: freezed == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as TransferSackPriceDto?,
    ));
  }

  /// Create a copy of TransferProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferPerKiloPriceDtoCopyWith<$Res>? get perKiloPrice {
    if (_self.perKiloPrice == null) {
      return null;
    }

    return $TransferPerKiloPriceDtoCopyWith<$Res>(_self.perKiloPrice!, (value) {
      return _then(_self.copyWith(perKiloPrice: value));
    });
  }

  /// Create a copy of TransferProductDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferSackPriceDtoCopyWith<$Res>? get sackPrice {
    if (_self.sackPrice == null) {
      return null;
    }

    return $TransferSackPriceDtoCopyWith<$Res>(_self.sackPrice!, (value) {
      return _then(_self.copyWith(sackPrice: value));
    });
  }
}

// dart format on
