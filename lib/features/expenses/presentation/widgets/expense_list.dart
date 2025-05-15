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
    final double totalAmount =
        items.fold(0.0, (sum, item) => sum + item.amount);
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Text(
                'Expense Items',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                child: Center(
                  child: Text(
                    'No expense items added yet.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ExpenseItemWidget(
                    name: item.name,
                    amount: item.amount,
                    onRemove: onItemRemove != null
                        ? () => onItemRemove!(index)
                        : null,
                  );
                },
              ),
            const Divider(thickness: 1.5),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    currencyFormatter.format(totalAmount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
