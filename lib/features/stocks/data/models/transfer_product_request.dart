import 'package:falsisters_pos_android/features/stocks/data/models/transfer_product_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_product_request.freezed.dart';
part 'transfer_product_request.g.dart';

enum TransferType {
  OWN_CONSUMPTION,
  RETURN_TO_WAREHOUSE,
  KAHON,
  REPACK,
}

String parseTransferType(TransferType type) {
  switch (type) {
    case TransferType.OWN_CONSUMPTION:
      return 'Own Consumption';
    case TransferType.RETURN_TO_WAREHOUSE:
      return 'Return to Warehouse';
    case TransferType.KAHON:
      return 'Kahon';
    case TransferType.REPACK:
      return 'Repack';
  }
}

@freezed
sealed class TransferProductRequest with _$TransferProductRequest {
  const factory TransferProductRequest({
    required TransferProductDto product,
    required TransferType transferType,
  }) = _TransferProductRequest;

  factory TransferProductRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferProductRequestFromJson(json);
}
