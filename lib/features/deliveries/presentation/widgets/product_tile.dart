import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_sack_type.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';

class DeliveryProductTile extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const DeliveryProductTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<DeliveryProductTile> createState() => _DeliveryProductTileState();
}

class _DeliveryProductTileState extends State<DeliveryProductTile>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _shadowAnimation = Tween<double>(begin: 4.0, end: 12.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getFormattedLastUpdated() {
    final now = DateTime.now();
    final difference = now.difference(widget.product.updatedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // bool _hasAvailableStock() {
  //   final hasPerKiloStock = widget.product.perKiloPrice != null &&
  //       widget.product.perKiloPrice!.stock > 0;
  //   final hasSackStock = widget.product.sackPrice.any((sack) => sack.stock > 0);
  //   return hasPerKiloStock || hasSackStock;
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovering = true);
          _animationController.forward();
        },
        onExit: (_) {
          setState(() => _isHovering = false);
          _animationController.reverse();
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isHovering
                        ? AppColors.secondary
                        : Colors.grey.withOpacity(0.15),
                    width: _isHovering ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovering
                          ? AppColors.secondary.withOpacity(0.15)
                          : Colors.black.withOpacity(0.04),
                      spreadRadius: 0,
                      blurRadius: _shadowAnimation.value,
                      offset: Offset(0, _shadowAnimation.value * 0.3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Product Icon/Avatar
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isHovering
                                ? [
                                    AppColors.secondary.withOpacity(0.2),
                                    AppColors.secondary.withOpacity(0.1),
                                  ]
                                : [
                                    AppColors.primary.withOpacity(0.15),
                                    AppColors.primary.withOpacity(0.08),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.inventory_2_rounded,
                          size: 28,
                          color: _isHovering
                              ? AppColors.secondary
                              : AppColors.primary,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Product Information
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              widget.product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _isHovering
                                    ? AppColors.secondary
                                    : AppColors.primary,
                                letterSpacing: -0.2,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Current Stock Information Row
                            Row(
                              children: [
                                // Per Kilo Stock
                                if (widget.product.perKiloPrice != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.blue.withOpacity(0.2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.scale_rounded,
                                            size: 12, color: Colors.blue[700]),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${widget.product.perKiloPrice!.stock.toString()} kg',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],

                                // Total Sack Count
                                if (widget.product.sackPrice.isNotEmpty) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: AppColors.accent
                                              .withOpacity(0.2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.inventory_rounded,
                                            size: 12, color: AppColors.accent),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${widget.product.sackPrice.fold<Decimal>(Decimal.zero, (sum, sack) => sum + sack.stock).toBigInt()} sacks',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.accent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Last Updated
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded,
                                    size: 12, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Text(
                                  'Updated ${_getFormattedLastUpdated()}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Action Section
                      Column(
                        children: [
                          // Add to Truck Button
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _isHovering
                                    ? [
                                        AppColors.secondary,
                                        AppColors.secondary.withOpacity(0.8)
                                      ]
                                    : [
                                        AppColors.primary.withOpacity(0.1),
                                        AppColors.primary.withOpacity(0.05)
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _isHovering
                                  ? [
                                      BoxShadow(
                                        color: AppColors.secondary
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: widget.onTap,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_shipping_outlined,
                                        size: 18,
                                        color: _isHovering
                                            ? Colors.white
                                            : AppColors.primary,
                                      ),
                                      if (_isHovering) ...[
                                        const SizedBox(width: 6),
                                        Text(
                                          'Add to Truck',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          if (_isHovering) ...[
                            const SizedBox(height: 8),
                            // Stock Preview (when hovering)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Stock:',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  if (widget.product.perKiloPrice != null)
                                    Text(
                                      'Per kg: ${widget.product.perKiloPrice!.stock.toString()} kg',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ...widget.product.sackPrice
                                      .take(2)
                                      .map((sackPrice) {
                                    return Text(
                                      '${parseSackType(sackPrice.type)}: ${sackPrice.stock.toBigInt()} sacks',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
