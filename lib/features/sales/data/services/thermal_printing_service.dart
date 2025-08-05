import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:falsisters_pos_android/features/app/data/model/printer_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';
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
      Printer thermalPrinter, dynamic sale, ThermalPrinter printer,
      {int copies = 1}) async {
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

      // Print the specified number of copies
      for (int i = 0; i < copies; i++) {
        await _printUnifiedReceipt(thermalPrinter, sale);
        if (i < copies - 1) {
          await Future.delayed(const Duration(milliseconds: 1000));
        }
      }
    } catch (e) {
      debugPrint('Bluetooth printing error: $e');
      throw e;
    }
  }

  Future<void> _printViaUSB(
      Printer thermalPrinter, dynamic sale, ThermalPrinter printer,
      {int copies = 1}) async {
    try {
      debugPrint('Printing via USB...');

      // USB connection is typically faster and more reliable
      debugPrint('Connecting to USB printer...');
      await _flutterThermalPrinter.connect(thermalPrinter);

      // Shorter wait time for USB
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('Connected to USB printer');

      // Print the specified number of copies
      for (int i = 0; i < copies; i++) {
        await _printUnifiedReceipt(thermalPrinter, sale);
        if (i < copies - 1) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    } catch (e) {
      debugPrint('USB printing error: $e');
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

  Future<void> _printUnifiedReceipt(Printer printer, dynamic sale) async {
    try {
      debugPrint('Generating unified receipt format...');

      // Extract sale data
      String total = '0.00';
      String receiptId = 'RECEIPT';
      String date = DateTime.now().toString().substring(0, 19);
      String cashier = 'CASHIER';
      String paymentMethod = 'CASH';
      String changeAmount = '0.00';
      String tenderedAmount = '0.00';
      List<Map<String, dynamic>> items = [];

      if (sale is SaleModel) {
        total = sale.totalAmount.toStringAsFixed(2);
        receiptId = sale.id.length > 8
            ? sale.id.substring(0, 8).toUpperCase()
            : sale.id.toUpperCase();
        date = _formatDate(sale.createdAt);

        debugPrint('=== RECEIPT DATA EXTRACTION ===');
        debugPrint('Sale ID: ${sale.id}');
        debugPrint('Sale metadata: ${sale.metadata}');
        debugPrint('Cashier ID from sale: ${sale.cashierId}');

        // Get cashier name from metadata first, then fallback to cashierId
        if (sale.metadata != null &&
            sale.metadata!.containsKey('cashierName')) {
          cashier = sale.metadata!['cashierName'].toString();
          debugPrint('Using cashier name from metadata: $cashier');
        } else {
          // Fallback to cashier ID if name not available
          cashier = sale.cashierId.length > 8
              ? sale.cashierId.substring(0, 8)
              : sale.cashierId;
          debugPrint('Using cashier ID as fallback: $cashier');
        }

        paymentMethod =
            sale.paymentMethod.toString().split('.').last.replaceAll('_', ' ');

        // Get change amount and tendered amount from sale metadata
        if (sale.metadata != null && sale.metadata!.containsKey('change')) {
          changeAmount = sale.metadata!['change'].toString();
          debugPrint('Found change amount in metadata: $changeAmount');
        } else {
          debugPrint('No change amount found in metadata');
        }

        if (sale.metadata != null &&
            sale.metadata!.containsKey('tenderedAmount')) {
          tenderedAmount = sale.metadata!['tenderedAmount'].toString();
          debugPrint('Found tendered amount in metadata: $tenderedAmount');
        } else {
          debugPrint('No tendered amount found in metadata');
        }

        debugPrint(
            'Processing ${sale.saleItems.length} items for unified receipt');

        // Process each item with full details
        for (int i = 0; i < sale.saleItems.length; i++) {
          final item = sale.saleItems[i];

          try {
            String itemName = item.product.name;
            Decimal itemPrice = Decimal.zero;
            Decimal unitPrice = Decimal.zero;
            String itemQty = '1 pc'; // Default value

            // Determine quantity string first, regardless of discount status.
            if (item.sackPriceId != null && item.product.sackPrice.isNotEmpty) {
              final sackPrice = item.product.sackPrice.firstWhere(
                (sp) => sp.id == item.sackPriceId,
                orElse: () => item.product.sackPrice.first,
              );
              final qty = item.quantity.toBigInt().toInt();
              switch (sackPrice.type.toString().split('.').last) {
                case 'FIFTY_KG':
                  itemQty = '$qty x 50kg sack';
                  break;
                case 'TWENTY_FIVE_KG':
                  itemQty = '$qty x 25kg sack';
                  break;
                case 'FIVE_KG':
                  itemQty = '$qty x 5kg sack';
                  break;
                default:
                  itemQty = '$qty sack';
              }
            } else if (item.perKiloPriceId != null &&
                item.product.perKiloPrice != null) {
              itemQty = '${item.quantity.toStringAsFixed(2)}kg';
              if (item.isGantang) {
                itemQty += ' (GANTANG)';
              }
            }

            // Detailed price calculation
            if (item.isDiscounted && item.discountedPrice != null) {
              unitPrice = item.discountedPrice!;
              itemPrice = unitPrice * item.quantity;
            } else if (item.sackPriceId != null &&
                item.product.sackPrice.isNotEmpty) {
              final sackPrice = item.product.sackPrice.firstWhere(
                (sp) => sp.id == item.sackPriceId,
                orElse: () => item.product.sackPrice.first,
              );
              unitPrice = sackPrice.price;
              itemPrice = unitPrice * item.quantity;
            } else if (item.perKiloPriceId != null &&
                item.product.perKiloPrice != null) {
              unitPrice = item.product.perKiloPrice!.price;
              itemPrice = unitPrice * item.quantity;
            }

            items.add({
              'name': itemName,
              'quantity': itemQty,
              'unitPrice': unitPrice.toDouble(),
              'totalPrice': itemPrice.toDouble(),
              'isDiscounted': item.isDiscounted,
              'isSpecial': item.isSpecialPrice,
              'isGantang': item.isGantang,
            });

            debugPrint(
                'Added item: $itemName - $itemQty - Unit: P${unitPrice.toStringAsFixed(2)} - Total: P${itemPrice.toStringAsFixed(2)}');
          } catch (e) {
            debugPrint('Error processing item ${i + 1}: $e');
            items.add({
              'name': item.product.name,
              'quantity': '1 pc',
              'unitPrice': 0.0,
              'totalPrice': 0.0,
              'isDiscounted': false,
              'isSpecial': false,
              'isGantang': false,
            });
          }
        }
      }

      // Create receipt lines for printing
      final List<String> receiptLines = [];

      // Store header (no copy type indicator)
      receiptLines.add('');
      receiptLines.add(_centerText('FALSISTERS', 32));
      receiptLines.add(_centerText('RICE TRADING', 32));
      receiptLines.add(_padLine('-', 32));

      // Receipt info
      receiptLines.add('Receipt #: $receiptId');
      receiptLines.add('Date: $date');
      receiptLines.add('Cashier: $cashier');
      receiptLines.add('Payment: $paymentMethod');
      receiptLines.add(_padLine('-', 32));

      // Items
      double subtotal = 0.0;
      for (int i = 0; i < items.length; i++) {
        final item = items[i];

        // Item number and name
        receiptLines.add('${i + 1}. ${item['name']}');
        receiptLines.add('Qty: ${item['quantity']}');
        receiptLines.add('Unit: P${item['unitPrice'].toStringAsFixed(2)}');
        receiptLines.add('Total: P${item['totalPrice'].toStringAsFixed(2)}');

        // Special indicators
        if (item['isDiscounted']) {
          receiptLines.add('** DISCOUNTED **');
        }
        if (item['isSpecial']) {
          receiptLines.add('** SPECIAL PRICE **');
        }

        receiptLines.add('');
        subtotal += item['totalPrice'];
      }

      receiptLines.add(_padLine('-', 32));

      // Summary
      receiptLines.add('Items: ${items.length}');
      receiptLines.add('Subtotal: P${subtotal.toStringAsFixed(2)}');

      // Add cash tendered and change if it's a cash payment with change
      final hasChange = changeAmount != '0.00' &&
          double.tryParse(changeAmount) != null &&
          double.parse(changeAmount) > 0;

      debugPrint('=== CHANGE DISPLAY CHECK ===');
      debugPrint('Payment method: $paymentMethod');
      debugPrint('Change amount string: "$changeAmount"');
      debugPrint('Has change: $hasChange');
      debugPrint('Tendered amount: "$tenderedAmount"');

      if (paymentMethod == 'CASH' && hasChange) {
        receiptLines.add('Cash Tendered: P$tenderedAmount');
        receiptLines.add('Change: P$changeAmount');
        debugPrint('Added change lines to receipt');
      } else {
        debugPrint(
            'Change lines NOT added - Payment: $paymentMethod, HasChange: $hasChange');
      }

      receiptLines.add('TOTAL: P$total');
      receiptLines.add(_padLine('-', 32));

      // Footer
      receiptLines.add(_centerText('Thank you and come again', 32));
      receiptLines.add('');
      receiptLines.add('');

      debugPrint('Generated ${receiptLines.length} lines for unified receipt');

      // Send receipt using chunked approach for both USB and Bluetooth
      if (printer.connectionType == ConnectionType.BLE) {
        await _sendBluetoothChunkedUnifiedReceipt(printer, receiptLines);
      } else {
        await _sendUSBUnifiedReceipt(printer, receiptLines);
      }

      debugPrint('Unified receipt sent successfully');
    } catch (e) {
      debugPrint('Unified receipt generation failed: $e');
      throw Exception('Failed to generate unified receipt: $e');
    }
  }

  Future<void> _sendBluetoothChunkedUnifiedReceipt(
      Printer printer, List<String> lines) async {
    try {
      debugPrint('Sending ${lines.length} lines via Bluetooth chunks...');

      // Initialize printer
      List<int> initBytes = [0x1B, 0x40]; // ESC @
      await _sendBluetoothChunk(printer, Uint8List.fromList(initBytes));
      await Future.delayed(Duration(milliseconds: _bluetoothLineDelay));

      // Send each line with proper formatting
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        List<int> lineBytes = [];

        if (line.contains("COPY")) {
          // Bold and center for copy type
          lineBytes.addAll([0x1B, 0x61, 0x01]); // Center
          lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          lineBytes.addAll(line.codeUnits);
          lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
          lineBytes.addAll([0x1B, 0x61, 0x00]); // Left align
        } else if (line.contains('FALSISTERS')) {
          // Bold and center for header - REMOVED double size to prevent overflow
          lineBytes.addAll([0x1B, 0x61, 0x01]); // Center
          lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          lineBytes.addAll(line.codeUnits);
          lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
          lineBytes.addAll([0x1B, 0x61, 0x00]); // Left align
        } else if (line.contains('RICE TRADING')) {
          // Bold and center for subtitle
          lineBytes.addAll([0x1B, 0x61, 0x01]); // Center
          lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          lineBytes.addAll(line.codeUnits);
          lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
          lineBytes.addAll([0x1B, 0x61, 0x00]); // Left align
        } else if (line.contains('TOTAL: P')) {
          // Bold and double size for total
          lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          lineBytes.addAll([0x1D, 0x21, 0x11]); // Double height & width
          lineBytes.addAll(line.codeUnits);
          lineBytes.addAll([0x1D, 0x21, 0x00]); // Normal size
          lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
        } else if (line.contains('Thank you')) {
          // Center for thank you
          lineBytes.addAll([0x1B, 0x61, 0x01]); // Center
          lineBytes.addAll(line.codeUnits);
          lineBytes.addAll([0x1B, 0x61, 0x00]); // Left align
        } else if (line.startsWith('Receipt #') ||
            line.startsWith('Date:') ||
            line.startsWith('Cashier:') ||
            line.startsWith('Payment:')) {
          // Bold for receipt info
          lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          lineBytes.addAll(line.codeUnits);
          lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
        } else if (RegExp(r'^\d+\.').hasMatch(line)) {
          // Bold for item numbers
          lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          lineBytes.addAll(line.codeUnits);
          lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
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
      debugPrint('Bluetooth unified receipt sending failed: $e');
      throw e;
    }
  }

  Future<void> _sendUSBUnifiedReceipt(
      Printer printer, List<String> lines) async {
    try {
      debugPrint('Sending unified receipt via USB...');

      final List<int> receiptBytes = [];

      // Initialize
      receiptBytes.addAll([0x1B, 0x40]); // ESC @

      // Process each line with formatting
      for (final line in lines) {
        if (line.contains("COPY")) {
          // Bold and center for copy type
          receiptBytes.addAll([0x1B, 0x61, 0x01]); // Center
          receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          receiptBytes.addAll(line.codeUnits);
          receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
          receiptBytes.addAll([0x1B, 0x61, 0x00]); // Left align
        } else if (line.contains('FALSISTERS')) {
          // Bold and center for header - REMOVED double size to prevent overflow
          receiptBytes.addAll([0x1B, 0x61, 0x01]); // Center
          receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          receiptBytes.addAll(line.codeUnits);
          receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
          receiptBytes.addAll([0x1B, 0x61, 0x00]); // Left align
        } else if (line.contains('RICE TRADING')) {
          // Bold and center for subtitle
          receiptBytes.addAll([0x1B, 0x61, 0x01]); // Center
          receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          receiptBytes.addAll(line.codeUnits);
          receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
          receiptBytes.addAll([0x1B, 0x61, 0x00]); // Left align
        } else if (line.contains('TOTAL: P')) {
          // Bold and double size for total
          receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          receiptBytes.addAll([0x1D, 0x21, 0x11]); // Double height & width
          receiptBytes.addAll(line.codeUnits);
          receiptBytes.addAll([0x1D, 0x21, 0x00]); // Normal size
          receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
        } else if (line.contains('Thank you')) {
          // Center for thank you
          receiptBytes.addAll([0x1B, 0x61, 0x01]); // Center
          receiptBytes.addAll(line.codeUnits);
          receiptBytes.addAll([0x1B, 0x61, 0x00]); // Left align
        } else if (line.startsWith('Receipt #') ||
            line.startsWith('Date:') ||
            line.startsWith('Cashier:') ||
            line.startsWith('Payment:')) {
          // Bold for receipt info
          receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          receiptBytes.addAll(line.codeUnits);
          receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
        } else if (RegExp(r'^\d+\.').hasMatch(line)) {
          // Bold for item numbers
          receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
          receiptBytes.addAll(line.codeUnits);
          receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
        } else {
          // Regular line
          receiptBytes.addAll(line.codeUnits);
        }

        receiptBytes.addAll([0x0A]); // Line feed
      }

      // Cut
      receiptBytes.addAll([0x1D, 0x56, 0x00]); // GS V 0

      debugPrint(
          'Generated ${receiptBytes.length} bytes for unified USB receipt');

      // Print the unified receipt
      await _flutterThermalPrinter.printData(
        printer,
        Uint8List.fromList(receiptBytes),
      );

      debugPrint('Unified USB receipt sent successfully');
    } catch (e) {
      debugPrint('USB unified receipt generation failed: $e');
      throw Exception('Failed to generate USB unified receipt: $e');
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
    int copies = 1,
  }) async {
    try {
      debugPrint(
          'Starting thermal print process for: ${printer.name} (${printer.connectionDisplayName})');
      debugPrint('Sale data type: ${sale.runtimeType}');
      debugPrint('Number of copies: $copies');

      // Convert to flutter_thermal_printer's Printer model
      final thermalPrinter = printer.toPrinter();

      // Different connection strategies for USB vs Bluetooth
      if (printer.isUSBPrinter) {
        await _printViaUSB(thermalPrinter, sale, printer, copies: copies);
      } else {
        // Use optimized Bluetooth printing
        await _printViaBluetooth(thermalPrinter, sale, printer, copies: copies);
      }

      debugPrint('Receipt printing process completed');
    } catch (e) {
      debugPrint('Thermal print error: $e');
      throw Exception('Failed to print receipt: $e');
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
