import 'package:falsisters_pos_android/features/shift/data/model/create_shift_request_model.dart';
import 'package:falsisters_pos_android/features/shift/data/model/employee_model.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_dialog_provider.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_provider.dart';
import 'package:flutter/material.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/features/auth/data/providers/auth_provider.dart';

class EditShiftForm extends ConsumerWidget {
  final TextEditingController employeeController;
  final Map<String, dynamic> shiftData;

  const EditShiftForm({
    super.key,
    required this.employeeController,
    required this.shiftData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Consumer(builder: (context, ref, _) {
        final employees = ref.watch(employeeProvider);
        final isLoading =
            ref.watch(shiftProvider.select((state) => state.isLoading));
        final error = ref.watch(shiftProvider.select((state) => state.error));

        return employees.when(
          data: (employeeData) => _EditShiftFormContent(
            employees: employeeData,
            isLoading: isLoading,
            error: error?.toString(),
            employeeController: employeeController,
            ref: ref,
            shiftData: shiftData,
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

class _EditShiftFormContent extends StatefulWidget {
  final List<EmployeeModel> employees;
  final bool isLoading;
  final String? error;
  final TextEditingController employeeController;
  final WidgetRef ref;
  final Map<String, dynamic> shiftData;

  const _EditShiftFormContent({
    required this.employees,
    required this.isLoading,
    required this.error,
    required this.employeeController,
    required this.ref,
    required this.shiftData,
  });

  @override
  State<_EditShiftFormContent> createState() => _EditShiftFormContentState();
}

class _EditShiftFormContentState extends State<_EditShiftFormContent> {
  List<EmployeeModel> selectedEmployees = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initSelectedEmployees();
  }

  void _initSelectedEmployees() {
    if (widget.shiftData['employees'] != null) {
      final employeeIds = (widget.shiftData['employees'] as List)
          .map((e) => e.toString())
          .toList();

      selectedEmployees = widget.employees
          .where((employee) => employeeIds.contains(employee.id))
          .toList();

      widget.employeeController.text =
          selectedEmployees.map((e) => e.id).join(',');
    }
  }

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
                color: AppColors.accent,
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
                      color: AppColors.accent,
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
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${selectedEmployees.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
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
                                    AppColors.accent,
                                    AppColors.accent.withOpacity(0.8)
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (isCashier ? Colors.amber : AppColors.accent)
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

              // Employee list
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
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
                                                : AppColors.accent)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? (isCashier
                                                  ? Colors.amber[600]!
                                                  : AppColors.accent)
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
                                                      ? AppColors.accent
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

        const SizedBox(height: 32),

        // Modern action buttons
        Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent,
                      AppColors.accent.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: widget.isLoading || selectedEmployees.isEmpty
                      ? null
                      : () async {
                          final shiftId = widget.shiftData['id'] as String;

                          // Capture refs before async operations
                          final shiftNotifier =
                              widget.ref.read(shiftProvider.notifier);
                          final dialogNotifier =
                              widget.ref.read(dialogStateProvider.notifier);
                          final navigator = Navigator.of(context);

                          try {
                            // Mark that we're editing a shift
                            dialogNotifier.setEditingShift(true);

                            await shiftNotifier.editShift(
                              shiftId,
                              CreateShiftRequestModel(
                                employees:
                                    selectedEmployees.map((e) => e.id).toList(),
                              ),
                            );

                            if (mounted) {
                              // Only invalidate, don't refresh to avoid loading state
                              widget.ref.invalidate(shiftProvider);

                              navigator.pop();
                            }
                          } catch (e) {
                            // Handle error if needed
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error updating shift: $e'),
                                  backgroundColor: Colors.red[600],
                                ),
                              );
                            }
                          } finally {
                            // Clear editing state immediately after edit completes
                            if (mounted) {
                              dialogNotifier.setEditingShift(false);
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save_rounded,
                              color: selectedEmployees.isEmpty
                                  ? Colors.grey[600]
                                  : Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'UPDATE SHIFT',
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
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Logout section
        Column(
          children: [
            Text(
              'Not you?',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () async {
                // Close dialog first
                Navigator.of(context).pop();

                // Then logout
                await widget.ref.read(authProvider.notifier).logout();
              },
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.red[600],
                size: 18,
              ),
              label: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
