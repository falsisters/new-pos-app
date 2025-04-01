// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_sack_price_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditSackPriceDto {
  String get id;
  double get price;
  EditSpecialPriceDto? get specialPrice;

  /// Create a copy of EditSackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EditSackPriceDtoCopyWith<EditSackPriceDto> get copyWith =>
      _$EditSackPriceDtoCopyWithImpl<EditSackPriceDto>(
          this as EditSackPriceDto, _$identity);

  /// Serializes this EditSackPriceDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EditSackPriceDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.specialPrice, specialPrice) ||
                other.specialPrice == specialPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, price, specialPrice);

  @override
  String toString() {
    return 'EditSackPriceDto(id: $id, price: $price, specialPrice: $specialPrice)';
  }
}

/// @nodoc
abstract mixin class $EditSackPriceDtoCopyWith<$Res> {
  factory $EditSackPriceDtoCopyWith(
          EditSackPriceDto value, $Res Function(EditSackPriceDto) _then) =
      _$EditSackPriceDtoCopyWithImpl;
  @useResult
  $Res call({String id, double price, EditSpecialPriceDto? specialPrice});

  $EditSpecialPriceDtoCopyWith<$Res>? get specialPrice;
}

/// @nodoc
class _$EditSackPriceDtoCopyWithImpl<$Res>
    implements $EditSackPriceDtoCopyWith<$Res> {
  _$EditSackPriceDtoCopyWithImpl(this._self, this._then);

  final EditSackPriceDto _self;
  final $Res Function(EditSackPriceDto) _then;

  /// Create a copy of EditSackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? specialPrice = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      specialPrice: freezed == specialPrice
          ? _self.specialPrice
          : specialPrice // ignore: cast_nullable_to_non_nullable
              as EditSpecialPriceDto?,
    ));
  }

  /// Create a copy of EditSackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EditSpecialPriceDtoCopyWith<$Res>? get specialPrice {
    if (_self.specialPrice == null) {
      return null;
    }

    return $EditSpecialPriceDtoCopyWith<$Res>(_self.specialPrice!, (value) {
      return _then(_self.copyWith(specialPrice: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _EditSackPriceDto implements EditSackPriceDto {
  const _EditSackPriceDto(
      {required this.id, required this.price, required this.specialPrice});
  factory _EditSackPriceDto.fromJson(Map<String, dynamic> json) =>
      _$EditSackPriceDtoFromJson(json);

  @override
  final String id;
  @override
  final double price;
  @override
  final EditSpecialPriceDto? specialPrice;

  /// Create a copy of EditSackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EditSackPriceDtoCopyWith<_EditSackPriceDto> get copyWith =>
      __$EditSackPriceDtoCopyWithImpl<_EditSackPriceDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EditSackPriceDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EditSackPriceDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.specialPrice, specialPrice) ||
                other.specialPrice == specialPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, price, specialPrice);

  @override
  String toString() {
    return 'EditSackPriceDto(id: $id, price: $price, specialPrice: $specialPrice)';
  }
}

/// @nodoc
abstract mixin class _$EditSackPriceDtoCopyWith<$Res>
    implements $EditSackPriceDtoCopyWith<$Res> {
  factory _$EditSackPriceDtoCopyWith(
          _EditSackPriceDto value, $Res Function(_EditSackPriceDto) _then) =
      __$EditSackPriceDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, double price, EditSpecialPriceDto? specialPrice});

  @override
  $EditSpecialPriceDtoCopyWith<$Res>? get specialPrice;
}

/// @nodoc
class __$EditSackPriceDtoCopyWithImpl<$Res>
    implements _$EditSackPriceDtoCopyWith<$Res> {
  __$EditSackPriceDtoCopyWithImpl(this._self, this._then);

  final _EditSackPriceDto _self;
  final $Res Function(_EditSackPriceDto) _then;

  /// Create a copy of EditSackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? specialPrice = freezed,
  }) {
    return _then(_EditSackPriceDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      specialPrice: freezed == specialPrice
          ? _self.specialPrice
          : specialPrice // ignore: cast_nullable_to_non_nullable
              as EditSpecialPriceDto?,
    ));
  }

  /// Create a copy of EditSackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EditSpecialPriceDtoCopyWith<$Res>? get specialPrice {
    if (_self.specialPrice == null) {
      return null;
    }

    return $EditSpecialPriceDtoCopyWith<$Res>(_self.specialPrice!, (value) {
      return _then(_self.copyWith(specialPrice: value));
    });
  }
}

// dart format on
