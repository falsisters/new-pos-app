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

  // Bluetooth printing constants
  static const int _bluetoothChunkSize = 20; // Bytes per chunk for Bluetooth
  static const int _bluetoothLineDelay = 100; // ms between lines
  static const int _bluetoothChunkDelay = 50; // ms between chunks
  static const int _maxLineLength = 32; // Characters per line for 58mm paper

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
      debugPrint('Getting all available printers (Bluetooth + USB)...');

      final List<ThermalPrinter> allPrinters = [];

      // Get Bluetooth printers
      final bluetoothPrinters = await _getBluetoothPrinters();
      allPrinters.addAll(bluetoothPrinters);

      // Get USB printers
      final usbPrinters = await _getUSBPrinters();
      allPrinters.addAll(usbPrinters);

      debugPrint(
          'Found ${allPrinters.length} total printers (${bluetoothPrinters.length} Bluetooth, ${usbPrinters.length} USB)');
      return allPrinters;
    } catch (e) {
      debugPrint('Exception in getPairedPrinters: $e');
      return [];
    }
  }

  Future<List<ThermalPrinter>> _getBluetoothPrinters() async {
    try {
      debugPrint('Getting Bluetooth printers...');

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
            log('Found ${devices.length} Bluetooth printers');

            printers.clear();
            for (var device in devices) {
              if (device.name != null && device.name!.isNotEmpty) {
                printers.add(ThermalPrinter.fromPrinter(device));
                debugPrint(
                    'Found Bluetooth printer: ${device.name} - ${device.address}');
              }
            }

            if (!completer.isCompleted) {
              completer.complete(List.from(printers));
            }
          },
          onError: (error) {
            debugPrint('Bluetooth printer scan error: $error');
            if (!completer.isCompleted) {
              completer.complete([]);
            }
          },
        );
      } catch (e) {
        debugPrint('Error starting Bluetooth printer scan: $e');
        if (!completer.isCompleted) {
          completer.complete([]);
        }
      }

      // Wait for results with timeout
      try {
        final result = await completer.future.timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            debugPrint('Bluetooth printer scan timeout');
            return List.from(printers);
          },
        );

        return result;
      } catch (e) {
        debugPrint('Error in _getBluetoothPrinters: $e');
        return [];
      }
    } catch (e) {
      debugPrint('Exception in _getBluetoothPrinters: $e');
      return [];
    }
  }

  Future<List<ThermalPrinter>> _getUSBPrinters() async {
    try {
      debugPrint('Getting USB printers...');

      final completer = Completer<List<ThermalPrinter>>();
      final List<ThermalPrinter> printers = [];

      try {
        await _flutterThermalPrinter.getPrinters(connectionTypes: [
          ConnectionType.USB,
        ]);

        // Listen for USB devices
        final subscription = _flutterThermalPrinter.devicesStream.listen(
          (List<Printer> devices) {
            log('Found ${devices.length} USB devices');

            final usbDevices = devices
                .where((device) => device.connectionType == ConnectionType.USB)
                .toList();

            printers.clear();
            for (var device in usbDevices) {
              final printer = ThermalPrinter.fromPrinter(device);
              printers.add(printer);
              debugPrint(
                  'Found USB printer: ${device.name} - VID: ${device.vendorId}, PID: ${device.productId}');
            }

            if (!completer.isCompleted) {
              completer.complete(List.from(printers));
            }
          },
          onError: (error) {
            debugPrint('USB printer scan error: $error');
            if (!completer.isCompleted) {
              completer.complete([]);
            }
          },
        );

        // Auto-complete after timeout
        Timer(const Duration(seconds: 5), () {
          if (!completer.isCompleted) {
            subscription.cancel();
            completer.complete(List.from(printers));
          }
        });
      } catch (e) {
        debugPrint('Error starting USB printer scan: $e');
        if (!completer.isCompleted) {
          completer.complete([]);
        }
      }

      try {
        final result = await completer.future.timeout(
          const Duration(seconds: 6),
          onTimeout: () {
            debugPrint('USB printer scan timeout');
            return List.from(printers);
          },
        );

        debugPrint('Found ${result.length} USB printers');
        return result;
      } catch (e) {
        debugPrint('Error in _getUSBPrinters: $e');
        return [];
      }
    } catch (e) {
      debugPrint('Exception in _getUSBPrinters: $e');
      return [];
    }
  }

  Future<List<ThermalPrinter>> scanForPrinters() async {
    try {
      debugPrint('Scanning for all types of printers...');
      return await getPairedPrinters(); // This now includes both Bluetooth and USB
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

  Future<void> _printViaBluetooth(
      Printer thermalPrinter, dynamic sale, ThermalPrinter printer) async {
    try {
      debugPrint('Printing via Bluetooth with chunking...');

      // First disconnect to ensure clean state
      try {
        await _flutterThermalPrinter.disconnect(thermalPrinter);
        debugPrint('Disconnected from Bluetooth printer');
        await Future.delayed(const Duration(milliseconds: 1000));
      } catch (e) {
        debugPrint(
            'Bluetooth disconnect error (expected if not connected): $e');
      }

      // Connect to the printer
      debugPrint('Connecting to Bluetooth printer...');
      await _flutterThermalPrinter.connect(thermalPrinter);

      // Wait for connection to establish
      await Future.delayed(const Duration(milliseconds: 2000));
      debugPrint('Connected to Bluetooth printer');

      // Use optimized Bluetooth receipt format with chunking
      await _printBluetoothOptimizedReceipt(thermalPrinter, sale);
    } catch (e) {
      debugPrint('Bluetooth printing error: $e');
      throw e;
    }
  }

  Future<void> _printBluetoothOptimizedReceipt(
      Printer printer, dynamic sale) async {
    try {
      debugPrint('Generating Bluetooth-optimized receipt...');

      // Extract sale data with size limits for Bluetooth
      String total = '0.00';
      String receiptId = 'RECEIPT';
      String date = DateTime.now().toString().substring(0, 16);
      String cashier = 'CASHIER';
      List<Map<String, String>> items = [];

      if (sale is SaleModel) {
        total = sale.totalAmount.toStringAsFixed(2);
        receiptId = sale.id.length > 6
            ? sale.id.substring(0, 6).toUpperCase()
            : sale.id.toUpperCase();
        date = _formatDate(sale.createdAt);
        cashier = sale.cashierId.length > 6
            ? sale.cashierId.substring(0, 6)
            : sale.cashierId;

        debugPrint(
            'Processing ${sale.saleItems.length} items for Bluetooth receipt');

        // Process items with length limits
        for (int i = 0; i < sale.saleItems.length; i++) {
          final item = sale.saleItems[i];

          try {
            // Truncate item name for Bluetooth bandwidth
            String itemName = item.product.name.length > 18
                ? '${item.product.name.substring(0, 15)}...'
                : item.product.name;

            double itemPrice = 0.0;
            String itemQty = '1pc';

            // Simplified price calculation for Bluetooth
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

              // Shortened sack type for Bluetooth
              switch (sackPrice.type.toString().split('.').last) {
                case 'FIFTY_KG':
                  itemQty = '${qty}x50kg';
                  break;
                case 'TWENTY_FIVE_KG':
                  itemQty = '${qty}x25kg';
                  break;
                case 'FIVE_KG':
                  itemQty = '${qty}x5kg';
                  break;
                default:
                  itemQty = '${qty}sack';
              }
            } else if (item.perKiloPriceId != null &&
                item.product.perKiloPrice != null) {
              itemPrice = item.product.perKiloPrice!.price * item.quantity;
              itemQty = '${item.quantity.toStringAsFixed(1)}kg';
            }

            items.add({
              'name': itemName,
              'qty': itemQty,
              'price': 'P${itemPrice.toStringAsFixed(2)}',
            });

            debugPrint(
                'Added BT item: $itemName - $itemQty - P${itemPrice.toStringAsFixed(2)}');
          } catch (e) {
            debugPrint('Error processing BT item ${i + 1}: $e');
          }
        }
      }

      // Create receipt lines for chunked sending
      final List<String> receiptLines = [];

      // Header (keep simple for Bluetooth)
      receiptLines.add('');
      receiptLines.add(_centerText('FALSISTERS', _maxLineLength));
      receiptLines.add(_centerText('RICE TRADING', _maxLineLength));
      receiptLines.add(_padLine('-', _maxLineLength));

      // Receipt info (shortened for Bluetooth)
      receiptLines.add('ID: $receiptId');
      receiptLines.add('Date: $date');
      receiptLines.add('Cashier: $cashier');
      receiptLines.add(_padLine('-', _maxLineLength));

      // Items (with proper line wrapping)
      for (int i = 0; i < items.length; i++) {
        final item = items[i];

        // Item name line
        receiptLines.add('${i + 1}. ${item['name']}');

        // Quantity and price line (ensure it fits)
        final qtyPriceLine = '${item['qty']} - ${item['price']}';
        if (qtyPriceLine.length <= _maxLineLength) {
          receiptLines.add('   $qtyPriceLine');
        } else {
          // Split if too long
          receiptLines.add('   ${item['qty']}');
          receiptLines.add('   ${item['price']}');
        }
        receiptLines.add(''); // Empty line between items
      }

      receiptLines.add(_padLine('-', _maxLineLength));
      receiptLines.add('TOTAL: P$total');
      receiptLines.add('');
      receiptLines.add(_centerText('Thank you!', _maxLineLength));
      receiptLines.add('');
      receiptLines.add('');

      debugPrint(
          'Generated ${receiptLines.length} lines for Bluetooth printing');

      // Send receipt using chunked approach
      await _sendBluetoothChunkedReceipt(printer, receiptLines);

      debugPrint('Bluetooth receipt sent successfully');
    } catch (e) {
      debugPrint('Bluetooth receipt generation failed: $e');
      throw Exception('Failed to generate Bluetooth receipt: $e');
    }
  }

  Future<void> _sendBluetoothChunkedReceipt(
      Printer printer, List<String> lines) async {
    try {
      debugPrint('Sending ${lines.length} lines via Bluetooth chunks...');

      // Initialize printer
      List<int> initBytes = [0x1B, 0x40]; // ESC @
      await _sendBluetoothChunk(printer, Uint8List.fromList(initBytes));
      await Future.delayed(Duration(milliseconds: _bluetoothLineDelay));

      // Send each line with proper timing
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];

        // Handle special formatting
        List<int> lineBytes = [];

        if (line.contains('FALSISTERS')) {
          // Bold and center for header
          lineBytes.addAll([0x1B, 0x61, 0x01]); // Center
          lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          lineBytes.addAll(line.codeUnits);
          lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
          lineBytes.addAll([0x1B, 0x61, 0x00]); // Left align
        } else if (line.contains('TOTAL:')) {
          // Bold for total
          lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          lineBytes.addAll(line.codeUnits);
          lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
        } else if (line.contains('Thank you')) {
          // Center for thank you
          lineBytes.addAll([0x1B, 0x61, 0x01]); // Center
          lineBytes.addAll(line.codeUnits);
          lineBytes.addAll([0x1B, 0x61, 0x00]); // Left align
        } else {
          // Regular line
          lineBytes.addAll(line.codeUnits);
        }

        lineBytes.addAll([0x0A]); // Line feed

        // Send line in chunks if necessary
        if (lineBytes.length > _bluetoothChunkSize) {
          await _sendLongLineInChunks(printer, lineBytes);
        } else {
          await _sendBluetoothChunk(printer, Uint8List.fromList(lineBytes));
        }

        // Delay between lines for Bluetooth processing
        await Future.delayed(Duration(milliseconds: _bluetoothLineDelay));

        // Progress logging every 5 lines
        if ((i + 1) % 5 == 0) {
          debugPrint('Sent ${i + 1}/${lines.length} lines');
        }
      }

      // Send cut command
      await Future.delayed(Duration(milliseconds: _bluetoothLineDelay * 2));
      List<int> cutBytes = [0x1D, 0x56, 0x00]; // GS V 0
      await _sendBluetoothChunk(printer, Uint8List.fromList(cutBytes));

      debugPrint('All lines sent successfully via Bluetooth');
    } catch (e) {
      debugPrint('Bluetooth chunked sending failed: $e');
      throw e;
    }
  }

  Future<void> _sendLongLineInChunks(
      Printer printer, List<int> lineBytes) async {
    for (int i = 0; i < lineBytes.length; i += _bluetoothChunkSize) {
      final end = (i + _bluetoothChunkSize < lineBytes.length)
          ? i + _bluetoothChunkSize
          : lineBytes.length;

      final chunk = lineBytes.sublist(i, end);
      await _sendBluetoothChunk(printer, Uint8List.fromList(chunk));

      // Small delay between chunks
      if (end < lineBytes.length) {
        await Future.delayed(Duration(milliseconds: _bluetoothChunkDelay));
      }
    }
  }

  Future<void> _sendBluetoothChunk(Printer printer, Uint8List data) async {
    try {
      await _flutterThermalPrinter.printData(printer, data);
    } catch (e) {
      debugPrint('Bluetooth chunk send error: $e');
      // Retry once after a brief delay
      await Future.delayed(Duration(milliseconds: 200));
      await _flutterThermalPrinter.printData(printer, data);
    }
  }

  // Helper method to center text
  String _centerText(String text, int lineWidth) {
    if (text.length >= lineWidth) return text;
    final padding = (lineWidth - text.length) ~/ 2;
    return ' ' * padding + text;
  }

  // Helper method to create padded line
  String _padLine(String char, int length) {
    return char * length;
  }

  Future<void> printReceipt({
    required ThermalPrinter printer,
    required dynamic sale,
    required BuildContext context,
  }) async {
    try {
      debugPrint(
          'Starting thermal print process for: ${printer.name} (${printer.connectionDisplayName})');
      debugPrint('Sale data type: ${sale.runtimeType}');

      // Convert to flutter_thermal_printer's Printer model
      final thermalPrinter = printer.toPrinter();

      // Different connection strategies for USB vs Bluetooth
      if (printer.isUSBPrinter) {
        await _printViaUSB(thermalPrinter, sale, printer);
      } else {
        // Use optimized Bluetooth printing
        await _printViaBluetooth(thermalPrinter, sale, printer);
      }

      debugPrint('Receipt printing process completed');
    } catch (e) {
      debugPrint('Thermal print error: $e');
      throw Exception('Failed to print receipt: $e');
    }
  }

  Future<void> _printViaUSB(
      Printer thermalPrinter, dynamic sale, ThermalPrinter printer) async {
    try {
      debugPrint('Printing via USB...');

      // USB connection is typically faster and more reliable
      debugPrint('Connecting to USB printer...');
      await _flutterThermalPrinter.connect(thermalPrinter);

      // Shorter wait time for USB
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('Connected to USB printer');

      // For USB, we can use more detailed receipt format since bandwidth is higher
      await _printDetailedReceipt(thermalPrinter, sale);
    } catch (e) {
      debugPrint('USB printing error: $e');
      throw e;
    }
  }

  Future<void> _printDetailedReceipt(Printer printer, dynamic sale) async {
    try {
      debugPrint('Generating detailed USB receipt format...');

      // Extract sale data
      String total = '0.00';
      String receiptId = 'RECEIPT';
      String date = DateTime.now().toString().substring(0, 19);
      String cashier = 'CASHIER';
      String paymentMethod = 'CASH';
      List<Map<String, dynamic>> items = [];

      if (sale is SaleModel) {
        total = sale.totalAmount.toStringAsFixed(2);
        receiptId = sale.id.length > 8
            ? sale.id.substring(0, 8).toUpperCase()
            : sale.id.toUpperCase();
        date = _formatDate(sale.createdAt);
        cashier = sale.cashierId.length > 8
            ? sale.cashierId.substring(0, 8)
            : sale.cashierId;
        paymentMethod =
            sale.paymentMethod.toString().split('.').last.replaceAll('_', ' ');

        debugPrint(
            'Processing ${sale.saleItems.length} items for detailed receipt');

        // Process each item with full details
        for (int i = 0; i < sale.saleItems.length; i++) {
          final item = sale.saleItems[i];

          try {
            String itemName = item.product.name;
            double itemPrice = 0.0;
            double unitPrice = 0.0;
            String itemQty = '1 pc';
            String itemType = 'Unknown';

            // Detailed price calculation for USB (more bandwidth available)
            if (item.isDiscounted && item.discountedPrice != null) {
              itemPrice = item.discountedPrice!;

              unitPrice = itemPrice;
              itemType = 'DISCOUNTED';
            } else if (item.sackPriceId != null &&
                item.product.sackPrice.isNotEmpty) {
              final sackPrice = item.product.sackPrice.firstWhere(
                (sp) => sp.id == item.sackPriceId,
                orElse: () => item.product.sackPrice.first,
              );
              unitPrice = sackPrice.price;
              itemPrice = sackPrice.price * item.quantity;
              final qty = item.quantity.toInt();

              // Detailed sack type display
              switch (sackPrice.type.toString().split('.').last) {
                case 'FIFTY_KG':
                  itemQty = '$qty x 50kg sack';
                  itemType = '50KG SACK';
                  break;
                case 'TWENTY_FIVE_KG':
                  itemQty = '$qty x 25kg sack';
                  itemType = '25KG SACK';
                  break;
                case 'FIVE_KG':
                  itemQty = '$qty x 5kg sack';
                  itemType = '5KG SACK';
                  break;
                default:
                  itemQty = '$qty sack';
                  itemType = 'SACK';
              }

              if (item.isSpecialPrice) {
                itemType += ' (SPECIAL)';
              }
            } else if (item.perKiloPriceId != null &&
                item.product.perKiloPrice != null) {
              unitPrice = item.product.perKiloPrice!.price;
              itemPrice = item.product.perKiloPrice!.price * item.quantity;
              itemQty = '${item.quantity.toStringAsFixed(2)}kg';
              itemType = 'PER KILO';

              if (item.isGantang) {
                itemType += ' (GANTANG)';
              }
            }

            items.add({
              'name': itemName,
              'quantity': itemQty,
              'unitPrice': unitPrice,
              'totalPrice': itemPrice,
              'type': itemType,
              'isDiscounted': item.isDiscounted,
              'isSpecial': item.isSpecialPrice,
              'isGantang': item.isGantang,
            });

            debugPrint(
                'Added detailed item: $itemName - $itemQty - Unit: P${unitPrice.toStringAsFixed(2)} - Total: P${itemPrice.toStringAsFixed(2)}');
          } catch (e) {
            debugPrint('Error processing item ${i + 1}: $e');
            items.add({
              'name': item.product.name,
              'quantity': '1 pc',
              'unitPrice': 0.0,
              'totalPrice': 0.0,
              'type': 'ERROR',
              'isDiscounted': false,
              'isSpecial': false,
              'isGantang': false,
            });
          }
        }
      }

      // Create detailed receipt with better formatting for USB
      final List<int> receiptBytes = [];

      // Initialize
      receiptBytes.addAll([0x1B, 0x40]); // ESC @

      // Center align and header
      receiptBytes.addAll([0x1B, 0x61, 0x01]); // ESC a 1
      receiptBytes.addAll([0x1B, 0x45, 0x01]); // ESC E 1 (Bold on)
      receiptBytes
          .addAll([0x1D, 0x21, 0x11]); // GS ! 0x11 (Double height & width)
      receiptBytes.addAll('FALSISTERS\n'.codeUnits);
      receiptBytes.addAll([0x1D, 0x21, 0x00]); // GS ! 0x00 (Normal size)
      receiptBytes.addAll('RICE TRADING\n'.codeUnits);
      receiptBytes.addAll([0x1B, 0x45, 0x00]); // ESC E 0 (Bold off)

      receiptBytes.addAll('--------------------------------\n'.codeUnits);

      // Receipt details
      receiptBytes.addAll([0x1B, 0x61, 0x00]); // ESC a 0 (Left align)
      receiptBytes.addAll('Receipt #: $receiptId\n'.codeUnits);
      receiptBytes.addAll('Date: $date\n'.codeUnits);
      receiptBytes.addAll('Cashier: $cashier\n'.codeUnits);
      receiptBytes.addAll('Payment: $paymentMethod\n'.codeUnits);
      receiptBytes.addAll('--------------------------------\n'.codeUnits);

      // Items with detailed formatting
      double itemTotal = 0.0;
      for (int i = 0; i < items.length; i++) {
        final item = items[i];

        // Item name
        receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
        receiptBytes.addAll('${i + 1}. ${item['name']}\n'.codeUnits);
        receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off

        // Item details
        receiptBytes.addAll('   Type: ${item['type']}\n'.codeUnits);
        receiptBytes.addAll('   Qty: ${item['quantity']}\n'.codeUnits);
        receiptBytes.addAll(
            '   Unit: P${item['unitPrice'].toStringAsFixed(2)}\n'.codeUnits);
        receiptBytes.addAll(
            '   Total: P${item['totalPrice'].toStringAsFixed(2)}\n'.codeUnits);

        // Special indicators
        if (item['isDiscounted']) {
          receiptBytes.addAll('   ** DISCOUNTED **\n'.codeUnits);
        }
        if (item['isSpecial']) {
          receiptBytes.addAll('   ** SPECIAL PRICE **\n'.codeUnits);
        }
        if (item['isGantang']) {
          receiptBytes.addAll('   ** GANTANG **\n'.codeUnits);
        }

        receiptBytes.addAll('\n'.codeUnits);
        itemTotal += item['totalPrice'];
      }

      receiptBytes.addAll('--------------------------------\n'.codeUnits);

      // Summary
      receiptBytes.addAll('Items: ${items.length}\n'.codeUnits);
      receiptBytes
          .addAll('Subtotal: P${itemTotal.toStringAsFixed(2)}\n'.codeUnits);

      // Grand total
      receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
      receiptBytes.addAll([0x1D, 0x21, 0x11]); // Double size
      receiptBytes.addAll('TOTAL: P$total\n'.codeUnits);
      receiptBytes.addAll([0x1D, 0x21, 0x00]); // Normal size
      receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off

      receiptBytes.addAll('--------------------------------\n'.codeUnits);

      // Footer
      receiptBytes.addAll([0x1B, 0x61, 0x01]); // Center align
      receiptBytes.addAll('Thank you for your business!\n'.codeUnits);
      receiptBytes.addAll('Please come again\n'.codeUnits);
      receiptBytes.addAll('\n\n\n'.codeUnits);

      // Cut
      receiptBytes.addAll([0x1D, 0x56, 0x00]); // GS V 0

      debugPrint(
          'Generated ${receiptBytes.length} bytes for detailed USB receipt');

      // Print the detailed receipt
      await _flutterThermalPrinter.printData(
        printer,
        Uint8List.fromList(receiptBytes),
      );

      debugPrint('Detailed USB receipt sent successfully');
    } catch (e) {
      debugPrint('Detailed receipt generation failed: $e');
      throw Exception('Failed to generate detailed receipt: $e');
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
      debugPrint(
          'Starting test print for: ${printer.name} (${printer.connectionDisplayName})');

      final thermalPrinter = printer.toPrinter();

      // Connect
      await _flutterThermalPrinter.connect(thermalPrinter);

      // Different wait times for different connection types
      if (printer.isUSBPrinter) {
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      // Generate test data
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
      testBytes
          .addAll('Connection: ${printer.connectionDisplayName}\n'.codeUnits);
      testBytes.addAll('Address: ${printer.address}\n'.codeUnits);

      if (printer.isUSBPrinter) {
        testBytes
            .addAll('USB VID: ${printer.usbVendorId ?? 'N/A'}\n'.codeUnits);
        testBytes
            .addAll('USB PID: ${printer.usbProductId ?? 'N/A'}\n'.codeUnits);
      }

      testBytes.addAll(
          'Time: ${DateTime.now().toString().substring(0, 19)}\n'.codeUnits);
      testBytes.addAll('\n'.codeUnits);
      testBytes.addAll('If you can see this,\n'.codeUnits);
      testBytes.addAll(
          '${printer.connectionDisplayName} printing works!\n'.codeUnits);
      testBytes.addAll('\n\n'.codeUnits);

      // Cut
      testBytes.addAll([0x1D, 0x56, 0x00]); // GS V 0

      debugPrint(
          'Sending ${testBytes.length} test bytes via ${printer.connectionDisplayName}');

      await _flutterThermalPrinter.printData(
        thermalPrinter,
        Uint8List.fromList(testBytes),
      );

      debugPrint('Test print completed via ${printer.connectionDisplayName}');
    } catch (e) {
      debugPrint('Test print failed: $e');
      throw Exception('Test print failed: $e');
    }
  }

  Future<void> _printWorkingReceipt(Printer printer, dynamic sale) async {
    try {
      debugPrint('Using Bluetooth optimized receipt format...');
      await _printBluetoothOptimizedReceipt(printer, sale);
    } catch (e) {
      debugPrint('Working receipt generation failed: $e');
      throw Exception('Failed to generate working receipt: $e');
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
