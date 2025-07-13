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
  }) = _ThermalPrinter;

  factory ThermalPrinter.fromJson(Map<String, dynamic> json) =>
      _$ThermalPrinterFromJson(json);

  // Convert from flutter_thermal_printer's Printer model
  factory ThermalPrinter.fromPrinter(Printer printer) {
    return ThermalPrinter(
      name: printer.name ?? 'Unknown Device',
      address: printer.address ?? '',
      isConnected: printer.isConnected ?? false,
      isBonded: true, // Assume discovered printers are bondable
      connectionType: printer.connectionType ?? ConnectionType.BLE,
      vendorId: printer.vendorId,
      productId: printer.productId,
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
}
