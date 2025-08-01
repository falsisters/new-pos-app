import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_model.dart';

part 'bill_count_model.freezed.dart';
part 'bill_count_model.g.dart';

@freezed
sealed class BillCountModel with _$BillCountModel {
  const factory BillCountModel({
    String? id,
    @Default([]) List<BillModel> bills,
    @Default(0) double totalCash,
    @Default(0) double totalExpenses,
    @Default(0) double netCash,
    @Default(0) double beginningBalance,
    @Default(false) bool showBeginningBalance,
    @Default({}) Map<String, dynamic> billsByType,
    DateTime? date,
    @Default(0) double billsTotal,
    @Default(0) double totalWithExpenses,
    @Default(0) double finalTotal,
    @Default(0) double summaryStep1,
    @Default(0) double summaryFinal,
  }) = _BillCountModel;

  factory BillCountModel.fromJson(Map<String, dynamic> json) =>
      _$BillCountModelFromJson(json);
}
