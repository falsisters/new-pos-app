// ignore_for_file: invalid_annotation_target

import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_product_dto_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_delivery_request_model.freezed.dart';
part 'create_delivery_request_model.g.dart';

@freezed
sealed class CreateDeliveryRequestModel with _$CreateDeliveryRequestModel {
  const factory CreateDeliveryRequestModel({
    required String driverName,
    required DateTime deliveryTimeStart,
    @JsonKey(name: 'deliveryItem')
    required List<DeliveryProductDtoModel> deliveryItems,
  }) = _CreateDeliveryRequestModel;

  factory CreateDeliveryRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateDeliveryRequestModelFromJson(json);
}
