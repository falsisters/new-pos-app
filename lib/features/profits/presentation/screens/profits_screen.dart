import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/profits/data/providers/profits_provider.dart';
import 'package:falsisters_pos_android/features/profits/presentation/widgets/profit_filter_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProfitsScreen extends ConsumerWidget {
  const ProfitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profitsState = ref.watch(profitsStateNotifierProvider);
    final numberFormat = NumberFormat("#,##0.00", "en_US");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profits'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Column(
        children: [
          // Integrate the filter widget
          const ProfitFilterWidget(),

          // Add a divider for better visual separation
          const Divider(height: 1, thickness: 1),

          Expanded(
            child: profitsState.when(
              data: (state) {
                if (state.error != null) {
                  return Center(child: Text('Error: ${state.error}'));
                }

                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.profitResponse == null) {
                  return const Center(child: Text('Loading profit data...'));
                }

                final profitResponse = state.profitResponse!;
                final sacks = profitResponse.sacks;
                final asin = profitResponse.asin;
                final overallTotal = profitResponse.overallTotal;

                if (sacks.items.isEmpty && asin.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bar_chart,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No profit data found for the selected filters.',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(profitsStateNotifierProvider.notifier).refresh(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SACKS Section
                        if (sacks.items.isNotEmpty) ...[
                          _SectionHeader(title: 'SACKS'),
                          const SizedBox(height: 10),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...sacks.items.map((item) {
                                    return _ProfitItemRow(
                                      summary: item.formattedSummary,
                                    );
                                  }).toList(),
                                  const _Divider(),
                                  _TotalsRow(
                                    label: 'TOTAL:',
                                    amount: sacks.totalProfit,
                                    numberFormat: numberFormat,
                                    isBold: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // ASIN Section
                        if (asin.items.isNotEmpty) ...[
                          _SectionHeader(title: 'ASIN'),
                          const SizedBox(height: 10),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...asin.items.map((item) {
                                    return _ProfitItemRow(
                                      summary: item.formattedSummary,
                                    );
                                  }).toList(),
                                  const _Divider(),
                                  _TotalsRow(
                                    label: 'TOTAL:',
                                    amount: asin.totalProfit,
                                    numberFormat: numberFormat,
                                    isBold: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Overall Total
                        Card(
                          color: AppColors.primary.withOpacity(0.1),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'GRAND TOTAL',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  numberFormat.format(overallTotal),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
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
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Failed to load profits: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(profitsStateNotifierProvider.notifier)
                          .refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ProfitItemRow extends StatelessWidget {
  final String summary;

  const _ProfitItemRow({
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(summary),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  final String label;
  final double amount;
  final NumberFormat numberFormat;
  final bool isBold;

  const _TotalsRow({
    required this.label,
    required this.amount,
    required this.numberFormat,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          ),
          const Spacer(),
          Text(
            numberFormat.format(amount),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey,
      ),
    );
  }
}
