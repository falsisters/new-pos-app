import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/attachment_model.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/attachment_type_enum.dart';
import 'package:falsisters_pos_android/features/attachments/presentation/screens/attachment_view_screen.dart';
import 'package:flutter/material.dart';

class AttachmentTile extends StatefulWidget {
  final AttachmentModel attachment;
  final VoidCallback? onDelete;

  const AttachmentTile({
    super.key,
    required this.attachment,
    this.onDelete,
  });

  @override
  State<AttachmentTile> createState() => _AttachmentTileState();
}

class _AttachmentTileState extends State<AttachmentTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  IconData _getIconForType(AttachmentType type) {
    switch (type) {
      case AttachmentType.EXPENSE_RECEIPT:
        return Icons.receipt_long_rounded;
      case AttachmentType.CHECKS_AND_BANK_TRANSFER:
        return Icons.account_balance_rounded;
      case AttachmentType.INVENTORIES:
        return Icons.inventory_2_rounded;
      case AttachmentType.SUPPORTING_DOCUMENTS:
        return Icons.folder_copy_rounded;
    }
  }

  Color _getColorForType(AttachmentType type) {
    switch (type) {
      case AttachmentType.EXPENSE_RECEIPT:
        return const Color(0xFFFF6B35);
      case AttachmentType.CHECKS_AND_BANK_TRANSFER:
        return const Color(0xFF1976D2);
      case AttachmentType.INVENTORIES:
        return const Color(0xFF388E3C);
      case AttachmentType.SUPPORTING_DOCUMENTS:
        return const Color(0xFF7B1FA2);
    }
  }

  void _viewAttachment(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AttachmentViewScreen(attachment: widget.attachment),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: () => _viewAttachment(context),
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), // Reduced from 20
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12, // Reduced shadow
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16), // Reduced from 20
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo preview with enhanced design
                    Expanded(
                      flex: 4, // Increased image area
                      child: Hero(
                        tag: 'attachment-${widget.attachment.id}',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)), // Reduced from 20
                            image: DecorationImage(
                              image: NetworkImage(widget.attachment.url),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)), // Reduced from 20
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Type indicator with modern design
                                Positioned(
                                  top: 8, // Reduced from 12
                                  left: 8, // Reduced from 12
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4), // Reduced padding
                                    decoration: BoxDecoration(
                                      color: _getColorForType(
                                          widget.attachment.type),
                                      borderRadius: BorderRadius.circular(
                                          8), // Reduced from 12
                                      boxShadow: [
                                        BoxShadow(
                                          color: _getColorForType(
                                                  widget.attachment.type)
                                              .withOpacity(0.3),
                                          blurRadius: 4, // Reduced from 8
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getIconForType(
                                              widget.attachment.type),
                                          color: Colors.white,
                                          size: 10, // Reduced from 14
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Delete button with improved design
                                if (widget.onDelete != null)
                                  Positioned(
                                    top: 8, // Reduced from 12
                                    right: 8, // Reduced from 12
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 4, // Reduced from 8
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          onTap: widget.onDelete,
                                          borderRadius: BorderRadius.circular(
                                              16), // Reduced from 20
                                          child: const Padding(
                                            padding: EdgeInsets.all(
                                                6), // Reduced from 8
                                            child: Icon(
                                              Icons.delete_outline_rounded,
                                              color: Colors.white,
                                              size: 14, // Reduced from 18
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Attachment info with modern typography - more compact
                    Expanded(
                      flex: 2, // Reduced text area
                      child: Padding(
                        padding: const EdgeInsets.all(10.0), // Reduced from 16
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.attachment.name,
                              style: const TextStyle(
                                fontSize: 12, // Reduced from 16
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                                height: 1.2,
                              ),
                              maxLines: 1, // Reduced from 2
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3), // Reduced from 6
                            Text(
                              attachmentTypeToString(widget.attachment.type),
                              style: TextStyle(
                                fontSize: 9, // Reduced from 12
                                fontWeight: FontWeight.w500,
                                color: _getColorForType(widget.attachment.type),
                                letterSpacing: 0.1, // Reduced from 0.2
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2), // Reduced from 4
                            Text(
                              'Tap to view',
                              style: TextStyle(
                                fontSize: 8, // Reduced from 11
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
