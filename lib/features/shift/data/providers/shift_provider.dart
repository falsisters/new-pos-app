import 'package:falsisters_pos_android/features/shift/data/model/current_shift_state.dart';
import 'package:falsisters_pos_android/features/shift/data/model/employee_model.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_notifier.dart';
import 'package:falsisters_pos_android/features/shift/data/repository/shift_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shiftProvider =
    AsyncNotifierProvider<ShiftNotifier, CurrentShiftState>(() {
  return ShiftNotifier();
});

final currentShiftProvider = Provider<CurrentShiftState?>((ref) {
  return ref.watch(shiftProvider).whenData((state) => state).value;
});

final isShiftActiveProvider = Provider<bool?>((ref) {
  return ref
      .watch(shiftProvider)
      .whenData((state) => state.isShiftActive)
      .value;
});

final employeeProvider = FutureProvider<List<EmployeeModel>>((ref) async {
  final ShiftRepository shiftRepository = ShiftRepository();
  final employees = await shiftRepository.getEmployees();
  return employees;
});
