import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/transfer_model.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/transfer_product_request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferItem extends StatelessWidget {
  final TransferModel transfer;

  const TransferItem({
    super.key,
    required this.transfer,
  });

  Color _getTransferTypeColor(TransferType type) {
    switch (type) {
      case TransferType.OWN_CONSUMPTION:
        return Colors.purple;
      case TransferType.RETURN_TO_WAREHOUSE:
        return Colors.blue;
      case TransferType.KAHON:
        return Colors.orange;
      case TransferType.REPACK:
        return Colors.green;
    }
  }

  IconData _getTransferTypeIcon(TransferType type) {
    switch (type) {
      case TransferType.OWN_CONSUMPTION:
        return Icons.restaurant_rounded;
      case TransferType.RETURN_TO_WAREHOUSE:
        return Icons.warehouse_rounded;
      case TransferType.KAHON:
        return Icons.inventory_2_rounded;
      case TransferType.REPACK:
        return Icons.autorenew_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a')
        .format(DateTime.parse(transfer.createdAt).toLocal());
    final typeColor = _getTransferTypeColor(transfer.type);
    final typeIcon = _getTransferTypeIcon(transfer.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: typeColor.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(typeIcon, color: typeColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transfer.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.scale_rounded,
                                color: Colors.blue, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              '${transfer.quantity.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          parseTransferType(transfer.type),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: typeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
