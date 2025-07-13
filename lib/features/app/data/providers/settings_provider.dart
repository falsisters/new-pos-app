import 'dart:io';
import 'package:falsisters_pos_android/features/app/data/model/settings_state.dart';
import 'package:falsisters_pos_android/features/app/data/services/settings_service.dart';
import 'package:falsisters_pos_android/features/sales/data/services/thermal_printing_service.dart';
import 'package:falsisters_pos_android/features/app/data/model/printer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<SettingsState>>((ref) {
  return SettingsNotifier(ref);
});

class SettingsNotifier extends StateNotifier<AsyncValue<SettingsState>> {
  final Ref _ref;
  late final SettingsService _settingsService;
  late final ThermalPrintingService _printingService;

  SettingsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _settingsService = _ref.read(settingsServiceProvider);
    _printingService = _ref.read(thermalPrintingServiceProvider);
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    state = const AsyncValue.loading();
    try {
      final selectedPrinter = await _settingsService.getSelectedPrinter();

      // Check Bluetooth, then get paired devices
      final isBluetoothEnabled = await _printingService.isBluetoothEnabled();
      debugPrint('Bluetooth enabled: $isBluetoothEnabled');

      List<ThermalPrinter> pairedPrinters = [];
      if (isBluetoothEnabled) {
        pairedPrinters = await _printingService.getPairedPrinters();
        debugPrint('Found ${pairedPrinters.length} thermal printers:');
        for (var printer in pairedPrinters) {
          debugPrint('  - ${printer.name} (${printer.address})');
        }
      }

      state = AsyncValue.data(SettingsState(
        selectedPrinter: selectedPrinter,
        availablePrinters: pairedPrinters,
        isScanning: false,
        isBluetoothEnabled: isBluetoothEnabled,
        errorMessage: pairedPrinters.isEmpty && isBluetoothEnabled
            ? 'No thermal printers found. Please pair your PT210 printer in Android Bluetooth settings first.'
            : null,
      ));
    } catch (e, st) {
      debugPrint('Error loading initial state: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> scanForPrinters() async {
    final currentState = state.value;
    if (currentState == null || currentState.isScanning) return;

    state = AsyncValue.data(currentState.copyWith(isScanning: true));

    try {
      // Check Bluetooth first
      final isBluetoothEnabled = await _printingService.isBluetoothEnabled();
      if (!isBluetoothEnabled) {
        state = AsyncValue.data(currentState.copyWith(
          isScanning: false,
          isBluetoothEnabled: false,
          errorMessage:
              'Bluetooth scanning requires location services to be enabled. Please enable location services and Bluetooth, then try again.',
        ));
        return;
      }

      if (Platform.isAndroid) {
        // Request permissions for thermal printer
        var bluetoothScanStatus = await Permission.bluetoothScan.request();
        var bluetoothConnectStatus =
            await Permission.bluetoothConnect.request();
        var locationStatus = await Permission.location.request();

        if (bluetoothScanStatus.isPermanentlyDenied ||
            bluetoothConnectStatus.isPermanentlyDenied ||
            locationStatus.isPermanentlyDenied) {
          await openAppSettings();
          throw Exception(
              'Required permissions are permanently denied. Please enable them in Settings.');
        }

        if (bluetoothScanStatus.isDenied ||
            bluetoothConnectStatus.isDenied ||
            locationStatus.isDenied) {
          throw Exception(
              'Bluetooth and location permissions are required for thermal printer scanning. Please grant permissions and try again.');
        }
      }

      // Scan for thermal printers
      final scannedPrinters = await _printingService.scanForPrinters();
      debugPrint('Scanned thermal printers: ${scannedPrinters.length}');

      state = AsyncValue.data(currentState.copyWith(
        availablePrinters: scannedPrinters,
        isScanning: false,
        isBluetoothEnabled: isBluetoothEnabled,
        errorMessage: scannedPrinters.isEmpty
            ? 'No thermal printers found. For PT210, please pair it in Android Bluetooth settings first, and ensure location services are enabled.'
            : null,
      ));
    } catch (e) {
      debugPrint('Thermal printer scan error: $e');
      state = AsyncValue.data(currentState.copyWith(
        isScanning: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> selectPrinter(ThermalPrinter printer) async {
    final currentState = state.value;
    if (currentState == null) return;

    try {
      await _settingsService.saveSelectedPrinter(printer);
      state = AsyncValue.data(currentState.copyWith(
        selectedPrinter: printer,
        errorMessage: null,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> forgetPrinter() async {
    final currentState = state.value;
    if (currentState == null) return;

    try {
      await _settingsService.removeSelectedPrinter();
      state = AsyncValue.data(currentState.copyWith(
        selectedPrinter: null,
        errorMessage: null,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> checkBluetoothStatus() async {
    final currentState = state.value;
    if (currentState == null) return;

    try {
      final isBluetoothEnabled = await _printingService.isBluetoothEnabled();
      state = AsyncValue.data(currentState.copyWith(
        isBluetoothEnabled: isBluetoothEnabled,
        errorMessage: null,
      ));
    } catch (e) {
      state = AsyncValue.data(currentState.copyWith(
        errorMessage: e.toString(),
      ));
    }
  }
}
