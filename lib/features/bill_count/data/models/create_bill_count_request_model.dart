import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_model.dart';

part 'create_bill_count_request_model.freezed.dart';
part 'create_bill_count_request_model.g.dart';

@freezed
sealed class CreateBillCountRequestModel with _$CreateBillCountRequestModel {
  const factory CreateBillCountRequestModel({
    String? date,
    double? startingAmount,
    double? totalCash,
    double? expenses,
    bool? showExpenses,
    double? beginningBalance,
    bool? showBeginningBalance,
    List<BillModel>? bills,
  }) = _CreateBillCountRequestModel;

  factory CreateBillCountRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateBillCountRequestModelFromJson(json);
}
