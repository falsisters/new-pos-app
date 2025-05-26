import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  final double? price;

  const ProductTile({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.price,
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
          animation: _scaleAnimation,
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
                        : Colors.grey.withOpacity(0.2),
                    width: _isHovering ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovering
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
                      // Enhanced Image Container
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Image with enhanced styling
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  Image.network(
                                    widget.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
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
                                      if (loadingProgress == null) return child;
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

                            // Enhanced hover overlay
                            if (_isHovering)
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

                      const SizedBox(height: 12),

                      // Enhanced Title
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          widget.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _isHovering
                                ? AppColors.secondary
                                : AppColors.primary,
                            height: 1.3,
                          ),
                        ),
                      ),

                      // Enhanced Price (if available)
                      if (widget.price != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '₱${widget.price!.toStringAsFixed(2)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
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
