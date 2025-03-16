import 'package:falsisters_pos_android/features/shift/data/model/create_shift_request_model.dart';
import 'package:falsisters_pos_android/features/shift/data/model/employee_model.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_provider.dart';
import 'package:flutter/material.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateShiftForm extends ConsumerWidget {
  final TextEditingController employeeController;

  const CreateShiftForm({
    super.key,
    required this.employeeController,
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

        return _ShiftFormContent(
          employees: employees.when(
            data: (data) => data,
            loading: () => [],
            error: (_, __) => [],
          ),
          isLoading: isLoading,
          error: error?.toString(),
          employeeController: employeeController,
          ref: ref,
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

  const _ShiftFormContent({
    required this.employees,
    required this.isLoading,
    required this.error,
    required this.employeeController,
    required this.ref,
  });

  @override
  State<_ShiftFormContent> createState() => _ShiftFormContentState();
}

class _ShiftFormContentState extends State<_ShiftFormContent> {
  List<EmployeeModel> selectedEmployees = [];
  String searchQuery = '';

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
          decoration: const InputDecoration(
            labelText: 'Search Employees',
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.primary,
            ),
          ),
          onChanged: (value) => setState(() => searchQuery = value),
        ),

        const SizedBox(height: 16),

        // Multi-select dropdown
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Selected Employees (${selectedEmployees.length})'),
              ),

              // Selected employees chips
              if (selectedEmployees.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedEmployees
                        .map((employee) => Chip(
                              label: Text(employee.name),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() {
                                  selectedEmployees.remove(employee);
                                  widget.employeeController.text =
                                      selectedEmployees
                                          .map((e) => e.id)
                                          .join(',');
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),

              // Employee list for selection
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = filteredEmployees[index];
                    final isSelected = selectedEmployees.contains(employee);

                    return CheckboxListTile(
                      title: Text(employee.name),
                      value: isSelected,
                      onChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            selectedEmployees.add(employee);
                          } else {
                            selectedEmployees.remove(employee);
                          }
                          widget.employeeController.text =
                              selectedEmployees.map((e) => e.id).join(',');
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: widget.isLoading
              ? null
              : () => {
                    widget.ref
                        .read(shiftProvider.notifier)
                        .createShift(
                          CreateShiftRequestModel(
                            employees:
                                selectedEmployees.map((e) => e.id).toList(),
                          ),
                        )
                        .then((shift) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop(shift);
                    }),
                  },
          child: widget.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Create Shift'),
        ),
      ],
    );
  }
}
