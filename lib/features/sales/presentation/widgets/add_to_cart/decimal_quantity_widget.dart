import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecimalQuantityWidget extends StatelessWidget {
  final bool isGantangMode;
  final TextEditingController decimalQuantityController;
  final VoidCallback onIncreaseDecimalQuantity;
  final VoidCallback onDecreaseDecimalQuantity;

  const DecimalQuantityWidget({
    super.key,
    required this.isGantangMode,
    required this.decimalQuantityController,
    required this.onIncreaseDecimalQuantity,
    required this.onDecreaseDecimalQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.tune_outlined,
                      color: Colors.purple[700], size: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  isGantangMode ? 'Decimal Gantang' : 'Decimal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildDecimalInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildDecimalInput() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: decimalQuantityController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        decoration: _inputDecoration(
          labelText: 'Decimal',
          prefixText: '0.',
          suffixIcon: _buildDecimalControls(),
        ),
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            final decimal = int.tryParse(value);
            if (decimal == null || decimal < 0 || decimal > 99) {
              return 'Range: 0-99';
            }
          }
          return null;
        },
        onChanged: (value) {
          // Ensure proper formatting when user types
          if (value.isNotEmpty) {
            final intValue = int.tryParse(value);
            if (intValue != null && intValue >= 0 && intValue <= 99) {
              // Update the controller with proper padding if needed
              if (value.length == 1 && intValue > 0) {
                // Don't auto-pad single digits to allow 0.9 vs 0.09 distinction
                return;
              }
            }
          }
        },
      ),
    );
  }

  Widget _buildDecimalControls() {
    return SizedBox(
      width: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _quantityButton(Icons.remove, onDecreaseDecimalQuantity),
          const SizedBox(width: 2),
          _quantityButton(Icons.add, onIncreaseDecimalQuantity),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: AppColors.primary, size: 12),
        onPressed: onPressed,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    String? prefixText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: AppColors.primary, fontSize: 10),
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
    );
  }
}
