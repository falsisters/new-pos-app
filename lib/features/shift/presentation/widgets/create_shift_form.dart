import 'package:falsisters_pos_android/features/shift/data/model/create_shift_request_model.dart';
import 'package:falsisters_pos_android/features/shift/data/model/employee_model.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_provider.dart';
import 'package:flutter/material.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/core/services/secure_code_service.dart';
import 'package:falsisters_pos_android/features/auth/data/providers/auth_provider.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_dialog_provider.dart';

class CreateShiftForm extends ConsumerWidget {
  final TextEditingController employeeController;

  const CreateShiftForm({
    super.key,
    required this.employeeController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Consumer(builder: (context, ref, _) {
        final employees = ref.watch(employeeProvider);
        final isLoading =
            ref.watch(shiftProvider.select((state) => state.isLoading));
        final error = ref.watch(shiftProvider.select((state) => state.error));
        final cashier = ref.watch(cashierProvider);

        return employees.when(
          data: (employeeData) => _ShiftFormContent(
            employees: employeeData,
            isLoading: isLoading,
            error: error?.toString(),
            employeeController: employeeController,
            ref: ref,
            cashier: cashier,
          ),
          loading: () => Container(
            height: 200,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text(
                    "Loading employees...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (err, stack) => Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red[400], size: 48),
                  const SizedBox(height: 16),
                  Text(
                    "Error loading employees",
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    err.toString(),
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ref.refresh(employeeProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ShiftFormContent extends StatefulWidget {
  final List<EmployeeModel> employees;
  final bool isLoading;
  final String? error;
  final TextEditingController employeeController;
  final WidgetRef ref;
  final dynamic cashier;

  const _ShiftFormContent({
    required this.employees,
    required this.isLoading,
    required this.error,
    required this.employeeController,
    required this.ref,
    required this.cashier,
  });

  @override
  State<_ShiftFormContent> createState() => _ShiftFormContentState();
}

class _ShiftFormContentState extends State<_ShiftFormContent> {
  List<EmployeeModel> selectedEmployees = [];
  String searchQuery = '';
  bool showSecureCodeField = false;
  final TextEditingController secureCodeController = TextEditingController();
  bool secureCodeError = false;

  @override
  Widget build(BuildContext context) {
    final filteredEmployees = widget.employees
        .where((employee) =>
            employee.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.error != null)
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[50]!, Colors.red[100]!],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.error!,
                    style: TextStyle(
                      color: Colors.red[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Bypass option
        if (!showSecureCodeField)
          GestureDetector(
            onTap: () => setState(() => showSecureCodeField = true),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'or enter secure code',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),

        // Secure code field
        if (showSecureCodeField) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: secureCodeError ? Colors.red[300]! : Colors.grey[200]!,
              ),
            ),
            child: TextField(
              controller: secureCodeController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Secure Code',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: secureCodeError ? Colors.red[400] : AppColors.primary,
                  size: 22,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (secureCodeController.text.isEmpty) return;

                        if (widget.cashier?.secureCode ==
                            secureCodeController.text) {
                          // Set bypass first
                          await SecureCodeService.setBypass();

                          // Update dialog state
                          widget.ref
                              .read(dialogStateProvider.notifier)
                              .setBypass();

                          if (context.mounted) {
                            Navigator.pop(context);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Shift dialog bypassed for 6 hours'),
                                backgroundColor: Colors.green[600],
                              ),
                            );
                          }
                        } else {
                          setState(() => secureCodeError = true);
                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted)
                              setState(() => secureCodeError = false);
                          });
                        }
                      },
                      icon: Icon(
                        Icons.check,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          showSecureCodeField = false;
                          secureCodeController.clear();
                          secureCodeError = false;
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                labelStyle: TextStyle(
                  color: secureCodeError ? Colors.red[600] : Colors.grey[600],
                  fontSize: 16,
                ),
                errorText: secureCodeError ? 'Invalid secure code' : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Modern search input
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search employees...',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            onChanged: (value) => setState(() => searchQuery = value),
          ),
        ),

        const SizedBox(height: 24),

        // Enhanced multi-select container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Selected Employees',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${selectedEmployees.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Selected employees chips
              if (selectedEmployees.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(selectedEmployees.length, (index) {
                      final employee = selectedEmployees[index];
                      final isCashier = index == 0;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isCashier
                                ? [Colors.amber[400]!, Colors.amber[600]!]
                                : [
                                    AppColors.primary,
                                    AppColors.primary.withOpacity(0.8)
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (isCashier ? Colors.amber : AppColors.primary)
                                      .withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isCashier
                                  ? "${employee.name} (Cashier)"
                                  : employee.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedEmployees.remove(employee);
                                  widget.employeeController.text =
                                      selectedEmployees
                                          .map((e) => e.id)
                                          .join(',');
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

              if (selectedEmployees.isNotEmpty) const SizedBox(height: 20),

              // Employee list - reduced height for better scrolling
              Container(
                constraints: const BoxConstraints(maxHeight: 180),
                child: filteredEmployees.isEmpty
                    ? Container(
                        height: 100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                color: Colors.grey[400],
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No employees found',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: filteredEmployees.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: Colors.grey[200],
                          indent: 20,
                          endIndent: 20,
                        ),
                        itemBuilder: (context, index) {
                          final employee = filteredEmployees[index];
                          final isSelected =
                              selectedEmployees.contains(employee);
                          final isCashier = isSelected &&
                              selectedEmployees.indexOf(employee) == 0;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedEmployees.remove(employee);
                                  } else {
                                    selectedEmployees.add(employee);
                                  }
                                  widget.employeeController.text =
                                      selectedEmployees
                                          .map((e) => e.id)
                                          .join(',');
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? (isCashier
                                                ? Colors.amber[600]
                                                : AppColors.primary)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? (isCashier
                                                  ? Colors.amber[600]!
                                                  : AppColors.primary)
                                              : Colors.grey[400]!,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 14,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            employee.name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: isCashier
                                                  ? Colors.amber[700]
                                                  : isSelected
                                                      ? AppColors.primary
                                                      : Colors.grey[800],
                                            ),
                                          ),
                                          if (isCashier) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.amber[100],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: Colors.amber[300]!),
                                              ),
                                              child: Text(
                                                'CASHIER',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.amber[800],
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Modern action button - reduced margin
        Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: widget.isLoading || selectedEmployees.isEmpty
                ? null
                : () async {
                    // Capture refs and context before async operations
                    final dialogNotifier =
                        widget.ref.read(dialogStateProvider.notifier);
                    final shiftNotifier =
                        widget.ref.read(shiftProvider.notifier);
                    final navigator = Navigator.of(context);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    try {
                      // Hide dialog immediately
                      dialogNotifier.hideDialog();

                      // Start the shift
                      await shiftNotifier.startShift(
                        CreateShiftRequestModel(
                          employees:
                              selectedEmployees.map((e) => e.id).toList(),
                        ),
                      );

                      // Only proceed if widget is still mounted
                      if (mounted) {
                        // Refresh the shift provider
                        widget.ref.invalidate(shiftProvider);

                        // Close dialog
                        navigator.pop();

                        // Show success message
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: const Text('Shift started successfully'),
                            backgroundColor: Colors.green[600],
                          ),
                        );
                      }
                    } catch (e) {
                      // Only proceed if widget is still mounted
                      if (mounted) {
                        // If there's an error, show dialog again
                        dialogNotifier.showDialog();

                        // Show error message
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text('Error starting shift: $e'),
                            backgroundColor: Colors.red[600],
                          ),
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: selectedEmployees.isEmpty
                            ? Colors.grey[600]
                            : Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'CREATE SHIFT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: selectedEmployees.isEmpty
                              ? Colors.grey[600]
                              : Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
