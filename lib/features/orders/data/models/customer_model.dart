import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
sealed class CustomerModel with _$CustomerModel {
  const factory CustomerModel({
    required String id,
    required String name,
    required String phone,
    required String address,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);
}
