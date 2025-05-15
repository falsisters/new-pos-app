import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_item_dto.freezed.dart';
part 'expense_item_dto.g.dart';

@freezed
sealed class ExpenseItemDto with _$ExpenseItemDto {
  const factory ExpenseItemDto({
    required String name,
    required double amount,
  }) = _ExpenseItemDto;

  factory ExpenseItemDto.fromJson(Map<String, dynamic> json) =>
      _$ExpenseItemDtoFromJson(json);
}
