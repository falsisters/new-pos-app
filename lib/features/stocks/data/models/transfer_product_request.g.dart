// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_product_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferProductRequest _$TransferProductRequestFromJson(
        Map<String, dynamic> json) =>
    _TransferProductRequest(
      product:
          TransferProductDto.fromJson(json['product'] as Map<String, dynamic>),
      transferType: $enumDecode(_$TransferTypeEnumMap, json['transferType']),
    );

Map<String, dynamic> _$TransferProductRequestToJson(
        _TransferProductRequest instance) =>
    <String, dynamic>{
      'product': instance.product,
      'transferType': _$TransferTypeEnumMap[instance.transferType]!,
    };

const _$TransferTypeEnumMap = {
  TransferType.OWN_CONSUMPTION: 'OWN_CONSUMPTION',
  TransferType.RETURN_TO_WAREHOUSE: 'RETURN_TO_WAREHOUSE',
  TransferType.KAHON: 'KAHON',
  TransferType.REPACK: 'REPACK',
};
