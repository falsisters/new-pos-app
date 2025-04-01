// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_per_kilo_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferPerKiloPriceDto _$TransferPerKiloPriceDtoFromJson(
        Map<String, dynamic> json) =>
    _TransferPerKiloPriceDto(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$TransferPerKiloPriceDtoToJson(
        _TransferPerKiloPriceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
    };
