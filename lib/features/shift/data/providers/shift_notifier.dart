import 'package:falsisters_pos_android/features/shift/data/model/create_shift_request_model.dart';
import 'package:falsisters_pos_android/features/shift/data/model/current_shift_state.dart';
import 'package:falsisters_pos_android/features/shift/data/model/shift_model.dart';
import 'package:falsisters_pos_android/features/shift/data/repository/shift_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShiftNotifier extends AsyncNotifier<CurrentShiftState> {
  final ShiftRepository _shiftRepository = ShiftRepository();

  @override
  Future<CurrentShiftState> build() async {
    try {
      // Get the latest shift, if the latest shift's end time is null, there is an active shift
      final shifts = await _shiftRepository.getShifts();

      if (shifts.isEmpty) {
        return CurrentShiftState(
          shift: null,
          isShiftActive: false,
        );
      }

      try {
        // Look for the most recent shift that hasn't ended
        final activeShift = shifts.firstWhere(
          (shift) => shift.endTime == null,
        );

        return CurrentShiftState(
          shift: activeShift,
          isShiftActive: true,
        );
      } catch (e) {
        // No active shift found
        return CurrentShiftState(
          shift: null,
          isShiftActive: false,
        );
      }
    } catch (e) {
      // Error fetching shifts
      return CurrentShiftState(
        shift: null,
        isShiftActive: false,
        error: e.toString(),
      );
    }
  }

  Future<List<ShiftModel>> getShifts() async {
    return await _shiftRepository.getShifts();
  }

  Future<void> startShift(CreateShiftRequestModel shift) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final newShift = await _shiftRepository.createShift(shift);
        final newState = CurrentShiftState(
          shift: newShift,
          isShiftActive: true,
        );
        return newState;
      } catch (e) {
        return CurrentShiftState(
          error: e.toString(),
        );
      }
    });
  }

  Future<void> refreshCurrentShift() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
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

  Future<void> editShift(String shiftId, CreateShiftRequestModel shift) async {
    // Don't set loading state to avoid triggering dialog during edit
    state = await AsyncValue.guard(() async {
      try {
        final updatedShift = await _shiftRepository.editShift(shiftId, shift);
        return CurrentShiftState(
          shift: updatedShift,
          isShiftActive: true,
        );
      } catch (e) {
        // Keep the current state if edit fails
        final currentState = state.value;
        return currentState ??
            CurrentShiftState(
              error: e.toString(),
            );
      }
    });
  }

  Future<ShiftModel> createShift(CreateShiftRequestModel shift) async {
    return await _shiftRepository.createShift(shift);
  }
}
