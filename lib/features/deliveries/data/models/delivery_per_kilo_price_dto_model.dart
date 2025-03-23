import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_per_kilo_price_dto_model.freezed.dart';
part 'delivery_per_kilo_price_dto_model.g.dart';

@freezed
sealed class DeliveryPerKiloPriceDtoModel with _$DeliveryPerKiloPriceDtoModel {
  const factory DeliveryPerKiloPriceDtoModel({
    required String id,
    required double quantity,
  }) = _DeliveryPerKiloPriceDtoModel;

  factory DeliveryPerKiloPriceDtoModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryPerKiloPriceDtoModelFromJson(json);
}
