import 'package:falsisters_pos_android/features/app/data/model/printer_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';
part 'settings_state.g.dart';

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default([]) List<ThermalPrinter> availablePrinters,
    ThermalPrinter? selectedPrinter,
    @Default(false) bool isScanning,
    @Default(false) bool isBluetoothEnabled,
    String? errorMessage,
  }) = _SettingsState;

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);
}
