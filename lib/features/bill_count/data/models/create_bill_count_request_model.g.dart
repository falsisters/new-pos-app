// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_bill_count_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateBillCountRequestModel _$CreateBillCountRequestModelFromJson(
        Map<String, dynamic> json) =>
    _CreateBillCountRequestModel(
      date: json['date'] as String?,
      startingAmount: (json['startingAmount'] as num?)?.toDouble(),
      totalCash: (json['totalCash'] as num?)?.toDouble(),
      expenses: (json['expenses'] as num?)?.toDouble(),
      showExpenses: json['showExpenses'] as bool?,
      beginningBalance: (json['beginningBalance'] as num?)?.toDouble(),
      showBeginningBalance: json['showBeginningBalance'] as bool?,
      bills: (json['bills'] as List<dynamic>?)
          ?.map((e) => BillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateBillCountRequestModelToJson(
        _CreateBillCountRequestModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'startingAmount': instance.startingAmount,
      'totalCash': instance.totalCash,
      'expenses': instance.expenses,
      'showExpenses': instance.showExpenses,
      'beginningBalance': instance.beginningBalance,
      'showBeginningBalance': instance.showBeginningBalance,
      'bills': instance.bills,
    };
