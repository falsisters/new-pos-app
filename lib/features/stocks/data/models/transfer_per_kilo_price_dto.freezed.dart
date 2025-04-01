// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_per_kilo_price_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferPerKiloPriceDto {
  String get id;
  double get quantity;

  /// Create a copy of TransferPerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransferPerKiloPriceDtoCopyWith<TransferPerKiloPriceDto> get copyWith =>
      _$TransferPerKiloPriceDtoCopyWithImpl<TransferPerKiloPriceDto>(
          this as TransferPerKiloPriceDto, _$identity);

  /// Serializes this TransferPerKiloPriceDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransferPerKiloPriceDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, quantity);

  @override
  String toString() {
    return 'TransferPerKiloPriceDto(id: $id, quantity: $quantity)';
  }
}

/// @nodoc
abstract mixin class $TransferPerKiloPriceDtoCopyWith<$Res> {
  factory $TransferPerKiloPriceDtoCopyWith(TransferPerKiloPriceDto value,
          $Res Function(TransferPerKiloPriceDto) _then) =
      _$TransferPerKiloPriceDtoCopyWithImpl;
  @useResult
  $Res call({String id, double quantity});
}

/// @nodoc
class _$TransferPerKiloPriceDtoCopyWithImpl<$Res>
    implements $TransferPerKiloPriceDtoCopyWith<$Res> {
  _$TransferPerKiloPriceDtoCopyWithImpl(this._self, this._then);

  final TransferPerKiloPriceDto _self;
  final $Res Function(TransferPerKiloPriceDto) _then;

  /// Create a copy of TransferPerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TransferPerKiloPriceDto implements TransferPerKiloPriceDto {
  const _TransferPerKiloPriceDto({required this.id, required this.quantity});
  factory _TransferPerKiloPriceDto.fromJson(Map<String, dynamic> json) =>
      _$TransferPerKiloPriceDtoFromJson(json);

  @override
  final String id;
  @override
  final double quantity;

  /// Create a copy of TransferPerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransferPerKiloPriceDtoCopyWith<_TransferPerKiloPriceDto> get copyWith =>
      __$TransferPerKiloPriceDtoCopyWithImpl<_TransferPerKiloPriceDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransferPerKiloPriceDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransferPerKiloPriceDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, quantity);

  @override
  String toString() {
    return 'TransferPerKiloPriceDto(id: $id, quantity: $quantity)';
  }
}

/// @nodoc
abstract mixin class _$TransferPerKiloPriceDtoCopyWith<$Res>
    implements $TransferPerKiloPriceDtoCopyWith<$Res> {
  factory _$TransferPerKiloPriceDtoCopyWith(_TransferPerKiloPriceDto value,
          $Res Function(_TransferPerKiloPriceDto) _then) =
      __$TransferPerKiloPriceDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, double quantity});
}

/// @nodoc
class __$TransferPerKiloPriceDtoCopyWithImpl<$Res>
    implements _$TransferPerKiloPriceDtoCopyWith<$Res> {
  __$TransferPerKiloPriceDtoCopyWithImpl(this._self, this._then);

  final _TransferPerKiloPriceDto _self;
  final $Res Function(_TransferPerKiloPriceDto) _then;

  /// Create a copy of TransferPerKiloPriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? quantity = null,
  }) {
    return _then(_TransferPerKiloPriceDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
