import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/expense_item_dto.dart';
import 'package:falsisters_pos_android/features/expenses/presentation/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseListWidget extends StatelessWidget {
  final List<ExpenseItemDto> items;
  final Function(int)? onItemRemove;

  const ExpenseListWidget({
    super.key,
    required this.items,
    this.onItemRemove,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("ExpenseListWidget build with ${items.length} items");
    final double totalAmount =
        items.fold(0.0, (sum, item) => sum + item.amount);
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_PH', symbol: '₱ ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with item count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Expense Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${items.length} items',
              style: TextStyle(color: AppColors.primary),
            ),
          ],
        ),

        const SizedBox(height: 8),
        const Divider(),

        // Empty state
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text(
                'No expense items added yet',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        // Items list
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              debugPrint("Building item $index: ${item.name}");
              return ExpenseItemWidget(
                name: item.name,
                amount: item.amount,
                onRemove:
                    onItemRemove != null ? () => onItemRemove!(index) : null,
              );
            },
          ),

        // Total section if there are items
        if (items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currencyFormatter.format(totalAmount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
