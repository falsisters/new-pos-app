import 'package:falsisters_pos_android/features/shift/data/model/create_shift_request_model.dart';
import 'package:falsisters_pos_android/features/shift/data/model/employee_model.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_provider.dart';
import 'package:flutter/material.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      padding: const EdgeInsets.all(16),
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
          loading: () => const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading employees..."),
              ],
            ),
          ),
          error: (err, stack) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text(
                  "Error loading employees: ${err.toString()}",
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(employeeProvider),
                  child: Text("Retry"),
                ),
              ],
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
    // Initialize selected employees based on the shift data
    _initSelectedEmployees();
  }

  void _initSelectedEmployees() {
    if (widget.shiftData['employees'] != null) {
      final employeeIds = (widget.shiftData['employees'] as List)
          .map((e) => e.toString())
          .toList();

      // Find matching employees from the employee list
      selectedEmployees = widget.employees
          .where((employee) => employeeIds.contains(employee.id))
          .toList();

      // Update the employee controller
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
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              widget.error!,
              style: TextStyle(color: Colors.red.shade800),
            ),
          ),

        // Search input
        TextField(
          decoration: InputDecoration(
            labelText: 'Search Employees',
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            labelStyle: const TextStyle(color: AppColors.primary),
          ),
          onChanged: (value) => setState(() => searchQuery = value),
        ),

        const SizedBox(height: 16),

        // Multi-select dropdown
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryLight),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryLight.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Selected Employees (${selectedEmployees.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ),

              // Selected employees chips with cashier indicator
              if (selectedEmployees.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(selectedEmployees.length, (index) {
                      final employee = selectedEmployees[index];
                      final isCashier = index == 0;

                      return Chip(
                        label: Text(
                          isCashier
                              ? "${employee.name} (Cashier)"
                              : employee.name,
                          style: const TextStyle(color: AppColors.white),
                        ),
                        backgroundColor:
                            isCashier ? Colors.teal : AppColors.secondary,
                        deleteIconColor: AppColors.white,
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            selectedEmployees.remove(employee);
                            widget.employeeController.text =
                                selectedEmployees.map((e) => e.id).join(',');
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

              // Employee list for selection
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: filteredEmployees.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No employees found',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: filteredEmployees.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          color: AppColors.primaryLight,
                        ),
                        itemBuilder: (context, index) {
                          final employee = filteredEmployees[index];
                          final isSelected =
                              selectedEmployees.contains(employee);
                          final isCashier = isSelected &&
                              selectedEmployees.indexOf(employee) == 0;

                          return CheckboxListTile(
                            title: Row(
                              children: [
                                Text(
                                  employee.name,
                                  style: TextStyle(
                                    color: isCashier
                                        ? Colors.teal
                                        : isSelected
                                            ? AppColors.primary
                                            : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                if (isCashier)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.teal),
                                      ),
                                      child: const Text(
                                        'Cashier',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            value: isSelected,
                            activeColor:
                                isCashier ? Colors.teal : AppColors.accent,
                            checkColor: AppColors.white,
                            onChanged: (selected) {
                              setState(() {
                                if (selected == true) {
                                  selectedEmployees.add(employee);
                                } else {
                                  selectedEmployees.remove(employee);
                                }
                                widget.employeeController.text =
                                    selectedEmployees
                                        .map((e) => e.id)
                                        .join(',');
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade400),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                onPressed: widget.isLoading
                    ? null
                    : () {
                        final shiftId = widget.shiftData['id'] as String;
                        widget.ref
                            .read(shiftProvider.notifier)
                            .editShift(
                              shiftId,
                              CreateShiftRequestModel(
                                employees:
                                    selectedEmployees.map((e) => e.id).toList(),
                              ),
                            )
                            .then((_) {
                          // Force a refresh of the provider to ensure UI is updated
                          widget.ref.invalidate(shiftProvider);
                          Navigator.pop(context);
                        });
                      },
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      )
                    : const Text(
                        'Update Shift',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
