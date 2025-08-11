// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Cashier _$CashierFromJson(Map<String, dynamic> json) => _Cashier(
      name: json['name'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$CashierToJson(_Cashier instance) => <String, dynamic>{
      'name': instance.name,
      'userId': instance.userId,
    };

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
      id: json['id'] as String,
      name: json['name'] as String,
      picture: json['picture'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String,
      sackPrice: (json['SackPrice'] as List<dynamic>)
          .map((e) => SackPrice.fromJson(e as Map<String, dynamic>))
          .toList(),
      perKiloPrice: json['perKiloPrice'] == null
          ? null
          : PerKiloPrice.fromJson(json['perKiloPrice'] as Map<String, dynamic>),
      cashier: json['cashier'] == null
          ? null
          : Cashier.fromJson(json['cashier'] as Map<String, dynamic>),
      cashierId: json['cashierId'] as String?,
    );

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'picture': instance.picture,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userId': instance.userId,
      'SackPrice': instance.sackPrice,
      'perKiloPrice': instance.perKiloPrice,
      'cashier': instance.cashier,
      'cashierId': instance.cashierId,
    };
