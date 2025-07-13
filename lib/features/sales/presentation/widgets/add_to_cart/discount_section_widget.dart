import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/constants/currency_input_formatter.dart';

class DiscountSectionWidget extends StatelessWidget {
  final bool isDiscounted;
  final bool isSackSelected;
  final TextEditingController discountedPriceController;
  final Function(bool?) onDiscountToggle;

  const DiscountSectionWidget({
    super.key,
    required this.isDiscounted,
    required this.isSackSelected,
    required this.discountedPriceController,
    required this.onDiscountToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
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
                    color: Colors.orange.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.local_offer_outlined,
                      color: Colors.orange[700], size: 14),
                ),
                const SizedBox(width: 12),
                Checkbox(
                  value: isDiscounted,
                  onChanged: onDiscountToggle,
                  activeColor: Colors.orange[700],
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Discount',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildDiscountInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountInput() {
    return Column(
      children: [
        if (isDiscounted)
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orange[700], size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Price per ${isSackSelected ? 'sack' : 'kg'}',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: discountedPriceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: _inputDecoration(
                    labelText: 'Unit Price ₱',
                    prefixText: '₱ ',
                  ),
                  validator: (value) {
                    if (isDiscounted) {
                      if (value == null || value.isEmpty)
                        return 'Enter discounted price';
                      final cleanValue = value.replaceAll(',', '');
                      final priceVal = double.tryParse(cleanValue);
                      if (priceVal == null || priceVal <= 0)
                        return 'Valid price > 0';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    String? prefixText,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
    );
  }
}
