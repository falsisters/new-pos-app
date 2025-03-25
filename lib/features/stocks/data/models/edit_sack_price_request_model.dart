import 'package:falsisters_pos_android/features/stocks/data/models/edit_sack_price_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_sack_price_request_model.freezed.dart';
part 'edit_sack_price_request_model.g.dart';

@freezed
sealed class EditSackPriceRequestModel with _$EditSackPriceRequestModel {
  const factory EditSackPriceRequestModel({
    required List<EditSackPriceDto> sackPrice,
  }) = _EditSackPriceRequestModel;

  factory EditSackPriceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EditSackPriceRequestModelFromJson(json);
}
