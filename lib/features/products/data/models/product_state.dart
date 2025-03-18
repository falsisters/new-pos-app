import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_state.freezed.dart';
part 'product_state.g.dart';

@freezed
sealed class ProductState with _$ProductState {
  const factory ProductState({
    required List<Product> products,
    @Default(false) bool isLoading,
    String? error,
  }) = _ProductState;

  factory ProductState.fromJson(Map<String, dynamic> json) =>
      _$ProductStateFromJson(json);
}
