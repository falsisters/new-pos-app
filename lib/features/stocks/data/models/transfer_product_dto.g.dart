// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferProductDto _$TransferProductDtoFromJson(Map<String, dynamic> json) =>
    _TransferProductDto(
      id: json['id'] as String,
      perKiloPrice: json['perKiloPrice'] == null
          ? null
          : TransferPerKiloPriceDto.fromJson(
              json['perKiloPrice'] as Map<String, dynamic>),
      sackPrice: json['sackPrice'] == null
          ? null
          : TransferSackPriceDto.fromJson(
              json['sackPrice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransferProductDtoToJson(_TransferProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'perKiloPrice': instance.perKiloPrice,
      'sackPrice': instance.sackPrice,
    };
