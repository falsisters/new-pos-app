import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:falsisters_pos_android/features/app/data/model/printer_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';
import 'package:falsisters_pos_android/features/sales/presentation/widgets/receipt_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class ThermalPrintingService {
  final _flutterThermalPrinter = FlutterThermalPrinter.instance;
  StreamSubscription<List<Printer>>? _devicesStreamSubscription;

  Future<bool> _ensureLocationServices() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled');
        return false;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied');
        return false;
      }

      debugPrint('Location services and permissions are available');
      return true;
    } catch (e) {
      debugPrint('Error checking location services: $e');
      return false;
    }
  }

  Future<bool> _ensureBluetoothPermissions() async {
    try {
      // Request necessary Bluetooth permissions
      final bluetoothScanStatus = await Permission.bluetoothScan.request();
      final bluetoothConnectStatus =
          await Permission.bluetoothConnect.request();
      final bluetoothAdvertiseStatus =
          await Permission.bluetoothAdvertise.request();

      if (bluetoothScanStatus.isPermanentlyDenied ||
          bluetoothConnectStatus.isPermanentlyDenied) {
        debugPrint('Bluetooth permissions permanently denied');
        return false;
      }

      if (bluetoothScanStatus.isDenied || bluetoothConnectStatus.isDenied) {
        debugPrint('Bluetooth permissions denied');
        return false;
      }

      debugPrint('Bluetooth permissions granted');
      return true;
    } catch (e) {
      debugPrint('Error requesting Bluetooth permissions: $e');
      return false;
    }
  }

  Future<List<ThermalPrinter>> getPairedPrinters() async {
    try {
      debugPrint('Getting paired/bonded Bluetooth devices...');

      // Ensure location services and permissions are available
      final locationOk = await _ensureLocationServices();
      if (!locationOk) {
        debugPrint('Location services not available for Bluetooth scanning');
        return [];
      }

      // Ensure Bluetooth permissions
      final bluetoothOk = await _ensureBluetoothPermissions();
      if (!bluetoothOk) {
        debugPrint('Bluetooth permissions not available');
        return [];
      }

      final completer = Completer<List<ThermalPrinter>>();
      final List<ThermalPrinter> printers = [];

      _devicesStreamSubscription?.cancel();

      try {
        await _flutterThermalPrinter.getPrinters(connectionTypes: [
          ConnectionType.BLE,
        ]);

        _devicesStreamSubscription =
            _flutterThermalPrinter.devicesStream.listen(
          (List<Printer> devices) {
            log('Found ${devices.length} thermal printers');

            printers.clear();
            for (var device in devices) {
              if (device.name != null && device.name!.isNotEmpty) {
                printers.add(ThermalPrinter.fromPrinter(device));
                debugPrint('Found printer: ${device.name} - ${device.address}');
              }
            }

            if (!completer.isCompleted) {
              completer.complete(List.from(printers));
            }
          },
          onError: (error) {
            debugPrint('Thermal printer scan error: $error');
            if (!completer.isCompleted) {
              completer.complete([]);
            }
          },
        );
      } catch (e) {
        debugPrint('Error starting thermal printer scan: $e');
        if (!completer.isCompleted) {
          completer.complete([]);
        }
      }

      // Wait for results with timeout
      try {
        final result = await completer.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            debugPrint('Thermal printer scan timeout');
            return List.from(printers);
          },
        );

        debugPrint('Found ${result.length} thermal printers');
        return result;
      } catch (e) {
        debugPrint('Error in getPairedPrinters: $e');
        return [];
      }
    } catch (e) {
      debugPrint('Exception in getPairedPrinters: $e');
      return [];
    }
  }

  Future<List<ThermalPrinter>> scanForPrinters() async {
    try {
      debugPrint('Scanning for thermal printers...');
      return await getPairedPrinters(); // Same as getPairedPrinters for now
    } catch (e) {
      debugPrint('Exception in scanForPrinters: $e');
      return [];
    }
  }

  Future<bool> isBluetoothEnabled() async {
    try {
      debugPrint('Checking if Bluetooth is enabled...');

      // Check location services first
      final locationOk = await _ensureLocationServices();
      if (!locationOk) {
        debugPrint('Bluetooth check failed: Location services not available');
        return false;
      }

      // Check Bluetooth permissions
      final bluetoothOk = await _ensureBluetoothPermissions();
      if (!bluetoothOk) {
        debugPrint('Bluetooth check failed: Permissions not available');
        return false;
      }

      // Try to start a quick scan to test Bluetooth availability
      try {
        await _flutterThermalPrinter
            .getPrinters(connectionTypes: [ConnectionType.BLE]);
        return true;
      } catch (e) {
        debugPrint('Bluetooth availability test failed: $e');
        return false;
      }
    } catch (e) {
      debugPrint('Bluetooth check failed: $e');
      return false;
    }
  }

  Future<void> printReceipt({
    required ThermalPrinter printer,
    required SaleModel sale,
    required BuildContext context,
  }) async {
    try {
      debugPrint(
          'Starting thermal print process for: ${printer.name} (${printer.address})');

      // Convert to flutter_thermal_printer's Printer model
      final thermalPrinter = printer.toPrinter();

      // First disconnect to ensure clean state
      try {
        await _flutterThermalPrinter.disconnect(thermalPrinter);
        debugPrint('Disconnected from printer');
        await Future.delayed(const Duration(milliseconds: 1000));
      } catch (e) {
        debugPrint('Disconnect error (expected if not connected): $e');
      }

      // Connect to the printer
      debugPrint('Connecting to printer...');
      await _flutterThermalPrinter.connect(thermalPrinter);

      // Wait for connection to establish
      await Future.delayed(const Duration(milliseconds: 2000));
      debugPrint('Connected to printer');

      // Since test print works, let's use the same approach as test print
      debugPrint('Printing receipt using direct ESC/POS commands...');

      // Generate receipt using ESC/POS commands (same as test print method)
      await _printReceiptWithEscPos(thermalPrinter, sale);

      debugPrint('Receipt printing process completed');
    } catch (e) {
      debugPrint('Thermal print error: $e');
      throw Exception('Failed to print receipt: $e');
    }
  }

  Future<void> _printReceiptWithEscPos(Printer printer, SaleModel sale) async {
    try {
      debugPrint('Generating ESC/POS receipt data...');

      // Create receipt using ESC/POS commands (similar to test print)
      final List<int> receiptBytes = [];

      // Initialize
      receiptBytes.addAll([0x1B, 0x40]); // ESC @

      // Center align
      receiptBytes.addAll([0x1B, 0x61, 0x01]); // ESC a 1

      // Store Header (bold)
      receiptBytes.addAll([0x1B, 0x45, 0x01]); // ESC E 1 - Bold on
      receiptBytes.addAll('FALSISTERS\n'.codeUnits);
      receiptBytes.addAll('RICE TRADING\n'.codeUnits);
      receiptBytes.addAll([0x1B, 0x45, 0x00]); // ESC E 0 - Bold off

      // Separator
      receiptBytes.addAll('--------------------------------\n'.codeUnits);

      // Left alignment
      receiptBytes.addAll([0x1B, 0x61, 0x00]); // ESC a 0

      // Receipt details
      receiptBytes.addAll(
          'Receipt #: ${sale.id.substring(0, 8).toUpperCase()}\n'.codeUnits);
      receiptBytes.addAll('Date: ${_formatDate(sale.createdAt)}\n'.codeUnits);
      receiptBytes
          .addAll('Cashier: ${sale.cashierId.substring(0, 8)}\n'.codeUnits);
      receiptBytes.addAll('--------------------------------\n'.codeUnits);

      // Items
      for (final item in sale.saleItems) {
        final isDiscounted = item.isDiscounted && item.discountedPrice != null;
        double itemTotal;
        String quantityDisplay;

        if (item.sackPrice != null) {
          itemTotal = isDiscounted
              ? item.discountedPrice!
              : item.sackPrice!.price * item.quantity;
          quantityDisplay =
              '${item.quantity.toInt()} sack${item.quantity > 1 ? "s" : ""}';
        } else if (item.perKiloPrice != null) {
          itemTotal = isDiscounted
              ? item.discountedPrice!
              : item.perKiloPrice!.price * item.quantity;
          quantityDisplay = '${item.quantity.toStringAsFixed(2)} kg';
          if (item.isGantang) {
            quantityDisplay += ' (Gantang)';
          }
        } else {
          itemTotal = isDiscounted ? item.discountedPrice! : 0;
          quantityDisplay = '${item.quantity.toInt()} pcs';
        }

        // Product name (bold)
        receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
        receiptBytes.addAll('${item.product.name}\n'.codeUnits);
        receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off

        // Quantity and price on same line
        final qtyPriceLine =
            '$quantityDisplay     P${itemTotal.toStringAsFixed(2)}\n';
        receiptBytes.addAll(qtyPriceLine.codeUnits);

        if (isDiscounted) {
          receiptBytes.addAll('DISCOUNTED\n'.codeUnits);
        }
        receiptBytes.addAll('\n'.codeUnits); // Extra line for spacing
      }

      receiptBytes.addAll('--------------------------------\n'.codeUnits);

      // Total (bold and larger)
      receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
      receiptBytes.addAll([0x1D, 0x21, 0x01]); // Double height
      receiptBytes
          .addAll('TOTAL: P${sale.totalAmount.toStringAsFixed(2)}\n'.codeUnits);
      receiptBytes.addAll([0x1D, 0x21, 0x00]); // Normal size
      receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off

      receiptBytes.addAll(
          'Payment: ${sale.paymentMethod.toString().split('.').last.replaceAll('_', ' ')}\n'
              .codeUnits);
      receiptBytes.addAll('\n'.codeUnits);

      // Center alignment for footer
      receiptBytes.addAll([0x1B, 0x61, 0x01]); // ESC a 1
      receiptBytes.addAll('Thank you for your business!\n'.codeUnits);
      receiptBytes.addAll('Please come again\n'.codeUnits);
      receiptBytes.addAll('\n\n'.codeUnits);

      // Cut
      receiptBytes.addAll([0x1D, 0x56, 0x00]); // GS V 0

      debugPrint('Generated ${receiptBytes.length} bytes of receipt data');

      // Print using printData method (same as test print)
      await _flutterThermalPrinter.printData(
        printer,
        Uint8List.fromList(receiptBytes),
      );

      debugPrint('Receipt data sent successfully');
    } catch (e) {
      debugPrint('ESC/POS receipt generation failed: $e');
      throw e;
    }
  }

  // Update test print to be even simpler for comparison
  Future<void> testPrint({
    required ThermalPrinter printer,
    required BuildContext context,
  }) async {
    try {
      debugPrint('Starting test print for: ${printer.name}');

      final thermalPrinter = printer.toPrinter();

      // Connect
      await _flutterThermalPrinter.connect(thermalPrinter);
      await Future.delayed(const Duration(milliseconds: 1500));

      // Generate simple test data using ESC/POS commands
      final List<int> testBytes = [];

      // Initialize
      testBytes.addAll([0x1B, 0x40]); // ESC @

      // Center align
      testBytes.addAll([0x1B, 0x61, 0x01]); // ESC a 1

      // Bold on
      testBytes.addAll([0x1B, 0x45, 0x01]); // ESC E 1
      testBytes.addAll('TEST PRINT\n'.codeUnits);
      testBytes.addAll([0x1B, 0x45, 0x00]); // ESC E 0

      // Left align
      testBytes.addAll([0x1B, 0x61, 0x00]); // ESC a 0
      testBytes.addAll('Printer: ${printer.name}\n'.codeUnits);
      testBytes.addAll('Address: ${printer.address}\n'.codeUnits);
      testBytes.addAll(
          'Time: ${DateTime.now().toString().substring(0, 19)}\n'.codeUnits);
      testBytes.addAll('\n'.codeUnits);
      testBytes.addAll('If you can see this,\n'.codeUnits);
      testBytes.addAll('printing works!\n'.codeUnits);
      testBytes.addAll('\n\n'.codeUnits);

      // Cut
      testBytes.addAll([0x1D, 0x56, 0x00]); // GS V 0

      debugPrint('Sending ${testBytes.length} test bytes');

      await _flutterThermalPrinter.printData(
        thermalPrinter,
        Uint8List.fromList(testBytes),
      );

      debugPrint('Test print completed');
    } catch (e) {
      debugPrint('Test print failed: $e');
      throw Exception('Test print failed: $e');
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  void stopScan() {
    try {
      _flutterThermalPrinter.stopScan();
    } catch (e) {
      debugPrint('Error stopping scan: $e');
    }
  }

  void dispose() {
    try {
      _devicesStreamSubscription?.cancel();
      _flutterThermalPrinter.stopScan();
    } catch (e) {
      debugPrint('Error disposing thermal printer service: $e');
    }
  }
}

final thermalPrintingServiceProvider = Provider<ThermalPrintingService>((ref) {
  final service = ThermalPrintingService();
  ref.onDispose(() => service.dispose());
  return service;
});
