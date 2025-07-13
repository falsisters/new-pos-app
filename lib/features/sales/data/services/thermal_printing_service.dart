import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:falsisters_pos_android/features/sales/data/model/sale_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    required dynamic sale,
    required BuildContext context,
  }) async {
    try {
      debugPrint(
          'Starting thermal print process for: ${printer.name} (${printer.address})');
      debugPrint('Sale data type: ${sale.runtimeType}');

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

      // Use the working minimal receipt approach but with full receipt data
      debugPrint('Printing receipt using working minimal format...');
      await _printWorkingReceipt(thermalPrinter, sale);

      debugPrint('Receipt printing process completed');
    } catch (e) {
      debugPrint('Thermal print error: $e');
      throw Exception('Failed to print receipt: $e');
    }
  }

  Future<void> _printWorkingReceipt(Printer printer, dynamic sale) async {
    try {
      debugPrint('Generating working receipt format...');

      // Extract sale data using the same pattern as minimal receipt
      String total = '0.00';
      String receiptId = 'RECEIPT';
      String date = DateTime.now().toString().substring(0, 19);
      String cashier = 'CASHIER';
      List<String> itemLines = [];

      if (sale is SaleModel) {
        total = sale.totalAmount.toStringAsFixed(2);
        receiptId = sale.id.length > 8
            ? sale.id.substring(0, 8).toUpperCase()
            : sale.id.toUpperCase();
        date = _formatDate(sale.createdAt);
        cashier = sale.cashierId.length > 8
            ? sale.cashierId.substring(0, 8)
            : sale.cashierId;

        debugPrint('Processing ${sale.saleItems.length} items for receipt');

        // Process each item using simplified logic
        for (int i = 0; i < sale.saleItems.length; i++) {
          final item = sale.saleItems[i];

          try {
            String itemName = item.product.name.length > 20
                ? '${item.product.name.substring(0, 17)}...'
                : item.product.name;

            double itemPrice = 0.0;
            String itemQty = '1 pc';

            // Simplified price calculation
            if (item.isDiscounted && item.discountedPrice != null) {
              itemPrice = item.discountedPrice!;
            } else if (item.sackPriceId != null &&
                item.product.sackPrice.isNotEmpty) {
              final sackPrice = item.product.sackPrice.firstWhere(
                (sp) => sp.id == item.sackPriceId,
                orElse: () => item.product.sackPrice.first,
              );
              itemPrice = sackPrice.price * item.quantity;
              final qty = item.quantity.toInt();

              // Simplified sack type display
              switch (sackPrice.type.toString().split('.').last) {
                case 'FIFTY_KG':
                  itemQty = '$qty x 50kg';
                  break;
                case 'TWENTY_FIVE_KG':
                  itemQty = '$qty x 25kg';
                  break;
                case 'FIVE_KG':
                  itemQty = '$qty x 5kg';
                  break;
                default:
                  itemQty = '$qty sack';
              }
            } else if (item.perKiloPriceId != null &&
                item.product.perKiloPrice != null) {
              itemPrice = item.product.perKiloPrice!.price * item.quantity;
              itemQty = '${item.quantity.toStringAsFixed(1)}kg';
            }

            // Add to item lines (keep simple like working minimal receipt)
            itemLines.add('${i + 1}. $itemName');
            itemLines.add('   $itemQty - P${itemPrice.toStringAsFixed(2)}');

            if (item.isDiscounted && item.discountedPrice != null) {
              itemLines.add('   DISCOUNTED');
            }

            debugPrint(
                'Added item: $itemName - $itemQty - P${itemPrice.toStringAsFixed(2)}');
          } catch (e) {
            debugPrint('Error processing item ${i + 1}: $e');
            itemLines.add('${i + 1}. ${item.product.name} - Error');
          }
        }
      }

      // Create receipt using EXACT same structure as working minimal receipt
      final List<int> receiptBytes = [];

      // Initialize (same as working minimal)
      receiptBytes.addAll([0x1B, 0x40]); // ESC @

      // Center align (same as working minimal)
      receiptBytes.addAll([0x1B, 0x61, 0x01]); // ESC a 1

      // Bold on (same as working minimal)
      receiptBytes.addAll([0x1B, 0x45, 0x01]); // ESC E 1
      receiptBytes.addAll('RECEIPT\n'.codeUnits);
      receiptBytes.addAll([0x1B, 0x45, 0x00]); // ESC E 0

      // Left align (same as working minimal)
      receiptBytes.addAll([0x1B, 0x61, 0x00]); // ESC a 0
      receiptBytes.addAll('FALSISTERS RICE TRADING\n'.codeUnits);
      receiptBytes.addAll('Receipt: $receiptId\n'.codeUnits);
      receiptBytes.addAll('Date: $date\n'.codeUnits);
      receiptBytes.addAll('Cashier: $cashier\n'.codeUnits);
      receiptBytes.addAll('------------------------\n'.codeUnits);

      // Add items (same simple format as working minimal)
      for (final line in itemLines) {
        receiptBytes.addAll('$line\n'.codeUnits);
      }

      receiptBytes.addAll('------------------------\n'.codeUnits);
      receiptBytes.addAll('Total: P$total\n'.codeUnits);
      receiptBytes.addAll('Thank you!\n'.codeUnits);
      receiptBytes.addAll('\n\n'.codeUnits);

      // Cut (same as working minimal)
      receiptBytes.addAll([0x1D, 0x56, 0x00]); // GS V 0

      debugPrint('Generated ${receiptBytes.length} bytes using working format');

      // Use same printing method as working minimal receipt
      await _flutterThermalPrinter.printData(
        printer,
        Uint8List.fromList(receiptBytes),
      );

      debugPrint('Working receipt data sent successfully');
    } catch (e) {
      debugPrint('Working receipt generation failed: $e');
      throw Exception('Failed to generate working receipt: $e');
    }
  }

  // Let's also create a super minimal receipt test
  Future<void> _printMinimalReceipt(Printer printer, dynamic sale) async {
    try {
      debugPrint('Generating minimal receipt...');

      // Get just the essentials
      String total = '0.00';
      int itemCount = 0;

      if (sale is SaleModel) {
        total = sale.totalAmount.toStringAsFixed(2);
        itemCount = sale.saleItems.length;
      }

      // Create the most minimal receipt possible
      final List<int> receiptBytes = [];

      // Initialize
      receiptBytes.addAll([0x1B, 0x40]); // ESC @

      // Center align
      receiptBytes.addAll([0x1B, 0x61, 0x01]); // ESC a 1

      // Bold on
      receiptBytes.addAll([0x1B, 0x45, 0x01]); // ESC E 1
      receiptBytes.addAll('RECEIPT\n'.codeUnits);
      receiptBytes.addAll([0x1B, 0x45, 0x00]); // ESC E 0

      // Left align
      receiptBytes.addAll([0x1B, 0x61, 0x00]); // ESC a 0
      receiptBytes.addAll('FALSISTERS\n'.codeUnits);
      receiptBytes.addAll('Items: $itemCount\n'.codeUnits);
      receiptBytes.addAll('Total: P$total\n'.codeUnits);
      receiptBytes.addAll('Thank you!\n'.codeUnits);
      receiptBytes.addAll('\n\n'.codeUnits);

      // Cut
      receiptBytes.addAll([0x1D, 0x56, 0x00]); // GS V 0

      debugPrint('Generated minimal receipt: ${receiptBytes.length} bytes');

      await _flutterThermalPrinter.printData(
        printer,
        Uint8List.fromList(receiptBytes),
      );

      debugPrint('Minimal receipt sent');
    } catch (e) {
      debugPrint('Minimal receipt failed: $e');
      throw e;
    }
  }

  Future<void> debugPrintReceipt({
    required ThermalPrinter printer,
    required dynamic sale,
    required BuildContext context,
  }) async {
    try {
      debugPrint('Starting DEBUG receipt print for: ${printer.name}');

      final thermalPrinter = printer.toPrinter();

      // Connect (same as test print)
      await _flutterThermalPrinter.connect(thermalPrinter);
      await Future.delayed(const Duration(milliseconds: 1500));

      // Try the most minimal receipt first
      debugPrint('Trying minimal receipt...');
      await _printMinimalReceipt(thermalPrinter, sale);

      debugPrint('Debug minimal receipt completed');
    } catch (e) {
      debugPrint('Debug receipt failed: $e');
      throw Exception('Debug receipt failed: $e');
    }
  }

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
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      debugPrint('Date parsing error: $e');
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
