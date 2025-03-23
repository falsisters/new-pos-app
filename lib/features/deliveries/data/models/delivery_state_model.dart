import 'package:falsisters_pos_android/features/deliveries/data/models/truck_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_state_model.freezed.dart';
part 'delivery_state_model.g.dart';

@freezed
sealed class DeliveryStateModel with _$DeliveryStateModel {
  const factory DeliveryStateModel({
    required TruckModel truck,
    String? error,
  }) = _DeliveryStateModel;

  factory DeliveryStateModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryStateModelFromJson(json);
}
