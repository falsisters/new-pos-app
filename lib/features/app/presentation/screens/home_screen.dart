import 'package:falsisters_pos_android/features/app/data/providers/home_provider.dart';
import 'package:falsisters_pos_android/features/app/presentation/widgets/sidebar.dart';
import 'package:falsisters_pos_android/features/sales/presentation/screens/sales_screen.dart';
import 'package:falsisters_pos_android/features/shift/data/model/current_shift_state.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_dialog_provider.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_provider.dart';
import 'package:falsisters_pos_android/features/shift/presentation/screens/shift_screen.dart';
import 'package:falsisters_pos_android/features/shift/presentation/widgets/create_shift_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerIndex = ref.watch(drawerIndexProvider);
    final isDialogVisible = ref.watch(dialogStateProvider);

    return Scaffold(body: Consumer(builder: (context, ref, _) {
      final shiftState = ref.watch(shiftProvider);
      final isActiveShift = ref.watch(isShiftActiveProvider);

      return shiftState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${error.toString()}'),
              ElevatedButton(
                onPressed: () => ref.refresh(shiftProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (CurrentShiftState state) {
          if (isActiveShift == false) {
            ref.watch(dialogStateProvider.notifier).showDialog();
          }

          if (isDialogVisible) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCreateShiftDialog(context, ref);
            });
          }

          return Row(
            children: [
              Sidebar(),
              if (drawerIndex == 0)
                Expanded(
                  child: SalesScreen(),
                ),
              if (drawerIndex == 1)
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: const Center(
                      child: Text(
                        'Deliveries Screen',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              if (drawerIndex == 7) Expanded(child: ShiftScreen()),
            ],
          );
        },
      );
    }));
  }
}
