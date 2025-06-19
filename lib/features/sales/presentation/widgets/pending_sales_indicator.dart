import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/sales/data/model/pending_sale.dart';
import 'package:flutter/material.dart';

class PendingSalesIndicator extends StatelessWidget {
  final List<PendingSale> pendingSales;

  const PendingSalesIndicator({
    super.key,
    required this.pendingSales,
  });

  @override
  Widget build(BuildContext context) {
    if (pendingSales.isEmpty) return const SizedBox.shrink();
    final errorCount = pendingSales.where((sale) => sale.error != null).length;

    return PopupMenuButton<void>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: errorCount > 0
              ? Colors.red.withOpacity(0.1)
              : AppColors.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              errorCount > 0
                  ? Icons.error_outline
                  : Icons.cloud_upload_outlined,
              color: errorCount > 0 ? Colors.red : AppColors.secondary,
              size: 16,
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: errorCount > 0 ? Colors.red : AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${pendingSales.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.queue, size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Pending Sales Queue',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...pendingSales
                  .map((sale) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: sale.error != null
                                    ? Colors.red
                                    : sale.isProcessing
                                        ? Colors.orange
                                        : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: sale.isProcessing
                                  ? SizedBox(
                                      width: 8,
                                      height: 8,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '₱${sale.saleRequest.totalAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _formatTime(sale.timestamp),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  if (sale.error != null)
                                    Text(
                                      'Error: Retrying...',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.red[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
