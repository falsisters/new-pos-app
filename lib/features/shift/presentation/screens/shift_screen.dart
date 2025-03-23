import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/shift/data/model/shift_model.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_provider.dart';
import 'package:falsisters_pos_android/features/shift/presentation/widgets/create_shift_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ShiftScreen extends ConsumerWidget {
  const ShiftScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider state directly - this will rebuild when state changes
    final shiftState = ref.watch(shiftProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Current Shift',
            style:
                TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
        elevation: 2,
      ),
      body: shiftState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => Center(
          child:
              Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
        data: (currentShiftState) {
          if (currentShiftState.error != null) {
            return Center(
              child: Text('Error: ${currentShiftState.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          } else if (!currentShiftState.isShiftActive ||
              currentShiftState.shift == null) {
            return _NoActiveShift(
              // Pass a refresh callback to allow manual refresh
              onRefresh: () => ref.refresh(shiftProvider),
            );
          } else {
            return _ShiftDetails(shift: currentShiftState.shift!);
          }
        },
      ),
      bottomNavigationBar: shiftState.maybeWhen(
        data: (state) => state.isShiftActive && state.shift != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // End the current shift
                    await ref.read(shiftProvider.notifier).endShift();

                    // After shift is ended, show the dialog to create a new shift
                    if (context.mounted) {
                      showCreateShiftDialog(context, ref);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('END SHIFT',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            : null,
        orElse: () => null,
      ),
    );
  }
}

class _ShiftDetails extends StatelessWidget {
  final ShiftModel shift;

  const _ShiftDetails({required this.shift});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            title: 'Shift Information',
            content: [
              _InfoRow(label: 'Shift ID:', value: shift.id),
              _InfoRow(
                label: 'Start Time:',
                value:
                    '${dateFormat.format(shift.startTime)} at ${timeFormat.format(shift.startTime)}',
              ),
              if (shift.endTime != null)
                _InfoRow(
                  label: 'End Time:',
                  value:
                      '${dateFormat.format(shift.endTime!)} at ${timeFormat.format(shift.endTime!)}',
                ),
              _InfoRow(
                label: 'Duration:',
                value: shift.endTime != null
                    ? _formatDuration(
                        shift.endTime!.difference(shift.startTime))
                    : 'Ongoing',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Employees on Shift (${shift.employees.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          if (shift.employees.isEmpty)
            const Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No employees assigned to this shift'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shift.employees.length,
              itemBuilder: (context, index) {
                final employee = shift.employees[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        employee.name.isNotEmpty ? employee.name[0] : '?',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                    title: Text(
                      employee.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('ID: ${employee.id}'),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '$hours hrs $minutes mins';
  }
}

class _NoActiveShift extends ConsumerWidget {
  final VoidCallback? onRefresh;

  const _NoActiveShift({this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time_rounded,
              size: 80, color: AppColors.primaryLight),
          const SizedBox(height: 16),
          const Text(
            'No Active Shift',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start a new shift to track employee time',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(shiftProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('START NEW SHIFT',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              if (onRefresh != null) ...[
                const SizedBox(width: 12),
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh shift status',
                  color: AppColors.primary,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> content;

  const _InfoCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Divider(height: 24, color: AppColors.primaryLight),
            ...content,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
