// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => _ProductDto(
      id: json['id'] as String,
      name: json['name'] as String,
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      isDiscounted: json['isDiscounted'] as bool?,
      isGantang: json['isGantang'] as bool?,
      isSpecialPrice: json['isSpecialPrice'] as bool?,
      perKiloPrice: json['perKiloPrice'] == null
          ? null
          : PerKiloPriceDto.fromJson(
              json['perKiloPrice'] as Map<String, dynamic>),
      sackPrice: json['sackPrice'] == null
          ? null
          : SackPriceDto.fromJson(json['sackPrice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductDtoToJson(_ProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'discountedPrice': instance.discountedPrice,
      'isDiscounted': instance.isDiscounted,
      'isGantang': instance.isGantang,
      'isSpecialPrice': instance.isSpecialPrice,
      'perKiloPrice': instance.perKiloPrice,
      'sackPrice': instance.sackPrice,
    };
