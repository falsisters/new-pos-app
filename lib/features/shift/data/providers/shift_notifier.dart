import 'package:falsisters_pos_android/features/shift/data/model/create_shift_request_model.dart';
import 'package:falsisters_pos_android/features/shift/data/model/current_shift_state.dart';
import 'package:falsisters_pos_android/features/shift/data/model/employee_model.dart';
import 'package:falsisters_pos_android/features/shift/data/model/shift_model.dart';
import 'package:falsisters_pos_android/features/shift/data/repository/shift_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShiftNotifier extends AsyncNotifier<CurrentShiftState> {
  final ShiftRepository _shiftRepository = ShiftRepository();

  @override
  Future<CurrentShiftState> build() async {
    // Get the latest shift, if the latest shift's end time is null, there is no active shift, build the state accordingly
    final shifts = await _shiftRepository.getShifts();

    if (shifts.isEmpty) {
      return CurrentShiftState(
        shift: null,
        isShiftActive: false,
      );
    }

    try {
      final activeShift = shifts.firstWhere(
        (shift) => shift.endTime == null,
      );

      return CurrentShiftState(
        shift: activeShift,
        isShiftActive: true,
      );
    } catch (e) {
      return CurrentShiftState(
        shift: null,
        isShiftActive: false,
      );
    }
  }

  Future<List<ShiftModel>> getShifts() async {
    return await _shiftRepository.getShifts();
  }

  Future<void> startShift(List<EmployeeModel> employee) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final employees = CreateShiftRequestModel(
          employees: employee.map((e) => e.id).toList(),
        );

        final shift = await _shiftRepository.createShift(employees);

        return CurrentShiftState(
          shift: shift,
          isShiftActive: true,
        );
      } catch (e) {
        return CurrentShiftState(
          error: e.toString(),
        );
      }
    });
  }

  Future<void> endShift() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        // Safely access the current state value
        final currentState = state.value;

        if (currentState != null) {
          final shiftId = currentState.shift?.id;

          if (shiftId != null) {
            await _shiftRepository.endShift(shiftId);
          }

          return CurrentShiftState(
            shift: null,
            isShiftActive: false,
          );
        } else {
          return CurrentShiftState(
            error: 'No active shift found',
          );
        }
      } catch (e) {
        return CurrentShiftState(
          error: e.toString(),
        );
      }
    });
  }

  Future<ShiftModel> createShift(CreateShiftRequestModel shift) async {
    return await _shiftRepository.createShift(shift);
  }
}
