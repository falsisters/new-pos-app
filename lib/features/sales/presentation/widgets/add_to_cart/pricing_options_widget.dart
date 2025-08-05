import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_sack_type.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';

class PricingOptionsWidget extends StatelessWidget {
  final Product product;
  final String? selectedSackPriceId;
  final bool isSpecialPrice;
  final bool isPerKiloSelected;
  final Function(String id, {bool isSpecial, int? minimumQty})
      onSelectSackPrice;
  final VoidCallback onSelectPerKilo;
  final FocusNode focusNode;

  const PricingOptionsWidget({
    super.key,
    required this.product,
    required this.selectedSackPriceId,
    required this.isSpecialPrice,
    required this.isPerKiloSelected,
    required this.onSelectSackPrice,
    required this.onSelectPerKilo,
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
                    ? AppColors.accent.withOpacity(0.8)
                    : AppColors.accent.withOpacity(0.2),
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
                    color: AppColors.accent.withOpacity(0.2),
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
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: (isFocused
                              ? AppColors.accent
                              : AppColors.accent.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.payments_outlined,
                          color: isFocused ? Colors.white : AppColors.accent,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pricing Options',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                      if (isFocused) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '←→',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildPricingOptions(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPricingOptions() {
    final hasPerKilo = product.perKiloPrice != null;
    final hasSackPrices = product.sackPrice.isNotEmpty;

    if (!hasPerKilo && !hasSackPrices) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'No pricing options available for this product',
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    List<Widget> allOptions = [];

    // Add per kilo option
    if (hasPerKilo) {
      allOptions.add(
        _buildOptionCard(
          isSelected: isPerKiloSelected,
          onTap: onSelectPerKilo,
          icon: Icons.scale_rounded,
          title: 'Per Kilogram',
          subtitle: '₱${product.perKiloPrice!.price.toStringAsFixed(2)} / kg',
          stock:
              '${product.perKiloPrice!.stock.toStringAsFixed(1)} kg available',
          color: Colors.green,
        ),
      );
    }

    // Add sack options
    if (hasSackPrices) {
      for (final sack in product.sackPrice) {
        final isSelected = selectedSackPriceId == sack.id && !isSpecialPrice;
        allOptions.add(
          _buildOptionCard(
            isSelected: isSelected,
            onTap: () => onSelectSackPrice(sack.id),
            icon: Icons.inventory_rounded,
            title: parseSackType(sack.type),
            subtitle: '₱${sack.price.toStringAsFixed(2)} / sack',
            stock: '${sack.stock.truncate()} sacks available',
            color: AppColors.accent,
          ),
        );
      }
    }

    // Create grid layout with 2 columns
    return Column(
      children: [
        for (int i = 0; i < allOptions.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: i + 2 < allOptions.length ? 8 : 0),
            child: Row(
              children: [
                Expanded(child: allOptions[i]),
                if (i + 1 < allOptions.length) ...[
                  const SizedBox(width: 8),
                  Expanded(child: allOptions[i + 1]),
                ] else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildOptionCard({
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    required String stock,
    required Color color,
  }) {
    // Determine if this option is out of stock
    bool isOutOfStock = false;
    if (title == 'Per Kilogram' && product.perKiloPrice != null) {
      isOutOfStock = product.perKiloPrice!.stock <= Decimal.zero;
    } else {
      final matchingSack = product.sackPrice.firstWhere(
        (sack) => parseSackType(sack.type) == title,
        orElse: () => product.sackPrice.first,
      );
      isOutOfStock = matchingSack.stock <= Decimal.zero;
    }

    return GestureDetector(
      onTap: isOutOfStock ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isOutOfStock
              ? Colors.grey[100]
              : isSelected
                  ? color.withOpacity(0.1)
                  : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOutOfStock
                ? Colors.grey[300]!
                : isSelected
                    ? color
                    : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected && !isOutOfStock
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? color.withOpacity(0.2) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? color : Colors.grey[600],
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.black : Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected && !isOutOfStock)
                  Icon(Icons.check_circle_rounded, color: color, size: 16),
                if (isOutOfStock)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'OUT',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isOutOfStock
                    ? Colors.grey[500]
                    : isSelected
                        ? Colors.black
                        : Colors.grey[600],
                decoration: isOutOfStock ? TextDecoration.lineThrough : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              stock,
              style: TextStyle(
                fontSize: 11,
                color: isOutOfStock
                    ? Colors.red[600]
                    : isSelected
                        ? Colors.black
                        : Colors.grey[500],
                fontWeight: isOutOfStock ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
