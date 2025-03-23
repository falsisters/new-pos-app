// filepath: d:\Projects\falsisters_pos_android\lib\features\shift\presentation\widgets\edit_shift_dialog.dart
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/shift/presentation/widgets/edit_shift_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showEditShiftDialog(BuildContext context, WidgetRef ref,
    {required Map<String, dynamic> shiftData}) {
  final employeeController = TextEditingController(text: shiftData['employee']);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Edit Shift',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: EditShiftForm(
              employeeController: employeeController,
              shiftData: shiftData,
            ),
          ),
        ),
      );
    },
  );
}
