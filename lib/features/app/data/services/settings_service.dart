import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/features/app/data/model/printer_model.dart';
import 'package:falsisters_pos_android/features/app/data/model/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String selectedPrinterKey = 'selected_thermal_printer';
const String printCopiesSettingKey = 'print_copies_setting';

class SettingsService {
  Future<void> saveSelectedPrinter(ThermalPrinter printer) async {
    final prefs = await SharedPreferences.getInstance();
    final printerJson = jsonEncode(printer.toJson());
    await prefs.setString(selectedPrinterKey, printerJson);
  }

  Future<ThermalPrinter?> getSelectedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final printerJson = prefs.getString(selectedPrinterKey);
    if (printerJson == null) {
      return null;
    }
    final printerMap = jsonDecode(printerJson) as Map<String, dynamic>;
    return ThermalPrinter.fromJson(printerMap);
  }

  Future<void> removeSelectedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(selectedPrinterKey);
  }

  Future<void> savePrintCopiesSetting(PrintCopiesSetting setting) async {
    final prefs = await SharedPreferences.getInstance();
    final settingName = setting.name;
    debugPrint('=== SAVING PRINT COPIES SETTING ===');
    debugPrint('Setting enum: $setting');
    debugPrint('Setting name: $settingName');
    debugPrint('Key: $printCopiesSettingKey');

    final success = await prefs.setString(printCopiesSettingKey, settingName);
    debugPrint('Save successful: $success');

    // Verify it was saved
    final saved = prefs.getString(printCopiesSettingKey);
    debugPrint('Verification - saved value: $saved');
  }

  Future<PrintCopiesSetting> getPrintCopiesSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final settingString = prefs.getString(printCopiesSettingKey);

    debugPrint('=== LOADING PRINT COPIES SETTING ===');
    debugPrint('Key: $printCopiesSettingKey');
    debugPrint('Raw value from SharedPreferences: $settingString');

    if (settingString == null) {
      debugPrint('No setting found, using default: TWO_COPIES');
      return PrintCopiesSetting.TWO_COPIES;
    }

    // List all available enum values for debugging
    debugPrint('Available enum values:');
    for (var enumValue in PrintCopiesSetting.values) {
      debugPrint('  - ${enumValue.name} (${enumValue.toString()})');
    }

    final setting = PrintCopiesSetting.values.firstWhere(
      (e) => e.name == settingString,
      orElse: () {
        debugPrint(
            'Invalid setting found: $settingString, using default: TWO_COPIES');
        return PrintCopiesSetting.TWO_COPIES;
      },
    );

    debugPrint('Final loaded setting: $setting (${setting.name})');
    return setting;
  }
}

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});
