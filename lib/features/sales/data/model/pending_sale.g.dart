// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PendingSale _$PendingSaleFromJson(Map<String, dynamic> json) => _PendingSale(
      id: json['id'] as String,
      saleRequest: CreateSaleRequestModel.fromJson(
          json['saleRequest'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isProcessing: json['isProcessing'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$PendingSaleToJson(_PendingSale instance) =>
    <String, dynamic>{
      'id': instance.id,
      'saleRequest': instance.saleRequest,
      'timestamp': instance.timestamp.toIso8601String(),
      'isProcessing': instance.isProcessing,
      'error': instance.error,
    };
