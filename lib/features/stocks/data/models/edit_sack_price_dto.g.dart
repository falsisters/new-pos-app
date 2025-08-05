// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_sack_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditSackPriceDto _$EditSackPriceDtoFromJson(Map<String, dynamic> json) =>
    _EditSackPriceDto(
      id: json['id'] as String,
      price: const DecimalConverter().fromJson(json['price'] as String),
      specialPrice: json['specialPrice'] == null
          ? null
          : EditSpecialPriceDto.fromJson(
              json['specialPrice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditSackPriceDtoToJson(_EditSackPriceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': const DecimalConverter().toJson(instance.price),
      'specialPrice': instance.specialPrice,
    };
