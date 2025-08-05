// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_per_kilo_price_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditPerKiloPriceDto {
  @DecimalConverter()
  Decimal get price;

  /// Create a copy of EditPerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EditPerKiloPriceDtoCopyWith<EditPerKiloPriceDto> get copyWith =>
      _$EditPerKiloPriceDtoCopyWithImpl<EditPerKiloPriceDto>(
          this as EditPerKiloPriceDto, _$identity);

  /// Serializes this EditPerKiloPriceDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EditPerKiloPriceDto &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, price);

  @override
  String toString() {
    return 'EditPerKiloPriceDto(price: $price)';
  }
}

/// @nodoc
abstract mixin class $EditPerKiloPriceDtoCopyWith<$Res> {
  factory $EditPerKiloPriceDtoCopyWith(
          EditPerKiloPriceDto value, $Res Function(EditPerKiloPriceDto) _then) =
      _$EditPerKiloPriceDtoCopyWithImpl;
  @useResult
  $Res call({@DecimalConverter() Decimal price});
}

/// @nodoc
class _$EditPerKiloPriceDtoCopyWithImpl<$Res>
    implements $EditPerKiloPriceDtoCopyWith<$Res> {
  _$EditPerKiloPriceDtoCopyWithImpl(this._self, this._then);

  final EditPerKiloPriceDto _self;
  final $Res Function(EditPerKiloPriceDto) _then;

  /// Create a copy of EditPerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = null,
  }) {
    return _then(_self.copyWith(
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _EditPerKiloPriceDto implements EditPerKiloPriceDto {
  const _EditPerKiloPriceDto({@DecimalConverter() required this.price});
  factory _EditPerKiloPriceDto.fromJson(Map<String, dynamic> json) =>
      _$EditPerKiloPriceDtoFromJson(json);

  @override
  @DecimalConverter()
  final Decimal price;

  /// Create a copy of EditPerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EditPerKiloPriceDtoCopyWith<_EditPerKiloPriceDto> get copyWith =>
      __$EditPerKiloPriceDtoCopyWithImpl<_EditPerKiloPriceDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EditPerKiloPriceDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EditPerKiloPriceDto &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, price);

  @override
  String toString() {
    return 'EditPerKiloPriceDto(price: $price)';
  }
}

/// @nodoc
abstract mixin class _$EditPerKiloPriceDtoCopyWith<$Res>
    implements $EditPerKiloPriceDtoCopyWith<$Res> {
  factory _$EditPerKiloPriceDtoCopyWith(_EditPerKiloPriceDto value,
          $Res Function(_EditPerKiloPriceDto) _then) =
      __$EditPerKiloPriceDtoCopyWithImpl;
  @override
  @useResult
  $Res call({@DecimalConverter() Decimal price});
}

/// @nodoc
class __$EditPerKiloPriceDtoCopyWithImpl<$Res>
    implements _$EditPerKiloPriceDtoCopyWith<$Res> {
  __$EditPerKiloPriceDtoCopyWithImpl(this._self, this._then);

  final _EditPerKiloPriceDto _self;
  final $Res Function(_EditPerKiloPriceDto) _then;

  /// Create a copy of EditPerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? price = null,
  }) {
    return _then(_EditPerKiloPriceDto(
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal,
    ));
  }
}

// dart format on
