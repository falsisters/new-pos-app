import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_product_dto_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'truck_model.freezed.dart';
part 'truck_model.g.dart';

@freezed
sealed class TruckModel with _$TruckModel {
  const TruckModel._();

  const factory TruckModel({
    @Default([]) List<DeliveryProductDtoModel> products,
  }) = _TruckModel;

  factory TruckModel.fromJson(Map<String, dynamic> json) =>
      _$TruckModelFromJson(json);
}
