import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';

class TotalCashWidget extends StatelessWidget {
  final double totalCash;
  final VoidCallback onEdit;

  const TotalCashWidget({
    Key? key,
    required this.totalCash,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0.00", "en_US");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "TOTAL CASH",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Row(
            children: [
              Text(
                "₱ ${currencyFormat.format(totalCash)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit),
                color: AppColors.primary,
                onPressed: onEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
