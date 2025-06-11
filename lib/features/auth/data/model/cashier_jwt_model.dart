import 'package:freezed_annotation/freezed_annotation.dart';
part 'cashier_jwt_model.freezed.dart';
part 'cashier_jwt_model.g.dart';

@freezed
sealed class CashierJwtModel with _$CashierJwtModel {
  const factory CashierJwtModel({
    required String id,
    required String name,
    required String userId,
    required String secureCode,
    required List<String> permissions,
  }) = _CashierJwtModel;

  factory CashierJwtModel.fromJson(Map<String, dynamic> json) =>
      _$CashierJwtModelFromJson(json);
}
