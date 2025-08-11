import 'package:decimal/decimal.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  final Decimal? price;
  final Product? product; // Add product parameter for stock checking

  const ProductTile({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.price,
    this.product,
  });

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _isOutOfStock() {
    if (widget.product == null) return false;

    // Check per kilo stock
    bool perKiloOutOfStock = widget.product!.perKiloPrice != null &&
        widget.product!.perKiloPrice!.stock <= Decimal.zero;

    // Check sack stock
    bool allSacksOutOfStock = widget.product!.sackPrice.isNotEmpty &&
        widget.product!.sackPrice.every((sack) => sack.stock <= Decimal.zero);

    // If has per kilo and sacks, both must be out of stock
    if (widget.product!.perKiloPrice != null &&
        widget.product!.sackPrice.isNotEmpty) {
      return perKiloOutOfStock && allSacksOutOfStock;
    }

    // If only per kilo
    if (widget.product!.perKiloPrice != null &&
        widget.product!.sackPrice.isEmpty) {
      return perKiloOutOfStock;
    }

    // If only sacks
    if (widget.product!.perKiloPrice == null &&
        widget.product!.sackPrice.isNotEmpty) {
      return allSacksOutOfStock;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = _isOutOfStock();

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
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isOutOfStock ? 1.0 : _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: isOutOfStock ? Colors.grey[100] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isOutOfStock
                        ? Colors.grey[300]!
                        : _isHovering
                            ? AppColors.secondary
                            : Colors.grey.withOpacity(0.2),
                    width: _isHovering ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isOutOfStock
                          ? Colors.transparent
                          : _isHovering
                              ? AppColors.secondary.withOpacity(0.25)
                              : Colors.black.withOpacity(0.08),
                      spreadRadius: _isHovering ? 2 : 0,
                      blurRadius: _isHovering ? 15 : 8,
                      offset: Offset(0, _isHovering ? 6 : 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Enhanced Image Container with fixed square dimensions
                      AspectRatio(
                        aspectRatio: 1.0, // Force square aspect ratio
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Image with enhanced styling
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image.network(
                                      widget.imageUrl,
                                      fit: BoxFit.cover,
                                      cacheWidth:
                                          200, // Cache at reasonable resolution
                                      cacheHeight: 200,
                                      color: isOutOfStock
                                          ? Colors.grey.withOpacity(0.5)
                                          : null,
                                      colorBlendMode: isOutOfStock
                                          ? BlendMode.saturation
                                          : null,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.primaryLight
                                                    .withOpacity(0.3),
                                                AppColors.primaryLight
                                                    .withOpacity(0.1),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .image_not_supported_outlined,
                                                  size: 32,
                                                  color: AppColors.primary
                                                      .withOpacity(0.7),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'No Image',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: AppColors.primary
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                              strokeWidth: 2,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Subtle gradient overlay
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.center,
                                          colors: [
                                            Colors.black.withOpacity(0.1),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Out of stock overlay
                            if (isOutOfStock)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.block,
                                              color: Colors.white, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Out of Stock',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // Enhanced hover overlay (only if not out of stock)
                            if (_isHovering && !isOutOfStock)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.secondary,
                                            AppColors.secondary.withOpacity(0.8)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.secondary
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.add_shopping_cart,
                                              color: Colors.white, size: 16),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Add to Cart',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8), // Reduced from 12 to 8

                      // Enhanced Title with flex layout
                      Flexible(
                        // Changed from Expanded to Flexible
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Added to prevent overflow
                            children: [
                              Text(
                                widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12, // Reduced from 13 to 12
                                  fontWeight: FontWeight.w600,
                                  color: isOutOfStock
                                      ? Colors.grey[500]
                                      : _isHovering
                                          ? AppColors.secondary
                                          : AppColors.primary,
                                  height: 1.2, // Reduced from 1.3 to 1.2
                                ),
                              ),

                              // Enhanced Price (if available)
                              if (widget.price != null) ...[
                                const SizedBox(
                                    height: 4), // Reduced from 6 to 4
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3), // Reduced padding
                                  decoration: BoxDecoration(
                                    color: isOutOfStock
                                        ? Colors.grey[200]
                                        : AppColors.accent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                        6), // Reduced from 8 to 6
                                  ),
                                  child: Text(
                                    '₱${widget.price!.toStringAsFixed(2)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11, // Reduced from 12 to 11
                                      fontWeight: FontWeight.bold,
                                      color: isOutOfStock
                                          ? Colors.grey[500]
                                          : AppColors.accent,
                                      decoration: isOutOfStock
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
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
