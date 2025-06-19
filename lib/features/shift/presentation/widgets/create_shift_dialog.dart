// Create a riverpod component showDialog that is a form, there will be a dropdown listing the employees
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/core/services/secure_code_service.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_dialog_provider.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_provider.dart';
import 'package:falsisters_pos_android/features/shift/presentation/widgets/create_shift_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showCreateShiftDialog(BuildContext context, WidgetRef ref) async {
  // Check if bypass is active
  final bypassed = await SecureCodeService.isBypassActive();
  if (bypassed) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Shift dialog is currently bypassed'),
          backgroundColor: Colors.orange[600],
        ),
      );
    }
    return;
  }

  // Check if shift is already active
  final currentShiftState = ref.read(currentShiftProvider);
  if (currentShiftState?.isShiftActive == true) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('A shift is already active'),
          backgroundColor: Colors.blue[600],
        ),
      );
    }
    return;
  }

  // Show dialog state
  ref.read(dialogStateProvider.notifier).showDialog();

  final employeeController = TextEditingController();

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Consumer(
        builder: (context, ref, _) {
          // Watch dialog state and close if needed
          final dialogState = ref.watch(dialogStateProvider);

          // Auto-close dialog if bypass is set
          if (!dialogState.isVisible || dialogState.isBypassed) {
            // Use a more robust way to close the dialog
            Future.microtask(() {
              if (context.mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop(true);
              }
            });
          }

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                // Only update state if the reference is still valid
                try {
                  ref.read(dialogStateProvider.notifier).hideDialog();
                } catch (e) {
                  // Ignore errors if ref is disposed
                }
              }
            },
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                width: double.maxFinite,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Modern header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.login_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Clock In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                'Start a new shift',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Form content - make it scrollable
                    Expanded(
                      child: SingleChildScrollView(
                        child: CreateShiftForm(
                          employeeController: employeeController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  // Ensure dialog state is updated when dialog closes - with error handling
  try {
    ref.read(dialogStateProvider.notifier).hideDialog();
  } catch (e) {
    // Ignore errors if ref is disposed
  }
}
