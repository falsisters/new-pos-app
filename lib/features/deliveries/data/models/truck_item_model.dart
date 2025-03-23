import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_product_dto_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'truck_item_model.freezed.dart';
part 'truck_item_model.g.dart';

@freezed
sealed class TruckItemModel with _$TruckItemModel {
  const factory TruckItemModel({
    required DeliveryProductDtoModel product,
  }) = _TruckItemModel;

  factory TruckItemModel.fromJson(Map<String, dynamic> json) =>
      _$TruckItemModelFromJson(json);
}
