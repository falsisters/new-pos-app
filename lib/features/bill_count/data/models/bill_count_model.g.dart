// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_count_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillCountModel _$BillCountModelFromJson(Map<String, dynamic> json) =>
    _BillCountModel(
      id: json['id'] as String?,
      bills: (json['bills'] as List<dynamic>?)
              ?.map((e) => BillModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      startingAmount: (json['startingAmount'] as num?)?.toDouble() ?? 0,
      expenses: (json['expenses'] as num?)?.toDouble() ?? 0,
      showExpenses: json['showExpenses'] as bool? ?? false,
      beginningBalance: (json['beginningBalance'] as num?)?.toDouble() ?? 0,
      showBeginningBalance: json['showBeginningBalance'] as bool? ?? false,
      billsByType: json['billsByType'] as Map<String, dynamic>? ?? const {},
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      billsTotal: (json['billsTotal'] as num?)?.toDouble() ?? 0,
      totalWithExpenses: (json['totalWithExpenses'] as num?)?.toDouble() ?? 0,
      finalTotal: (json['finalTotal'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$BillCountModelToJson(_BillCountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bills': instance.bills,
      'startingAmount': instance.startingAmount,
      'expenses': instance.expenses,
      'showExpenses': instance.showExpenses,
      'beginningBalance': instance.beginningBalance,
      'showBeginningBalance': instance.showBeginningBalance,
      'billsByType': instance.billsByType,
      'date': instance.date?.toIso8601String(),
      'billsTotal': instance.billsTotal,
      'totalWithExpenses': instance.totalWithExpenses,
      'finalTotal': instance.finalTotal,
    };
