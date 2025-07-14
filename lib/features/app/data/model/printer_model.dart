import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'printer_model.freezed.dart';
part 'printer_model.g.dart';

@freezed
sealed class ThermalPrinter with _$ThermalPrinter {
  const ThermalPrinter._();

  const factory ThermalPrinter({
    required String name,
    required String address,
    @Default(false) bool isConnected,
    @Default(false) bool isBonded,
    @Default(ConnectionType.BLE) ConnectionType connectionType,
    String? vendorId,
    String? productId,
    // Add USB specific fields
    String? devicePath,
    int? usbVendorId,
    int? usbProductId,
  }) = _ThermalPrinter;

  factory ThermalPrinter.fromJson(Map<String, dynamic> json) =>
      _$ThermalPrinterFromJson(json);

  // Convert from flutter_thermal_printer's Printer model
  factory ThermalPrinter.fromPrinter(Printer printer) {
    return ThermalPrinter(
      name: printer.name ?? 'Unknown Device',
      address: printer.address ?? '',
      isConnected: printer.isConnected ?? false,
      isBonded: printer.connectionType ==
          ConnectionType.BLE, // BLE devices can be bonded
      connectionType: printer.connectionType ?? ConnectionType.BLE,
      vendorId: printer.vendorId,
      productId: printer.productId,
      // USB specific mapping
      devicePath: printer.address, // For USB, address might be device path
      usbVendorId:
          printer.vendorId != null ? int.tryParse(printer.vendorId!) : null,
      usbProductId:
          printer.productId != null ? int.tryParse(printer.productId!) : null,
    );
  }

  // Convert to flutter_thermal_printer's Printer model
  Printer toPrinter() {
    return Printer(
      name: name,
      address: address,
      isConnected: isConnected,
      connectionType: connectionType,
      vendorId: vendorId,
      productId: productId,
    );
  }

  // Helper to check if this is a USB printer
  bool get isUSBPrinter => connectionType == ConnectionType.USB;

  // Helper to get display connection type
  String get connectionDisplayName {
    switch (connectionType) {
      case ConnectionType.BLE:
        return 'Bluetooth';
      case ConnectionType.USB:
        return 'USB';
      default:
        return connectionType.name.toUpperCase();
    }
  }
}
