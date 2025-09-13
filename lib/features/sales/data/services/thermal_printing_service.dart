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

  // Updated constants for 57mm paper
  static const int _bluetoothChunkSize = 20; // Bytes per chunk for Bluetooth
  static const int _bluetoothLineDelay = 100; // ms between lines
  static const int _bluetoothChunkDelay = 50; // ms between chunks
  static const String _sectionSpacing = ''; // Reduce to single line spacing

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

      // Print the specified number of copies with partial cuts
      for (int i = 0; i < copies; i++) {
        await _printUnifiedReceipt(thermalPrinter, sale);
        if (i < copies - 1) {
          await Future.delayed(const Duration(milliseconds: 1000));
        }
      }
    } catch (e) {
      debugPrint('Bluetooth printing error: $e');
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

      // Print the specified number of copies with partial cuts
      for (int i = 0; i < copies; i++) {
        await _printUnifiedReceipt(thermalPrinter, sale);
        if (i < copies - 1) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    } catch (e) {
      debugPrint('USB printing error: $e');
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
      debugPrint('Generating unified receipt format for 57mm paper...');

      // Extract sale data
      String total = '0.00';
      String receiptId = 'RECEIPT';
      String dateTime = DateTime.now().toString().substring(0, 19);
      String cashier = 'CASHIER';

      String changeAmount = '0.00';
      String tenderedAmount = '0.00';
      List<Map<String, dynamic>> items = [];

      if (sale is SaleModel) {
        total = sale.totalAmount.toStringAsFixed(0); // Remove decimals for 57mm
        // Use last 8 characters of sale ID as specified
        receiptId = sale.id.length > 8
            ? sale.id.substring(sale.id.length - 8)
            : sale.id;
        dateTime = _formatDateTimeFor57mm(sale.createdAt);

        debugPrint('=== 57MM RECEIPT DATA EXTRACTION ===');
        debugPrint('Sale ID (last 8): $receiptId');
        debugPrint('Sale date and time: $dateTime');
        debugPrint('Sale metadata: ${sale.metadata}');

        // Get cashier name from metadata first, then fallback to cashierId
        if (sale.metadata != null &&
            sale.metadata!.containsKey('cashierName')) {
          cashier = sale.metadata!['cashierName'].toString();
          debugPrint('Using cashier name from metadata: $cashier');
        } else {
          // Fallback to cashier ID if name not available
          cashier = sale.cashierId.length > 12
              ? sale.cashierId.substring(0, 12)
              : sale.cashierId;
          debugPrint('Using cashier ID as fallback: $cashier');
        }

        // Get change amount and tendered amount from sale metadata
        if (sale.metadata != null && sale.metadata!.containsKey('change')) {
          changeAmount = double.parse(sale.metadata!['change'].toString())
              .toStringAsFixed(0);
          debugPrint('Found change amount in metadata: $changeAmount');
        } else {
          debugPrint('No change amount found in metadata');
        }

        if (sale.metadata != null &&
            sale.metadata!.containsKey('tenderedAmount')) {
          tenderedAmount =
              double.parse(sale.metadata!['tenderedAmount'].toString())
                  .toStringAsFixed(0);
          debugPrint('Found tendered amount in metadata: $tenderedAmount');
        } else {
          debugPrint('No tendered amount found in metadata');
        }

        debugPrint(
            'Processing ${sale.saleItems.length} items for 57mm receipt');

        // Process each item with new 57mm formatting requirements
        for (int i = 0; i < sale.saleItems.length; i++) {
          final item = sale.saleItems[i];

          try {
            debugPrint('=== PROCESSING SALE ITEM ${i + 1} ===');
            debugPrint('Product ID: ${item.productId}');
            debugPrint('Product name: ${item.product.name}');
            debugPrint('Item price field: ${item.price?.toString() ?? "NULL"}');
            debugPrint(
                'Item discountedPrice field: ${item.discountedPrice?.toString() ?? "NULL"}');
            debugPrint('Item quantity: ${item.quantity}');
            debugPrint('Is discounted: ${item.isDiscounted}');
            debugPrint('Is gantang: ${item.isGantang}');
            debugPrint('SackPriceId: ${item.sackPriceId ?? "NULL"}');
            debugPrint('PerKiloPriceId: ${item.perKiloPriceId ?? "NULL"}');

            String itemName = item.product.name;
            Decimal itemPrice = Decimal.zero;
            Decimal unitPrice = Decimal.zero;
            String itemQty = '1';
            String variant = '';
            bool isDiscounted = item.isDiscounted;

            // Format item name and quantity based on type
            if (item.sackPriceId != null && item.product.sackPrice.isNotEmpty) {
              final sackPrice = item.product.sackPrice.firstWhere(
                (sp) => sp.id == item.sackPriceId,
                orElse: () => item.product.sackPrice.first,
              );
              final qty = item.quantity.toBigInt().toInt();

              // Set variant for sack types
              switch (sackPrice.type.toString().split('.').last) {
                case 'FIFTY_KG':
                  variant = 'x 50KG';
                  break;
                case 'TWENTY_FIVE_KG':
                  variant = 'x 25KG';
                  break;
                case 'FIVE_KG':
                  variant = 'x 5KG';
                  break;
                default:
                  variant = 'x SACK';
              }
              itemQty = qty.toString();
            } else if ((item.perKiloPriceId != null &&
                    item.product.perKiloPrice != null) ||
                item.quantity != item.quantity.truncate()) {
              // For per kilo items OR any items with decimal quantities, show as KG
              itemQty = item.quantity.toStringAsFixed(2);
              variant = item.isGantang ? 'gantang' : 'KG';
            } else {
              // For whole number quantities without specific sack or per-kilo pricing
              // Still format the quantity properly instead of defaulting to '1'
              itemQty = item.quantity.toStringAsFixed(2);
              // If quantity has no decimal part, format as whole number
              if (item.quantity == item.quantity.truncate()) {
                itemQty = item.quantity.toBigInt().toString();
                variant = 'pcs';
              } else {
                variant = 'KG'; // Decimal quantities are treated as KG
              }
            }

            // Use the final price from SaleItem.price field
            if (item.price != null) {
              // The item.price field contains the total price for this item
              itemPrice = item.price!;
              // Calculate unit price by dividing total by quantity
              if (item.quantity > Decimal.zero) {
                unitPrice = (itemPrice / item.quantity)
                    .toDecimal(scaleOnInfinitePrecision: 4);
              } else {
                unitPrice = itemPrice;
              }
              debugPrint('Using item.price field: ${item.price}');
              debugPrint('Calculated itemPrice: $itemPrice');
              debugPrint('Calculated unitPrice: $unitPrice');
            } else {
              // Fallback to complex calculation if price is not set
              debugPrint('Item.price is NULL, using fallback calculation');
              if (isDiscounted && item.discountedPrice != null) {
                unitPrice = item.discountedPrice!;
                itemPrice = unitPrice * item.quantity;
                debugPrint(
                    'Using discountedPrice fallback: unitPrice=$unitPrice, itemPrice=$itemPrice');
              } else if (item.sackPriceId != null &&
                  item.product.sackPrice.isNotEmpty) {
                final sackPrice = item.product.sackPrice.firstWhere(
                  (sp) => sp.id == item.sackPriceId,
                  orElse: () => item.product.sackPrice.first,
                );
                unitPrice = Decimal.parse(sackPrice.price.toString());
                itemPrice = unitPrice * item.quantity;
                debugPrint(
                    'Using sackPrice fallback: unitPrice=$unitPrice, itemPrice=$itemPrice');
              } else if (item.perKiloPriceId != null &&
                  item.product.perKiloPrice != null) {
                unitPrice =
                    Decimal.parse(item.product.perKiloPrice!.price.toString());
                itemPrice = unitPrice * item.quantity;
                debugPrint(
                    'Using perKiloPrice fallback: unitPrice=$unitPrice, itemPrice=$itemPrice');
              } else {
                debugPrint(
                    'No fallback calculation available, prices remain zero');
              }
            }

            items.add({
              'name': itemName,
              'quantity': itemQty,
              'variant': variant,
              'unitPrice': unitPrice.toDouble(),
              'totalPrice': itemPrice.toDouble(),
              'isDiscounted': isDiscounted,
              'isSpecial': item.isSpecialPrice,
              'isGantang': item.isGantang,
            });

            debugPrint(
                'Added item: $itemName - Qty: $itemQty $variant - Total: PHP ${itemPrice.toStringAsFixed(0)}');
          } catch (e) {
            debugPrint('Error processing item ${i + 1}: $e');
            // Even in error cases, use the actual quantity from the item
            String fallbackQty = item.quantity.toStringAsFixed(2);
            String fallbackVariant = '';

            // Format fallback quantity properly
            if (item.quantity == item.quantity.truncate()) {
              // Whole number - show without decimals
              fallbackQty = item.quantity.toBigInt().toString();
              fallbackVariant = 'pcs';
            } else {
              // Decimal quantity - show as KG
              fallbackVariant = item.isGantang ? 'gantang' : 'KG';
            }

            items.add({
              'name': item.product.name,
              'quantity': fallbackQty,
              'variant': fallbackVariant,
              'unitPrice': 0.0,
              'totalPrice': 0.0,
              'isDiscounted': false,
              'isSpecial': false,
              'isGantang': false,
            });
          }
        }
      }

      // Create receipt lines for 57mm paper format with reduced spacing
      final List<Map<String, dynamic>> receiptLines = [];

      // Store header - Falsisters (bigger font)
      receiptLines.add({'text': '', 'format': 'normal'});
      receiptLines
          .add({'text': _centerText('Falsisters', 32), 'format': 'big_header'});
      receiptLines.add(
          {'text': _centerText('Rice Trading', 32), 'format': 'small_header'});
      receiptLines.add(
          {'text': _sectionSpacing, 'format': 'spacing'}); // Add single spacing
      receiptLines.add({'text': _padLine('-', 32), 'format': 'normal'});

      // Receipt info with minimal spacing - updated to show date and time
      receiptLines.add({'text': 'Invoice ID: $receiptId', 'format': 'info'});
      receiptLines.add({'text': 'Date & Time: $dateTime', 'format': 'info'});
      receiptLines.add({'text': 'Employee Name: $cashier', 'format': 'info'});
      receiptLines.add(
          {'text': _sectionSpacing, 'format': 'spacing'}); // Add single spacing
      receiptLines.add({'text': _padLine('-', 32), 'format': 'normal'});

      // Items with minimal spacing
      for (int i = 0; i < items.length; i++) {
        final item = items[i];

        // Item name and total price (right aligned)
        String totalPriceStr = 'PHP ${item['totalPrice'].toStringAsFixed(0)}';
        receiptLines.add({
          'text': _format57mmItemLine(item['name'], totalPriceStr, 32),
          'format': 'item_line'
        });

        // Quantity x Variant (no times sign for KG)
        String qtyVariantStr;
        if (item['variant'] == 'KG') {
          qtyVariantStr = '${item['quantity']} KG';
        } else if (item['variant'] == 'gantang') {
          qtyVariantStr = '${item['quantity']} gantang';
        } else if (item['variant'].isNotEmpty) {
          qtyVariantStr = '${item['quantity']} ${item['variant']}';
        } else {
          // For empty variant, check if quantity has decimal places
          final qtyStr = item['quantity'] as String;
          if (qtyStr.contains('.') && !qtyStr.endsWith('.00')) {
            // Has decimal places - treat as KG
            qtyVariantStr = '${item['quantity']} KG';
          } else {
            // Whole number - treat as pieces
            qtyVariantStr = '${item['quantity']} pcs';
          }
        }
        receiptLines.add({'text': qtyVariantStr, 'format': 'item_details'});

        // Price
        String priceStr = item['isDiscounted']
            ? 'PHP ${item['unitPrice'].toStringAsFixed(0)} (DISC)'
            : 'PHP ${item['unitPrice'].toStringAsFixed(0)}';
        receiptLines.add({'text': priceStr, 'format': 'item_details'});

        // Add minimal spacing between items
        if (i < items.length - 1) {
          receiptLines.add({'text': _sectionSpacing, 'format': 'spacing'});
        }
      }

      receiptLines.add(
          {'text': _sectionSpacing, 'format': 'spacing'}); // Add single spacing
      receiptLines.add({'text': _padLine('-', 32), 'format': 'normal'});

      // Totals section with minimal spacing
      receiptLines.add({
        'text': _rightAlign57mm('Total', 'PHP ${total.split('.')[0]}', 32),
        'format': 'total'
      });

      receiptLines.add({
        'text':
            _rightAlign57mm('Cash', 'PHP ${tenderedAmount.split('.')[0]}', 32),
        'format': 'body'
      });

      receiptLines.add({
        'text':
            _rightAlign57mm('Change', 'PHP ${changeAmount.split('.')[0]}', 32),
        'format': 'body'
      });
      receiptLines.add(
          {'text': _sectionSpacing, 'format': 'spacing'}); // Add single spacing

      receiptLines.add({'text': _padLine('-', 32), 'format': 'normal'});

      // Footer with minimal spacing
      receiptLines
          .add({'text': _centerText('Thank you', 32), 'format': 'footer'});
      receiptLines.add(
          {'text': _sectionSpacing, 'format': 'spacing'}); // Add single spacing

      debugPrint(
          'Generated ${receiptLines.length} lines for 57mm receipt with reduced spacing');

      // Send receipt using chunked approach for both USB and Bluetooth
      if (printer.connectionType == ConnectionType.BLE) {
        await _sendBluetoothChunked57mmReceipt(printer, receiptLines);
      } else {
        await _sendUSB57mmReceipt(printer, receiptLines);
      }

      debugPrint('57mm receipt sent successfully');
    } catch (e) {
      debugPrint('57mm receipt generation failed: $e');
      throw Exception('Failed to generate 57mm receipt: $e');
    }
  }

  // Helper method to format item lines for 57mm paper
  String _format57mmItemLine(
      String itemName, String totalPrice, int lineWidth) {
    final maxNameLength = lineWidth - totalPrice.length - 1; // -1 for space
    String truncatedName = itemName.length > maxNameLength
        ? itemName.substring(0, maxNameLength)
        : itemName;

    final spaces = lineWidth - truncatedName.length - totalPrice.length;
    return truncatedName + ' ' * spaces + totalPrice;
  }

  // Helper method to right-align for 57mm
  String _rightAlign57mm(String label, String value, int lineWidth) {
    final totalText = '$label $value';
    if (totalText.length >= lineWidth) {
      return totalText;
    }

    final spaces = lineWidth - totalText.length;
    return label + ' ' * spaces + value;
  }

  // Helper method to format date and time for 57mm
  String _formatDateTimeFor57mm(String dateString) {
    try {
      final date =
          DateTime.parse(dateString).toLocal(); // Convert to local timezone
      final dateStr =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
      final timeStr =
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      return '$dateStr $timeStr';
    } catch (e) {
      debugPrint('Date parsing error: $e');
      return dateString.substring(0, 19); // Return original if parsing fails
    }
  }

  Future<void> _sendBluetoothChunked57mmReceipt(
      Printer printer, List<Map<String, dynamic>> lines) async {
    try {
      debugPrint(
          'Sending ${lines.length} lines via Bluetooth chunks for 57mm...');

      // Initialize printer
      List<int> initBytes = [0x1B, 0x40]; // ESC @
      await _sendBluetoothChunk(printer, Uint8List.fromList(initBytes));
      await Future.delayed(Duration(milliseconds: _bluetoothLineDelay));

      // Send each line with proper formatting
      for (int i = 0; i < lines.length; i++) {
        final lineData = lines[i];
        final line = lineData['text'] as String;
        final format = lineData['format'] as String;
        List<int> lineBytes = [];

        // Handle spacing format
        if (format == 'spacing') {
          lineBytes.addAll(line.codeUnits);
        } else {
          switch (format) {
            case 'big_header':
              // Bold and slightly larger for "Falsisters" (no double width to prevent overflow)
              lineBytes.addAll([0x1B, 0x61, 0x01]); // Center
              lineBytes.addAll([0x1D, 0x21, 0x01]); // Double height only
              lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
              lineBytes.addAll(line.codeUnits);
              lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
              lineBytes.addAll([0x1D, 0x21, 0x00]); // Normal size
              lineBytes.addAll([0x1B, 0x61, 0x00]); // Left align
              break;

            case 'small_header':
              // Bold and center for "Rice Trading"
              lineBytes.addAll([0x1B, 0x61, 0x01]); // Center
              lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
              lineBytes.addAll(line.codeUnits);
              lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
              lineBytes.addAll([0x1B, 0x61, 0x00]); // Left align
              break;

            case 'info':
              // Bold for receipt info
              lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
              lineBytes.addAll(line.codeUnits);
              lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
              break;

            case 'item_line':
              // Bold for item name and total price line
              lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
              lineBytes.addAll(line.codeUnits);
              lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
              break;

            case 'item_details':
              // Regular font for details
              lineBytes.addAll(line.codeUnits);
              break;

            case 'body':
              // Regular font for body
              lineBytes.addAll(line.codeUnits);
              break;

            case 'total':
              // Bold for total
              lineBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
              lineBytes.addAll(line.codeUnits);
              lineBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
              break;

            case 'footer':
              // Center for thank you
              lineBytes.addAll([0x1B, 0x61, 0x01]); // Center
              lineBytes.addAll(line.codeUnits);
              lineBytes.addAll([0x1B, 0x61, 0x00]); // Left align
              break;

            default:
              // Regular line
              lineBytes.addAll(line.codeUnits);
          }
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

      // Send cut commands
      await Future.delayed(Duration(milliseconds: _bluetoothLineDelay * 2));

      try {
        debugPrint('Attempting partial cut command: GS V 1');
        List<int> partialCutBytes = [0x1D, 0x56, 0x01]; // GS V 1 (partial cut)
        await _sendBluetoothChunk(printer, Uint8List.fromList(partialCutBytes));
        await Future.delayed(Duration(milliseconds: 500));
      } catch (e) {
        debugPrint('Partial cut failed: $e');
      }

      debugPrint('All lines sent successfully via Bluetooth for 57mm');
    } catch (e) {
      debugPrint('Bluetooth 57mm receipt sending failed: $e');
    }
  }

  Future<void> _sendUSB57mmReceipt(
      Printer printer, List<Map<String, dynamic>> lines) async {
    try {
      debugPrint('Sending 57mm receipt via USB...');

      final List<int> receiptBytes = [];

      // Initialize
      receiptBytes.addAll([0x1B, 0x40]); // ESC @

      // Process each line with formatting
      for (final lineData in lines) {
        final line = lineData['text'] as String;
        final format = lineData['format'] as String;

        // Handle spacing format
        if (format == 'spacing') {
          receiptBytes.addAll(line.codeUnits);
        } else {
          switch (format) {
            case 'big_header':
              // Center align and bold for "Falsisters" - Fixed for USB
              receiptBytes.addAll([0x1B, 0x61, 0x01]); // Center
              receiptBytes.addAll([
                0x1D,
                0x21,
                0x01
              ]); // Double height only (not width to prevent overflow)
              receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
              receiptBytes.addAll(line.codeUnits);
              receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
              receiptBytes.addAll([0x1D, 0x21, 0x00]); // Normal size
              receiptBytes.addAll([0x1B, 0x61, 0x00]); // Left align
              break;

            case 'small_header':
              // Bold and center for "Rice Trading"
              receiptBytes.addAll([0x1B, 0x61, 0x01]); // Center
              receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
              receiptBytes.addAll(line.codeUnits);
              receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
              receiptBytes.addAll([0x1B, 0x61, 0x00]); // Left align
              break;

            case 'info':
              // Bold for receipt info
              receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
              receiptBytes.addAll(line.codeUnits);
              receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
              break;

            case 'item_line':
              // Bold for item name and total price line
              receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
              receiptBytes.addAll(line.codeUnits);
              receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
              break;

            case 'item_details':
            case 'body':
              // Regular font for details
              receiptBytes.addAll(line.codeUnits);
              break;

            case 'total':
              // Bold for total
              receiptBytes.addAll([0x1B, 0x45, 0x01]); // Bold on
              receiptBytes.addAll(line.codeUnits);
              receiptBytes.addAll([0x1B, 0x45, 0x00]); // Bold off
              break;

            case 'footer':
              // Center for thank you
              receiptBytes.addAll([0x1B, 0x61, 0x01]); // Center
              receiptBytes.addAll(line.codeUnits);
              receiptBytes.addAll([0x1B, 0x61, 0x00]); // Left align
              break;

            default:
              // Regular line
              receiptBytes.addAll(line.codeUnits);
          }
        }

        receiptBytes.addAll([0x0A]); // Line feed
      }

      // Add cut commands
      receiptBytes.addAll([0x0A, 0x0A]); // Extra line feeds
      receiptBytes.addAll([0x1D, 0x56, 0x01]); // GS V 1 (partial cut)

      debugPrint('Generated ${receiptBytes.length} bytes for 57mm USB receipt');

      // Print the unified receipt
      await _flutterThermalPrinter.printData(
        printer,
        Uint8List.fromList(receiptBytes),
      );

      debugPrint('57mm USB receipt sent successfully');
    } catch (e) {
      debugPrint('USB 57mm receipt generation failed: $e');
      throw Exception('Failed to generate USB 57mm receipt: $e');
    }
  }

  String _centerText(String text, int lineWidth) {
    if (text.length >= lineWidth) return text;
    final padding = (lineWidth - text.length) ~/ 2;
    return ' ' * padding + text;
  }

  // Helper method to create padded line for 57mm
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

      // Updated to show both date and time
      final now = DateTime.now();
      final dateTimeStr =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString().substring(2)} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      testBytes.addAll('Date & Time: $dateTimeStr\n'.codeUnits);
      testBytes.addAll('\n'.codeUnits);
      testBytes.addAll('If you can see this,\n'.codeUnits);
      testBytes.addAll(
          '${printer.connectionDisplayName} printing works!\n'.codeUnits);
      testBytes.addAll('\n\n'.codeUnits);

      // Test all cut commands
      testBytes.addAll('Testing cut commands...\n'.codeUnits);
      testBytes.addAll([0x0A, 0x0A]); // Extra line feeds

      // Try multiple cut commands
      testBytes.addAll([0x1D, 0x56, 0x01]); // GS V 1 (partial cut)
      testBytes.addAll([0x1D, 0x56, 0x00]); // GS V 0 (full cut)
      testBytes.addAll([0x1B, 0x69]); // ESC i
      testBytes.addAll([0x1B, 0x6D]); // ESC m

      debugPrint(
          'Sending ${testBytes.length} test bytes with cut commands via ${printer.connectionDisplayName}');

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

  void stopScan() {
    try {
      _devicesStreamSubscription?.cancel();
      _flutterThermalPrinter.stopScan();
      debugPrint('Stopped printer scanning');
    } catch (e) {
      debugPrint('Error stopping scan: $e');
    }
  }

  void dispose() {
    try {
      _devicesStreamSubscription?.cancel();
      _flutterThermalPrinter.stopScan();
      debugPrint('Thermal printer service disposed');
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
