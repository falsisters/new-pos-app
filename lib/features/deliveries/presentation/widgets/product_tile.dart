import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter/material.dart';

class DeliveryProductTile extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const DeliveryProductTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  State<DeliveryProductTile> createState() => _DeliveryProductTileState();
}

class _DeliveryProductTileState extends State<DeliveryProductTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovering
                  ? AppColors.secondary
                  : Colors.grey.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovering
                    ? AppColors.secondary.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
                spreadRadius: _isHovering ? 2 : 0,
                blurRadius: _isHovering ? 6 : 3,
                offset: Offset(0, _isHovering ? 2 : 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Product title
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color:
                          _isHovering ? AppColors.secondary : AppColors.primary,
                    ),
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: _isHovering
                      ? AppColors.secondary
                      : AppColors.primaryLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
