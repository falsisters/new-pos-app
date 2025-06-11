import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';

class InitialCountWidget extends StatelessWidget {
  final double totalCash;
  final double beginningBalance;
  final double expenses;
  final bool showExpenses;

  const InitialCountWidget({
    Key? key,
    required this.totalCash,
    required this.beginningBalance,
    this.expenses = 0.0,
    this.showExpenses = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,##0.00", "en_US");
    final netAmount = totalCash - beginningBalance;
    final finalAmount = netAmount + (showExpenses ? expenses : 0);
    final isNegative = netAmount < 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNegative ? Colors.red.shade300 : Colors.grey.shade200,
          width: isNegative ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CALCULATION BREAKDOWN",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),

          // Net Cash from Sales
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Net Cash (from Sales)",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "₱ ${currencyFormat.format(totalCash)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Beginning Balance (subtract)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Less: Beginning Balance",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "- ₱ ${currencyFormat.format(beginningBalance)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 1,
            color: Colors.grey.shade300,
          ),

          // Net Amount after Beginning Balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Net Amount",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isNegative ? Colors.red : Colors.black87,
                ),
              ),
              Text(
                "₱ ${currencyFormat.format(netAmount)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isNegative ? Colors.red : AppColors.primary,
                ),
              ),
            ],
          ),

          if (showExpenses) ...[
            const SizedBox(height: 8),

            // Add expenses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add: Expenses",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  "+ ₱ ${currencyFormat.format(expenses)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 1,
              color: Colors.grey.shade300,
            ),

            // Final calculation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "₱ ${currencyFormat.format(finalAmount)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
