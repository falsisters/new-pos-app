// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_special_price_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditSpecialPriceDto {
  String get id;
  @DecimalConverter()
  Decimal get price;
  int get minimumQty;

  /// Create a copy of EditSpecialPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EditSpecialPriceDtoCopyWith<EditSpecialPriceDto> get copyWith =>
      _$EditSpecialPriceDtoCopyWithImpl<EditSpecialPriceDto>(
          this as EditSpecialPriceDto, _$identity);

  /// Serializes this EditSpecialPriceDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EditSpecialPriceDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.minimumQty, minimumQty) ||
                other.minimumQty == minimumQty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, price, minimumQty);

  @override
  String toString() {
    return 'EditSpecialPriceDto(id: $id, price: $price, minimumQty: $minimumQty)';
  }
}

/// @nodoc
abstract mixin class $EditSpecialPriceDtoCopyWith<$Res> {
  factory $EditSpecialPriceDtoCopyWith(
          EditSpecialPriceDto value, $Res Function(EditSpecialPriceDto) _then) =
      _$EditSpecialPriceDtoCopyWithImpl;
  @useResult
  $Res call({String id, @DecimalConverter() Decimal price, int minimumQty});
}

/// @nodoc
class _$EditSpecialPriceDtoCopyWithImpl<$Res>
    implements $EditSpecialPriceDtoCopyWith<$Res> {
  _$EditSpecialPriceDtoCopyWithImpl(this._self, this._then);

  final EditSpecialPriceDto _self;
  final $Res Function(EditSpecialPriceDto) _then;

  /// Create a copy of EditSpecialPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? minimumQty = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal,
      minimumQty: null == minimumQty
          ? _self.minimumQty
          : minimumQty // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _EditSpecialPriceDto implements EditSpecialPriceDto {
  const _EditSpecialPriceDto(
      {required this.id,
      @DecimalConverter() required this.price,
      required this.minimumQty});
  factory _EditSpecialPriceDto.fromJson(Map<String, dynamic> json) =>
      _$EditSpecialPriceDtoFromJson(json);

  @override
  final String id;
  @override
  @DecimalConverter()
  final Decimal price;
  @override
  final int minimumQty;

  /// Create a copy of EditSpecialPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EditSpecialPriceDtoCopyWith<_EditSpecialPriceDto> get copyWith =>
      __$EditSpecialPriceDtoCopyWithImpl<_EditSpecialPriceDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EditSpecialPriceDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EditSpecialPriceDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.minimumQty, minimumQty) ||
                other.minimumQty == minimumQty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, price, minimumQty);

  @override
  String toString() {
    return 'EditSpecialPriceDto(id: $id, price: $price, minimumQty: $minimumQty)';
  }
}

/// @nodoc
abstract mixin class _$EditSpecialPriceDtoCopyWith<$Res>
    implements $EditSpecialPriceDtoCopyWith<$Res> {
  factory _$EditSpecialPriceDtoCopyWith(_EditSpecialPriceDto value,
          $Res Function(_EditSpecialPriceDto) _then) =
      __$EditSpecialPriceDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, @DecimalConverter() Decimal price, int minimumQty});
}

/// @nodoc
class __$EditSpecialPriceDtoCopyWithImpl<$Res>
    implements _$EditSpecialPriceDtoCopyWith<$Res> {
  __$EditSpecialPriceDtoCopyWithImpl(this._self, this._then);

  final _EditSpecialPriceDto _self;
  final $Res Function(_EditSpecialPriceDto) _then;

  /// Create a copy of EditSpecialPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? minimumQty = null,
  }) {
    return _then(_EditSpecialPriceDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal,
      minimumQty: null == minimumQty
          ? _self.minimumQty
          : minimumQty // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
