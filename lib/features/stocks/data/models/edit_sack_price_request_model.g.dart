// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_sack_price_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditSackPriceRequestModel _$EditSackPriceRequestModelFromJson(
        Map<String, dynamic> json) =>
    _EditSackPriceRequestModel(
      sackPrice: (json['sackPrice'] as List<dynamic>)
          .map((e) => EditSackPriceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EditSackPriceRequestModelToJson(
        _EditSackPriceRequestModel instance) =>
    <String, dynamic>{
      'sackPrice': instance.sackPrice,
    };
