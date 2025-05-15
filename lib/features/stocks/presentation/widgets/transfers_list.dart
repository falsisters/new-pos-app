import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/transfer_model.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/transfer_product_request.dart';
import 'package:falsisters_pos_android/features/stocks/data/providers/transfer_provider.dart';
import 'package:falsisters_pos_android/features/stocks/presentation/widgets/transfer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransfersList extends ConsumerWidget {
  const TransfersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transferState = ref.watch(transferProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.accent, width: 1.5),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.history, color: AppColors.accent, size: 22),
                const SizedBox(width: 10),
                const Text(
                  'Transfer History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.accent),
                  onPressed: () {
                    ref.read(transferProvider.notifier).getTransferList();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: transferState.when(
              data: (data) {
                if (data.isLoading && data.transferList.isEmpty) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.accent));
                }
                if (data.error != null) {
                  return Center(child: Text('Error: ${data.error}'));
                }
                if (data.transferList.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No transfers found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Group transfers by type
                final groupedTransfers = <TransferType, List<TransferModel>>{};
                for (var transfer in data.transferList) {
                  (groupedTransfers[transfer.type] ??= []).add(transfer);
                }

                return ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: groupedTransfers.entries.map((entry) {
                    final type = entry.key;
                    final transfers = entry.value;
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        key: PageStorageKey<TransferType>(
                            type), // Preserve state
                        leading: Icon(_getIconForTransferType(type),
                            color: AppColors.accent),
                        title: Text(
                          parseTransferType(type),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        children: transfers
                            .map((transfer) => TransferItem(transfer: transfer))
                            .toList(),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent)),
              error: (error, stackTrace) => Center(
                child: Text('Failed to load transfers: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTransferType(TransferType type) {
    switch (type) {
      case TransferType.OWN_CONSUMPTION:
        return Icons.shopping_basket_outlined;
      case TransferType.RETURN_TO_WAREHOUSE:
        return Icons.warehouse_outlined;
      case TransferType.KAHON:
        return Icons.inventory_2_outlined;
      case TransferType.REPACK:
        return Icons.sync_alt_outlined;
      default:
        return Icons.swap_horiz;
    }
  }
}
