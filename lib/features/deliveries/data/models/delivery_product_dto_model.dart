import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_per_kilo_price_dto_model.dart';
import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_sack_price_dto_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_product_dto_model.freezed.dart';
part 'delivery_product_dto_model.g.dart';

@freezed
sealed class DeliveryProductDtoModel with _$DeliveryProductDtoModel {
  const factory DeliveryProductDtoModel({
    required String id,
    required String name,
    DeliveryPerKiloPriceDtoModel? perKiloPrice,
    DeliverySackPriceDtoModel? sackPrice,
  }) = _DeliveryProductDtoModel;

  factory DeliveryProductDtoModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryProductDtoModelFromJson(json);
}
