import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/features/app/data/model/printer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String selectedPrinterKey = 'selected_thermal_printer';

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
}

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});
