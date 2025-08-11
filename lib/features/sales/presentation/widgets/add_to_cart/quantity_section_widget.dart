import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantitySectionWidget extends StatelessWidget {
  final Product product;
  final String? selectedSackPriceId;
  final bool isPerKiloSelected;
  final bool isGantangMode;
  final bool hasStock;
  final Decimal availableStock;
  final TextEditingController sackQuantityController;
  final TextEditingController wholeQuantityController;
  final TextEditingController perKiloTotalPriceController;
  final FocusNode perKiloTotalPriceFocusNode;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;
  final VoidCallback onIncreaseWholeQuantity;
  final VoidCallback onDecreaseWholeQuantity;
  final Function(double) onSetQuickQuantity;
  final Function(bool) onToggleGantangMode;
  final FocusNode focusNode;

  const QuantitySectionWidget({
    super.key,
    required this.product,
    required this.selectedSackPriceId,
    required this.isPerKiloSelected,
    required this.isGantangMode,
    required this.hasStock,
    required this.availableStock,
    required this.sackQuantityController,
    required this.wholeQuantityController,
    required this.perKiloTotalPriceController,
    required this.perKiloTotalPriceFocusNode,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    required this.onIncreaseWholeQuantity,
    required this.onDecreaseWholeQuantity,
    required this.onSetQuickQuantity,
    required this.onToggleGantangMode,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: Builder(
        builder: (context) {
          final isFocused = focusNode.hasFocus;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFocused
                    ? AppColors.secondary.withOpacity(0.8)
                    : AppColors.secondary.withOpacity(0.2),
                width: isFocused ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
                if (isFocused)
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
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
                          color: isFocused
                              ? AppColors.secondary
                              : AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.scale_outlined,
                          color: isFocused ? Colors.white : AppColors.secondary,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        selectedSackPriceId != null
                            ? 'Sacks'
                            : isGantangMode
                                ? 'Whole Gantang'
                                : 'Whole Kg',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      if (isPerKiloSelected) ...[
                        const Spacer(),
                        _buildQuantityModeTab(),
                      ] else if (isFocused) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            ', .',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                      if (isPerKiloSelected && isFocused) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            ', .',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildMainQuantityInput(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuantityModeTab() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabButton(
              'Kg', !isGantangMode, () => onToggleGantangMode(false)),
          _buildTabButton(
              'Gantang', isGantangMode, () => onToggleGantangMode(true)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildMainQuantityInput() {
    return Column(
      children: [
        // Quick Action Buttons
        if (hasStock) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildQuickActionButton('1', 1.0)),
              const SizedBox(width: 2),
              Expanded(child: _buildQuickActionButton('2', 2.0)),
              const SizedBox(width: 2),
              Expanded(child: _buildQuickActionButton('3', 3.0)),
              const SizedBox(width: 2),
              Expanded(child: _buildQuickActionButton('4', 4.0)),
              const SizedBox(width: 2),
              Expanded(child: _buildQuickActionButton('5', 5.0)),
            ],
          ),
          const SizedBox(height: 8),
        ],

        // Stock status messages
        if (!hasStock)
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.red[700], size: 12),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Out of Stock',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Quantity input field
        if (selectedSackPriceId != null)
          _buildSackQuantityField()
        else if (isPerKiloSelected)
          _buildWholeQuantityField(),

        // Total price field for per kilo
        if (isPerKiloSelected) ...[
          const SizedBox(height: 6),
          _buildTotalPriceField(),
        ],
      ],
    );
  }

  Widget _buildSackQuantityField() {
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
        controller: sackQuantityController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        enabled: hasStock,
        decoration: _inputDecoration(
          labelText: 'Sacks',
          suffixIcon: hasStock ? _buildQuantityControls() : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Enter quantity';
          final qty = int.tryParse(value);
          if (qty == null || qty <= 0) return 'Valid quantity > 0';
          if (Decimal.fromInt(qty) > availableStock) {
            return 'Only ${availableStock.toStringAsFixed(0)} available';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildWholeQuantityField() {
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
        controller: wholeQuantityController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        enabled: hasStock,
        decoration: _inputDecoration(
          labelText: isGantangMode ? 'Whole Gantang' : 'Whole Kg',
          suffixIcon: hasStock ? _buildWholeQuantityControls() : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Enter quantity';
          return null;
        },
      ),
    );
  }

  Widget _buildTotalPriceField() {
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
        controller: perKiloTotalPriceController,
        focusNode: perKiloTotalPriceFocusNode,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        enabled: hasStock,
        decoration: _inputDecoration(
          labelText: 'Total ₱',
          prefixText: '₱ ',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Enter total price';
          final priceVal = double.tryParse(value);
          if (priceVal == null || priceVal < 0) return 'Valid price >= 0';
          return null;
        },
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

  Widget _buildQuantityControls() {
    return SizedBox(
      width: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _quantityButton(Icons.remove, onDecreaseQuantity),
          const SizedBox(width: 2),
          _quantityButton(Icons.add, onIncreaseQuantity),
        ],
      ),
    );
  }

  Widget _buildWholeQuantityControls() {
    return SizedBox(
      width: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _quantityButton(Icons.remove, onDecreaseWholeQuantity),
          const SizedBox(width: 2),
          _quantityButton(Icons.add, onIncreaseWholeQuantity),
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

  Widget _buildQuickActionButton(String label, double quantity) {
    String unit = selectedSackPriceId != null
        ? 'sack'
        : isGantangMode
            ? 'gantang'
            : 'kg';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasStock ? () => onSetQuickQuantity(quantity) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: hasStock
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasStock
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: hasStock ? AppColors.primary : Colors.grey[500],
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: hasStock
                      ? AppColors.primary.withOpacity(0.7)
                      : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
