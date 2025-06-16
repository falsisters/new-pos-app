import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/per_kilo_price_model.dart';
import 'package:falsisters_pos_android/features/products/data/models/sack_price_model.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_sack_type.dart';
import 'package:flutter/material.dart';

class StockProductTile extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final PerKiloPrice? perKiloPrice;
  final List<SackPrice> sackPrices;
  final DateTime lastUpdated;

  const StockProductTile({
    super.key,
    required this.title,
    required this.onTap,
    this.perKiloPrice,
    required this.sackPrices,
    required this.lastUpdated,
  });

  @override
  State<StockProductTile> createState() => _StockProductTileState();
}

class _StockProductTileState extends State<StockProductTile>
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

  bool _isOutOfStock() {
    // Check if all sack prices have zero stock
    final sackOutOfStock = widget.sackPrices.isEmpty ||
        widget.sackPrices.every((sack) => sack.stock <= 0);

    // Check if per kilo price has zero stock
    final perKiloOutOfStock =
        widget.perKiloPrice == null || widget.perKiloPrice!.stock <= 0;

    // Product is out of stock if both per kilo and sack options are out of stock
    return sackOutOfStock && perKiloOutOfStock;
  }

  String _getFormattedLastUpdated() {
    final now = DateTime.now();
    final difference = now.difference(widget.lastUpdated);

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

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = _isOutOfStock();

    return GestureDetector(
      onTap: isOutOfStock ? null : widget.onTap,
      child: MouseRegion(
        onEnter: isOutOfStock
            ? null
            : (_) {
                setState(() => _isHovering = true);
                _animationController.forward();
              },
        onExit: isOutOfStock
            ? null
            : (_) {
                setState(() => _isHovering = false);
                _animationController.reverse();
              },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: isOutOfStock ? 1.0 : _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: isOutOfStock ? Colors.grey[100] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isOutOfStock
                        ? Colors.grey.withOpacity(0.3)
                        : _isHovering
                            ? AppColors.secondary
                            : Colors.grey.withOpacity(0.15),
                    width: _isHovering && !isOutOfStock ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isOutOfStock
                          ? Colors.black.withOpacity(0.02)
                          : _isHovering
                              ? AppColors.secondary.withOpacity(0.15)
                              : Colors.black.withOpacity(0.04),
                      spreadRadius: 0,
                      blurRadius: isOutOfStock ? 2 : _shadowAnimation.value,
                      offset: Offset(
                          0, isOutOfStock ? 1 : _shadowAnimation.value * 0.3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: isOutOfStock ? 0.5 : 1.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            // Product Icon/Avatar
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isOutOfStock
                                      ? [Colors.grey[300]!, Colors.grey[200]!]
                                      : _isHovering
                                          ? [
                                              AppColors.secondary
                                                  .withOpacity(0.2),
                                              AppColors.secondary
                                                  .withOpacity(0.1),
                                            ]
                                          : [
                                              AppColors.primary
                                                  .withOpacity(0.15),
                                              AppColors.primary
                                                  .withOpacity(0.08),
                                            ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.inventory_2_rounded,
                                size: 28,
                                color: isOutOfStock
                                    ? Colors.grey[500]
                                    : _isHovering
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
                                    widget.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: isOutOfStock
                                          ? Colors.grey[600]
                                          : _isHovering
                                              ? AppColors.secondary
                                              : AppColors.primary,
                                      letterSpacing: -0.2,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Price Information Row
                                  Row(
                                    children: [
                                      // Per Kilo Price
                                      if (widget.perKiloPrice != null) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isOutOfStock
                                                ? Colors.grey.withOpacity(0.2)
                                                : Colors.green.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: isOutOfStock
                                                    ? Colors.grey
                                                        .withOpacity(0.3)
                                                    : Colors.green
                                                        .withOpacity(0.2)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.scale_rounded,
                                                  size: 12,
                                                  color: isOutOfStock
                                                      ? Colors.grey[500]
                                                      : Colors.green[700]),
                                              const SizedBox(width: 4),
                                              Text(
                                                '₱${widget.perKiloPrice!.price.toStringAsFixed(2)}/kg',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: isOutOfStock
                                                      ? Colors.grey[500]
                                                      : Colors.green[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],

                                      // Sack Count
                                      if (widget.sackPrices.isNotEmpty) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isOutOfStock
                                                ? Colors.grey.withOpacity(0.2)
                                                : AppColors.accent
                                                    .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: isOutOfStock
                                                    ? Colors.grey
                                                        .withOpacity(0.3)
                                                    : AppColors.accent
                                                        .withOpacity(0.2)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.inventory_rounded,
                                                  size: 12,
                                                  color: isOutOfStock
                                                      ? Colors.grey[500]
                                                      : AppColors.accent),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${widget.sackPrices.length} sack${widget.sackPrices.length != 1 ? 's' : ''}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: isOutOfStock
                                                      ? Colors.grey[500]
                                                      : AppColors.accent,
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
                                // Edit Button or Out of Stock indicator
                                if (isOutOfStock) ...[
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.red.withOpacity(0.2)),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(Icons.block_rounded,
                                            size: 18, color: Colors.red),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Out of\nStock',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else ...[
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: _isHovering
                                            ? [
                                                AppColors.secondary,
                                                AppColors.secondary
                                                    .withOpacity(0.8)
                                              ]
                                            : [
                                                AppColors.primary
                                                    .withOpacity(0.1),
                                                AppColors.primary
                                                    .withOpacity(0.05)
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
                                                Icons.edit_rounded,
                                                size: 18,
                                                color: _isHovering
                                                    ? Colors.white
                                                    : AppColors.primary,
                                              ),
                                              if (_isHovering) ...[
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Edit',
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
                                ],

                                if (_isHovering && !isOutOfStock) ...[
                                  const SizedBox(height: 8),
                                  // Sack Price Preview (when hovering)
                                  if (widget.sackPrices.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.grey[200]!),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: widget.sackPrices
                                            .take(2)
                                            .map((sackPrice) {
                                          return Text(
                                            '${parseSackType(sackPrice.type)}: ₱${sackPrice.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
