import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/attachment_model.dart';
import 'package:falsisters_pos_android/features/attachments/data/models/attachment_type_enum.dart';
import 'package:falsisters_pos_android/features/attachments/presentation/screens/attachment_view_screen.dart';
import 'package:flutter/material.dart';

class AttachmentTile extends StatelessWidget {
  final AttachmentModel attachment;
  final VoidCallback? onDelete;

  const AttachmentTile({
    super.key,
    required this.attachment,
    this.onDelete,
  });

  IconData _getIconForType(AttachmentType type) {
    switch (type) {
      case AttachmentType.EXPENSE_RECEIPT:
        return Icons.receipt;
      case AttachmentType.CHECKS_AND_BANK_TRANSFER:
        return Icons.account_balance;
      case AttachmentType.INVENTORIES:
        return Icons.inventory;
      case AttachmentType.SUPPORTING_DOCUMENTS:
        return Icons.folder_shared;
    }
  }

  Color _getColorForType(AttachmentType type) {
    switch (type) {
      case AttachmentType.EXPENSE_RECEIPT:
        return Colors.orange.shade700;
      case AttachmentType.CHECKS_AND_BANK_TRANSFER:
        return Colors.blue.shade700;
      case AttachmentType.INVENTORIES:
        return Colors.green.shade700;
      case AttachmentType.SUPPORTING_DOCUMENTS:
        return Colors.purple.shade700;
    }
  }

  void _viewAttachment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttachmentViewScreen(
          attachment: attachment,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _viewAttachment(context),
      child: Card(
        elevation: 3,
        shadowColor: AppColors.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo preview
            Expanded(
              child: Hero(
                tag: 'attachment-${attachment.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    image: DecorationImage(
                      image: NetworkImage(attachment.url),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Gradient overlay for better text visibility
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Type indicator
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getColorForType(attachment.type)
                                .withOpacity(0.85),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getIconForType(attachment.type),
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                attachmentTypeToString(attachment.type),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Delete button
                      if (onDelete != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: onDelete,
                              tooltip: 'Delete Attachment',
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Attachment name
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attachment.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to view details',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
