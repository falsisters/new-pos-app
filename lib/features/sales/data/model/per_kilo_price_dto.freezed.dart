// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'per_kilo_price_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PerKiloPriceDto {
  String get id;
  double get quantity;
  double get price;

  /// Create a copy of PerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PerKiloPriceDtoCopyWith<PerKiloPriceDto> get copyWith =>
      _$PerKiloPriceDtoCopyWithImpl<PerKiloPriceDto>(
          this as PerKiloPriceDto, _$identity);

  /// Serializes this PerKiloPriceDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PerKiloPriceDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, quantity, price);

  @override
  String toString() {
    return 'PerKiloPriceDto(id: $id, quantity: $quantity, price: $price)';
  }
}

/// @nodoc
abstract mixin class $PerKiloPriceDtoCopyWith<$Res> {
  factory $PerKiloPriceDtoCopyWith(
          PerKiloPriceDto value, $Res Function(PerKiloPriceDto) _then) =
      _$PerKiloPriceDtoCopyWithImpl;
  @useResult
  $Res call({String id, double quantity, double price});
}

/// @nodoc
class _$PerKiloPriceDtoCopyWithImpl<$Res>
    implements $PerKiloPriceDtoCopyWith<$Res> {
  _$PerKiloPriceDtoCopyWithImpl(this._self, this._then);

  final PerKiloPriceDto _self;
  final $Res Function(PerKiloPriceDto) _then;

  /// Create a copy of PerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PerKiloPriceDto implements PerKiloPriceDto {
  const _PerKiloPriceDto(
      {required this.id, required this.quantity, required this.price});
  factory _PerKiloPriceDto.fromJson(Map<String, dynamic> json) =>
      _$PerKiloPriceDtoFromJson(json);

  @override
  final String id;
  @override
  final double quantity;
  @override
  final double price;

  /// Create a copy of PerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PerKiloPriceDtoCopyWith<_PerKiloPriceDto> get copyWith =>
      __$PerKiloPriceDtoCopyWithImpl<_PerKiloPriceDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PerKiloPriceDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PerKiloPriceDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, quantity, price);

  @override
  String toString() {
    return 'PerKiloPriceDto(id: $id, quantity: $quantity, price: $price)';
  }
}

/// @nodoc
abstract mixin class _$PerKiloPriceDtoCopyWith<$Res>
    implements $PerKiloPriceDtoCopyWith<$Res> {
  factory _$PerKiloPriceDtoCopyWith(
          _PerKiloPriceDto value, $Res Function(_PerKiloPriceDto) _then) =
      __$PerKiloPriceDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, double quantity, double price});
}

/// @nodoc
class __$PerKiloPriceDtoCopyWithImpl<$Res>
    implements _$PerKiloPriceDtoCopyWith<$Res> {
  __$PerKiloPriceDtoCopyWithImpl(this._self, this._then);

  final _PerKiloPriceDto _self;
  final $Res Function(_PerKiloPriceDto) _then;

  /// Create a copy of PerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(_PerKiloPriceDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
