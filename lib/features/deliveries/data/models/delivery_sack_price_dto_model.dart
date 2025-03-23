import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_sack_price_dto_model.freezed.dart';
part 'delivery_sack_price_dto_model.g.dart';

@freezed
sealed class DeliverySackPriceDtoModel with _$DeliverySackPriceDtoModel {
  const factory DeliverySackPriceDtoModel({
    required String id,
    required SackType type,
    required double quantity,
  }) = _DeliverySackPriceDtoModel;

  factory DeliverySackPriceDtoModel.fromJson(Map<String, dynamic> json) =>
      _$DeliverySackPriceDtoModelFromJson(json);
}
