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

      // Check Bluetooth status
      final isBluetoothEnabled = await _printingService.isBluetoothEnabled();
      debugPrint('Bluetooth enabled: $isBluetoothEnabled');

      // Get all available printers (USB + Bluetooth)
      List<ThermalPrinter> allPrinters = [];
      try {
        allPrinters = await _printingService.getPairedPrinters();
        debugPrint('Found ${allPrinters.length} total printers:');
        for (var printer in allPrinters) {
          debugPrint('  - ${printer.name} (${printer.connectionDisplayName})');
        }
      } catch (e) {
        debugPrint('Error getting printers: $e');
      }

      state = AsyncValue.data(SettingsState(
        selectedPrinter: selectedPrinter,
        availablePrinters: allPrinters,
        isScanning: false,
        isBluetoothEnabled: isBluetoothEnabled,
        errorMessage: allPrinters.isEmpty
            ? 'No printers found. For Bluetooth: pair your printer in Android settings. For USB: connect via USB cable.'
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
      // Check Bluetooth first for Bluetooth printers
      final isBluetoothEnabled = await _printingService.isBluetoothEnabled();

      if (!isBluetoothEnabled) {
        // Still allow USB scanning even if Bluetooth is disabled
        debugPrint('Bluetooth disabled, scanning for USB printers only...');
      }

      if (Platform.isAndroid) {
        // Request permissions for Bluetooth printers
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
          debugPrint(
              'Bluetooth permissions denied, USB scanning may still work');
        }
      }

      // Scan for all types of printers (USB + Bluetooth)
      final scannedPrinters = await _printingService.scanForPrinters();
      debugPrint('Scanned printers: ${scannedPrinters.length}');

      final usbPrinters = scannedPrinters.where((p) => p.isUSBPrinter).length;
      final bluetoothPrinters =
          scannedPrinters.where((p) => !p.isUSBPrinter).length;
      debugPrint('USB: $usbPrinters, Bluetooth: $bluetoothPrinters');

      String? errorMessage;
      if (scannedPrinters.isEmpty) {
        errorMessage = 'No printers found.\n\n'
            'For Bluetooth printers: Pair in Android Bluetooth settings first and ensure location services are enabled.\n\n'
            'For USB printers: Connect via USB cable and ensure the device supports USB printing.';
      }

      state = AsyncValue.data(currentState.copyWith(
        availablePrinters: scannedPrinters,
        isScanning: false,
        isBluetoothEnabled: isBluetoothEnabled,
        errorMessage: errorMessage,
      ));
    } catch (e) {
      debugPrint('Printer scan error: $e');
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
