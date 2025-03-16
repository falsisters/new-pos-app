// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sack_price_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SackPriceDto {
  String get id;
  double get quantity;
  SackType get type;

  /// Create a copy of SackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SackPriceDtoCopyWith<SackPriceDto> get copyWith =>
      _$SackPriceDtoCopyWithImpl<SackPriceDto>(
          this as SackPriceDto, _$identity);

  /// Serializes this SackPriceDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SackPriceDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, quantity, type);

  @override
  String toString() {
    return 'SackPriceDto(id: $id, quantity: $quantity, type: $type)';
  }
}

/// @nodoc
abstract mixin class $SackPriceDtoCopyWith<$Res> {
  factory $SackPriceDtoCopyWith(
          SackPriceDto value, $Res Function(SackPriceDto) _then) =
      _$SackPriceDtoCopyWithImpl;
  @useResult
  $Res call({String id, double quantity, SackType type});
}

/// @nodoc
class _$SackPriceDtoCopyWithImpl<$Res> implements $SackPriceDtoCopyWith<$Res> {
  _$SackPriceDtoCopyWithImpl(this._self, this._then);

  final SackPriceDto _self;
  final $Res Function(SackPriceDto) _then;

  /// Create a copy of SackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? type = null,
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
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as SackType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SackPriceDto implements SackPriceDto {
  const _SackPriceDto(
      {required this.id, required this.quantity, required this.type});
  factory _SackPriceDto.fromJson(Map<String, dynamic> json) =>
      _$SackPriceDtoFromJson(json);

  @override
  final String id;
  @override
  final double quantity;
  @override
  final SackType type;

  /// Create a copy of SackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SackPriceDtoCopyWith<_SackPriceDto> get copyWith =>
      __$SackPriceDtoCopyWithImpl<_SackPriceDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SackPriceDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SackPriceDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, quantity, type);

  @override
  String toString() {
    return 'SackPriceDto(id: $id, quantity: $quantity, type: $type)';
  }
}

/// @nodoc
abstract mixin class _$SackPriceDtoCopyWith<$Res>
    implements $SackPriceDtoCopyWith<$Res> {
  factory _$SackPriceDtoCopyWith(
          _SackPriceDto value, $Res Function(_SackPriceDto) _then) =
      __$SackPriceDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, double quantity, SackType type});
}

/// @nodoc
class __$SackPriceDtoCopyWithImpl<$Res>
    implements _$SackPriceDtoCopyWith<$Res> {
  __$SackPriceDtoCopyWithImpl(this._self, this._then);

  final _SackPriceDto _self;
  final $Res Function(_SackPriceDto) _then;

  /// Create a copy of SackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? type = null,
  }) {
    return _then(_SackPriceDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as SackType,
    ));
  }
}

// dart format on
