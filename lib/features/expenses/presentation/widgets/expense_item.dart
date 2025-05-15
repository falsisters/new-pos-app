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
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            currencyFormatter.format(amount),
            style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        trailing: onRemove != null
            ? IconButton(
                icon: Icon(Icons.delete_outline, color: AppColors.accent),
                onPressed: onRemove,
              )
            : null,
      ),
    );
  }
}
