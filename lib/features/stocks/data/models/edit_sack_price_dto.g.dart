// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_sack_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditSackPriceDto _$EditSackPriceDtoFromJson(Map<String, dynamic> json) =>
    _EditSackPriceDto(
      id: json['id'] as String,
      price: (json['price'] as num).toDouble(),
      specialPrice: json['specialPrice'] == null
          ? null
          : EditSpecialPriceDto.fromJson(
              json['specialPrice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditSackPriceDtoToJson(_EditSackPriceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'specialPrice': instance.specialPrice,
    };
