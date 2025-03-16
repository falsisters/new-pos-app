// Create a riverpod component showDialog that is a form, there will be a dropdown listing the employees
import 'package:falsisters_pos_android/features/shift/presentation/widgets/create_shift_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showCreateShiftDialog(BuildContext context, WidgetRef ref) {
  final employeeController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Create New Shift'),
          content: SizedBox(
            width: double.maxFinite,
            child: CreateShiftForm(
              employeeController: employeeController,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                employeeController.dispose();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    },
  );
}
