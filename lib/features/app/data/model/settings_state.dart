import 'package:falsisters_pos_android/features/app/data/model/printer_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';
part 'settings_state.g.dart';

enum PrintCopiesSetting {
  ONE_COPY,
  TWO_COPIES,
  PROMPT_EVERY_SALE,
}

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default([]) List<ThermalPrinter> availablePrinters,
    ThermalPrinter? selectedPrinter,
    @Default(false) bool isScanning,
    @Default(false) bool isBluetoothEnabled,
    @Default(PrintCopiesSetting.TWO_COPIES)
    PrintCopiesSetting printCopiesSetting,
    @Default(false) bool isKioskModeEnabled,
    String? errorMessage,
  }) = _SettingsState;

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);
}
