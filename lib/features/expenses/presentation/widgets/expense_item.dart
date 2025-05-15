import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseItemWidget extends StatelessWidget {
  final String name;
  final double amount;
  final VoidCallback? onRemove;

  const ExpenseItemWidget({
    super.key,
    required this.name,
    required this.amount,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_PH', symbol: '₱ ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            currencyFormatter.format(amount),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onRemove,
              color: Colors.redAccent,
              splashRadius: 20,
            ),
        ],
      ),
    );
  }
}
