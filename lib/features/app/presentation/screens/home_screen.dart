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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _dialogCheckPending = true;

  @override
  void initState() {
    super.initState();
    // Initial setup for dialog check
    _setupDialogCheck();
  }

  void _setupDialogCheck() {
    // This sets up a listener for shift state changes
    ref.listenManual(isShiftActiveProvider, (previous, next) {
      if (next == false) {
        // If shift becomes inactive, mark dialog check as pending
        setState(() {
          _dialogCheckPending = true;
        });
        _scheduleDialogCheck();
      }
    });
  }

  void _scheduleDialogCheck() {
    if (!_dialogCheckPending) return;

    // Schedule dialog check after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isShiftActive = ref.read(isShiftActiveProvider);
      final isDialogVisible = ref.read(dialogStateProvider);

      // Only show dialog if shift is inactive and dialog should be visible
      if (isShiftActive == false && !isDialogVisible) {
        // Use the notifier to update the dialog state
        ref.read(dialogStateProvider.notifier).showDialog();

        // Show the actual dialog
        showCreateShiftDialog(context, ref);
      }

      setState(() {
        _dialogCheckPending = false;
      });
    });
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if we need to show dialog after widget updates
    if (_dialogCheckPending) {
      _scheduleDialogCheck();
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerIndex = ref.watch(drawerIndexProvider);

    // If dialog check is pending, schedule it
    if (_dialogCheckPending) {
      _scheduleDialogCheck();
    }

    return Scaffold(
      body: Consumer(builder: (context, ref, _) {
        final shiftState = ref.watch(shiftProvider);

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
            // We'll handle dialog visibility through the lifecycle methods,
            // not directly in the build method

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
      }),
    );
  }
}
