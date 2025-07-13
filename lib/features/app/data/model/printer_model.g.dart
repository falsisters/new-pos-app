// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ThermalPrinter _$ThermalPrinterFromJson(Map<String, dynamic> json) =>
    _ThermalPrinter(
      name: json['name'] as String,
      address: json['address'] as String,
      isConnected: json['isConnected'] as bool? ?? false,
      isBonded: json['isBonded'] as bool? ?? false,
      connectionType: $enumDecodeNullable(
              _$ConnectionTypeEnumMap, json['connectionType']) ??
          ConnectionType.BLE,
      vendorId: json['vendorId'] as String?,
      productId: json['productId'] as String?,
    );

Map<String, dynamic> _$ThermalPrinterToJson(_ThermalPrinter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'isConnected': instance.isConnected,
      'isBonded': instance.isBonded,
      'connectionType': _$ConnectionTypeEnumMap[instance.connectionType]!,
      'vendorId': instance.vendorId,
      'productId': instance.productId,
    };

const _$ConnectionTypeEnumMap = {
  ConnectionType.BLE: 'BLE',
  ConnectionType.USB: 'USB',
  ConnectionType.NETWORK: 'NETWORK',
};
