import 'package:falsisters_pos_android/features/stocks/data/models/transfer_product_request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_model.freezed.dart';
part 'transfer_model.g.dart';

@freezed
sealed class TransferModel with _$TransferModel {
  const factory TransferModel({
    required String id,
    required double quantity,
    required String name,
    required TransferType type,
    required String cashierId,
    required String createdAt,
    required String updatedAt,
  }) = _TransferModel;

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);
}
