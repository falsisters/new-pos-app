import 'package:falsisters_pos_android/features/stocks/data/models/edit_per_kilo_price_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_per_kilo_price_request.freezed.dart';
part 'edit_per_kilo_price_request.g.dart';

@freezed
sealed class EditPerKiloPriceRequest with _$EditPerKiloPriceRequest {
  const factory EditPerKiloPriceRequest({
    required EditPerKiloPriceDto perKiloPrice,
  }) = _EditPerKiloPriceRequest;

  factory EditPerKiloPriceRequest.fromJson(Map<String, dynamic> json) =>
      _$EditPerKiloPriceRequestFromJson(json);
}
