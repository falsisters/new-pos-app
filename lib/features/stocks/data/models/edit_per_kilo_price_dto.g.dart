// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_per_kilo_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditPerKiloPriceDto _$EditPerKiloPriceDtoFromJson(Map<String, dynamic> json) =>
    _EditPerKiloPriceDto(
      price: const DecimalConverter().fromJson(json['price'] as String),
    );

Map<String, dynamic> _$EditPerKiloPriceDtoToJson(
        _EditPerKiloPriceDto instance) =>
    <String, dynamic>{
      'price': const DecimalConverter().toJson(instance.price),
    };
