import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_info.freezed.dart';
part 'product_info.g.dart';

@freezed
sealed class ProductInfo with _$ProductInfo {
  const factory ProductInfo({
    required String id,
    required String name,
  }) = _ProductInfo;

  factory ProductInfo.fromJson(Map<String, dynamic> json) =>
      _$ProductInfoFromJson(json);
}
