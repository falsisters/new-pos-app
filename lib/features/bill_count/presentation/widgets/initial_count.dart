import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';

class InitialCountWidget extends StatelessWidget {
  final double totalCash;
  final double beginningBalance;

  const InitialCountWidget({
    Key? key,
    required this.totalCash,
    required this.beginningBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0.00", "en_US");
    final initialCount = totalCash - beginningBalance;
    final isNegative = initialCount < 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isNegative ? Colors.red.shade50 : AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isNegative ? Colors.red : Colors.grey.shade300,
          width: isNegative ? 2 : 1,
        ),
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
          Row(
            children: [
              const Text(
                "INITIAL COUNT",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "(Total Cash - Beginning Balance)",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Text(
            "₱ ${currencyFormat.format(initialCount)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isNegative ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
