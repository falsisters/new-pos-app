// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_sack_price_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferSackPriceDto {
  String get id;
  int get quantity;
  SackType get type;

  /// Create a copy of TransferSackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransferSackPriceDtoCopyWith<TransferSackPriceDto> get copyWith =>
      _$TransferSackPriceDtoCopyWithImpl<TransferSackPriceDto>(
          this as TransferSackPriceDto, _$identity);

  /// Serializes this TransferSackPriceDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransferSackPriceDto &&
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
    return 'TransferSackPriceDto(id: $id, quantity: $quantity, type: $type)';
  }
}

/// @nodoc
abstract mixin class $TransferSackPriceDtoCopyWith<$Res> {
  factory $TransferSackPriceDtoCopyWith(TransferSackPriceDto value,
          $Res Function(TransferSackPriceDto) _then) =
      _$TransferSackPriceDtoCopyWithImpl;
  @useResult
  $Res call({String id, int quantity, SackType type});
}

/// @nodoc
class _$TransferSackPriceDtoCopyWithImpl<$Res>
    implements $TransferSackPriceDtoCopyWith<$Res> {
  _$TransferSackPriceDtoCopyWithImpl(this._self, this._then);

  final TransferSackPriceDto _self;
  final $Res Function(TransferSackPriceDto) _then;

  /// Create a copy of TransferSackPriceDto
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
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as SackType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TransferSackPriceDto implements TransferSackPriceDto {
  const _TransferSackPriceDto(
      {required this.id, required this.quantity, required this.type});
  factory _TransferSackPriceDto.fromJson(Map<String, dynamic> json) =>
      _$TransferSackPriceDtoFromJson(json);

  @override
  final String id;
  @override
  final int quantity;
  @override
  final SackType type;

  /// Create a copy of TransferSackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransferSackPriceDtoCopyWith<_TransferSackPriceDto> get copyWith =>
      __$TransferSackPriceDtoCopyWithImpl<_TransferSackPriceDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransferSackPriceDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransferSackPriceDto &&
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
    return 'TransferSackPriceDto(id: $id, quantity: $quantity, type: $type)';
  }
}

/// @nodoc
abstract mixin class _$TransferSackPriceDtoCopyWith<$Res>
    implements $TransferSackPriceDtoCopyWith<$Res> {
  factory _$TransferSackPriceDtoCopyWith(_TransferSackPriceDto value,
          $Res Function(_TransferSackPriceDto) _then) =
      __$TransferSackPriceDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, int quantity, SackType type});
}

/// @nodoc
class __$TransferSackPriceDtoCopyWithImpl<$Res>
    implements _$TransferSackPriceDtoCopyWith<$Res> {
  __$TransferSackPriceDtoCopyWithImpl(this._self, this._then);

  final _TransferSackPriceDto _self;
  final $Res Function(_TransferSackPriceDto) _then;

  /// Create a copy of TransferSackPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? type = null,
  }) {
    return _then(_TransferSackPriceDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as SackType,
    ));
  }
}

// dart format on
