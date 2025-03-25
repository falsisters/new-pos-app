// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_per_kilo_price_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditPerKiloPriceRequest _$EditPerKiloPriceRequestFromJson(
        Map<String, dynamic> json) =>
    _EditPerKiloPriceRequest(
      perKiloPrice: EditPerKiloPriceDto.fromJson(
          json['perKiloPrice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditPerKiloPriceRequestToJson(
        _EditPerKiloPriceRequest instance) =>
    <String, dynamic>{
      'perKiloPrice': instance.perKiloPrice,
    };
