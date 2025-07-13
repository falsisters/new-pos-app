import 'package:falsisters_pos_android/features/app/data/providers/home_provider.dart';
import 'package:falsisters_pos_android/features/app/presentation/screens/settings_screen.dart';
import 'package:falsisters_pos_android/features/app/presentation/widgets/printing_orchestrator.dart';
import 'package:falsisters_pos_android/features/app/presentation/widgets/sidebar.dart';
import 'package:falsisters_pos_android/features/attachments/presentation/screens/attachments_screen.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/screens/bill_count_screen.dart';
import 'package:falsisters_pos_android/features/deliveries/presentation/screens/delivery_screen.dart';
import 'package:falsisters_pos_android/features/expenses/presentation/screens/expenses_screen.dart';
import 'package:falsisters_pos_android/features/kahon/presentation/screens/kahon_screen.dart';
import 'package:falsisters_pos_android/features/orders/presentation/screens/order_screen.dart';
import 'package:falsisters_pos_android/features/profits/presentation/screens/profits_screen.dart';
import 'package:falsisters_pos_android/features/sales/presentation/screens/sales_screen.dart';
import 'package:falsisters_pos_android/features/sales_check/presentation/screens/sales_check_screen.dart';
import 'package:falsisters_pos_android/features/shift/data/model/current_shift_state.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_dialog_provider.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_provider.dart';
import 'package:falsisters_pos_android/features/shift/presentation/screens/shift_screen.dart';
import 'package:falsisters_pos_android/features/shift/presentation/widgets/create_shift_dialog.dart';
import 'package:falsisters_pos_android/features/stocks/presentation/screens/stocks_screen.dart';
import 'package:falsisters_pos_android/core/services/secure_code_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasCheckedInitialDialog = false;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    // Don't schedule dialog check immediately - wait for shift data to load
  }

  Future<void> _checkAndShowDialog() async {
    if (_hasCheckedInitialDialog || !mounted) return;

    // Check if we're editing a shift
    final dialogState = ref.read(dialogStateProvider);
    if (dialogState.isEditingShift) {
      if (mounted) {
        setState(() {
          _hasCheckedInitialDialog = true;
        });
      }
      return;
    }

    // Check bypass status first
    final isBypassed = await SecureCodeService.isBypassActive();
    if (isBypassed) {
      // Update dialog state to reflect bypass status - with error handling
      try {
        ref.read(dialogStateProvider.notifier).setBypass();
      } catch (e) {
        // Ignore if ref is disposed
      }

      if (mounted) {
        setState(() {
          _hasCheckedInitialDialog = true;
        });
      }
      return;
    }

    // Check current shift state
    final currentShiftState = ref.read(currentShiftProvider);
    final shouldShowDialog = ref.read(shouldShowShiftDialogProvider);

    // Show dialog if conditions are met and we have loaded the initial shift data
    if (!_isInitialLoad &&
        shouldShowDialog &&
        !dialogState.isVisible &&
        !dialogState.isBypassed &&
        !dialogState.isEditingShift &&
        (currentShiftState == null || !currentShiftState.isShiftActive)) {
      if (context.mounted) {
        await showCreateShiftDialog(context, ref);
      }
    }

    if (mounted) {
      setState(() {
        _hasCheckedInitialDialog = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerIndex = ref.watch(drawerIndexProvider);

    // Listen to shift state changes to handle dialog visibility
    ref.listen<AsyncValue<CurrentShiftState>>(shiftProvider, (previous, next) {
      if (!mounted) return;

      // Handle initial load completion
      if (_isInitialLoad && !next.isLoading) {
        setState(() {
          _isInitialLoad = false;
        });

        // Schedule dialog check after initial load is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _checkAndShowDialog();
          }
        });
        return;
      }

      // Handle subsequent shift state changes
      next.whenData((state) {
        if (!state.isShiftActive &&
            _hasCheckedInitialDialog &&
            !_isInitialLoad) {
          // Reset dialog check flag when shift becomes inactive
          if (mounted) {
            setState(() {
              _hasCheckedInitialDialog = false;
            });

            // Schedule dialog check for next frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _checkAndShowDialog();
              }
            });
          }
        }
      });
    });

    // Listen to dialog state changes for bypass and edit updates
    ref.listen<DialogState>(dialogStateProvider, (previous, next) {
      if (!mounted) return;

      if (next.isBypassed && !_hasCheckedInitialDialog) {
        setState(() {
          _hasCheckedInitialDialog = true;
        });
      }

      // Don't trigger dialog check when editing state changes
      // The editing state should prevent dialog from showing automatically
    });

    return Scaffold(
      body: PrintingOrchestrator(
        child: Consumer(builder: (context, ref, _) {
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
                    onPressed: () async {
                      final future = ref.refresh(shiftProvider);
                      await future;
                      setState(() {
                        _hasCheckedInitialDialog = false;
                        _isInitialLoad = true;
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (CurrentShiftState state) {
              return Row(
                children: [
                  const Sidebar(),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (drawerIndex == 10) return const OrderScreen();
                        if (drawerIndex == 0) return const SalesScreen();
                        if (drawerIndex == 1) return const DeliveryScreen();
                        if (drawerIndex == 2) return const StocksScreen();
                        if (drawerIndex == 3) return const KahonScreen();
                        if (drawerIndex == 4) return const ExpensesScreen();
                        if (drawerIndex == 5) return const ProfitsScreen();
                        if (drawerIndex == 6) return const AttachmentsScreen();
                        if (drawerIndex == 7) return const SalesCheckScreen();
                        if (drawerIndex == 8) return const BillCountScreen();
                        if (drawerIndex == 9) return const ShiftScreen();
                        if (drawerIndex == 11) return const SettingsScreen();
                        return const SalesScreen(); // Default fallback
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
