// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:falsisters_pos_android/features/app/data/model/printer_model.dart';
// import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';

// class EscPrintingService {
//   PrinterBluetoothManager _printerManager = PrinterBluetoothManager();

//   Future<List<EscPrinter>> getPairedPrinters() async {
//     try {
//       debugPrint('Getting paired/bonded devices from system...');

//       // Reset the manager
//       _printerManager = PrinterBluetoothManager();

//       final List<EscPrinter> printers = [];

//       // Try to get bonded devices directly
//       try {
//         // This should get the actual bonded devices from Android system
//         final bondedDevices = await _printerManager.getBondedDevices();
//         debugPrint('Found ${bondedDevices.length} bonded devices');

//         for (var device in bondedDevices) {
//           debugPrint('Bonded device: ${device.name} - ${device.address}');
//           printers.add(EscPrinter(
//             name: device.name ?? 'Unknown Device',
//             address: device.address ?? '',
//             isBonded: true,
//             type: device.type,
//           ));
//         }

//         if (printers.isNotEmpty) {
//           debugPrint('Successfully got ${printers.length} paired printers');
//           return printers;
//         }
//       } catch (e) {
//         debugPrint('getBondedDevices failed: $e, falling back to scan...');
//       }

//       // Fallback: Use scan with shorter duration to find paired devices
//       final Completer<List<EscPrinter>> completer = Completer();
//       late StreamSubscription subscription;
//       bool hasCompleted = false;

//       subscription = _printerManager.scanResults.listen(
//         (List<PrinterBluetooth> devices) {
//           debugPrint('Scan results received: ${devices.length} devices');

//           printers.clear();
//           for (var device in devices) {
//             debugPrint(
//                 'Found device: ${device.name ?? "Unknown"} - ${device.address ?? "No Address"}');

//             // Only add devices with proper names (usually paired devices)
//             if (device.name != null && device.name!.isNotEmpty) {
//               printers.add(EscPrinter(
//                 name: device.name!,
//                 address: device.address ?? '',
//                 isBonded: true,
//                 type: device.type,
//               ));
//             }
//           }

//           if (!hasCompleted) {
//             hasCompleted = true;
//             subscription.cancel();
//             completer.complete(List.from(printers));
//           }
//         },
//         onError: (error) {
//           debugPrint('Scan error: $error');
//           if (!hasCompleted) {
//             hasCompleted = true;
//             subscription.cancel();
//             completer.complete([]);
//           }
//         },
//       );

//       // Start scan
//       debugPrint('Starting scan for paired devices...');
//       _printerManager.startScan(Duration(seconds: 3));

//       // Wait for results with timeout
//       try {
//         final result = await completer.future.timeout(
//           Duration(seconds: 5),
//           onTimeout: () {
//             debugPrint('Paired devices scan timeout');
//             subscription.cancel();
//             return List.from(printers);
//           },
//         );

//         debugPrint('Found ${result.length} paired printers');
//         return result;
//       } catch (e) {
//         debugPrint('Error in getPairedPrinters: $e');
//         subscription.cancel();
//         return [];
//       }
//     } catch (e) {
//       debugPrint('Exception in getPairedPrinters: $e');
//       return [];
//     }
//   }

//   Future<List<EscPrinter>> scanForPrinters() async {
//     try {
//       debugPrint('Scanning for all Bluetooth devices...');

//       // Reset the manager
//       _printerManager = PrinterBluetoothManager();

//       final List<EscPrinter> printers = [];
//       final Completer<List<EscPrinter>> completer = Completer();

//       late StreamSubscription subscription;
//       bool hasCompleted = false;

//       subscription = _printerManager.scanResults.listen(
//         (List<PrinterBluetooth> devices) {
//           debugPrint('Discovery scan results: ${devices.length} devices');

//           printers.clear();
//           for (var device in devices) {
//             debugPrint(
//                 'Discovered device: ${device.name ?? "Unknown"} - ${device.address ?? "No Address"}');

//             printers.add(EscPrinter(
//               name: device.name ?? 'Unknown Device',
//               address: device.address ?? '',
//               isBonded: device.name != null && device.name!.isNotEmpty,
//               type: device.type,
//             ));
//           }

//           if (!hasCompleted) {
//             hasCompleted = true;
//             subscription.cancel();
//             completer.complete(List.from(printers));
//           }
//         },
//         onError: (error) {
//           debugPrint('Discovery scan error: $error');
//           if (!hasCompleted) {
//             hasCompleted = true;
//             subscription.cancel();
//             completer.complete([]);
//           }
//         },
//       );

//       // Start discovery scan
//       debugPrint('Starting discovery scan...');
//       _printerManager.startScan(Duration(seconds: 8));

//       try {
//         final result = await completer.future.timeout(
//           Duration(seconds: 10),
//           onTimeout: () {
//             debugPrint('Discovery scan timeout');
//             subscription.cancel();
//             return List.from(printers);
//           },
//         );

//         debugPrint('Discovery completed with ${result.length} devices');
//         return result;
//       } catch (e) {
//         debugPrint('Error in scanForPrinters: $e');
//         subscription.cancel();
//         return [];
//       }
//     } catch (e) {
//       debugPrint('Exception in scanForPrinters: $e');
//       return [];
//     }
//   }

//   Future<bool> isBluetoothEnabled() async {
//     try {
//       if (!Platform.isAndroid) {
//         return false;
//       }

//       debugPrint('Checking if Bluetooth is enabled...');

//       // Try to get bonded devices to test Bluetooth
//       try {
//         _printerManager = PrinterBluetoothManager();
//         final bondedDevices = await _printerManager.getBondedDevices();
//         debugPrint(
//             'Bluetooth test: found ${bondedDevices.length} bonded devices');
//         return true;
//       } catch (e) {
//         debugPrint('Bluetooth test via bonded devices failed: $e');
//       }

//       // Fallback: Try a very short scan
//       bool bluetoothResponded = false;
//       final Completer<bool> completer = Completer();

//       late StreamSubscription subscription;
//       subscription = _printerManager.scanResults.listen(
//         (devices) {
//           debugPrint('Bluetooth test: got scan response');
//           bluetoothResponded = true;
//           if (!completer.isCompleted) {
//             subscription.cancel();
//             completer.complete(true);
//           }
//         },
//         onError: (error) {
//           debugPrint('Bluetooth test error: $error');
//           if (!completer.isCompleted) {
//             subscription.cancel();
//             completer.complete(false);
//           }
//         },
//       );

//       // Start very short test scan
//       _printerManager.startScan(Duration(milliseconds: 1000));

//       try {
//         final result = await completer.future.timeout(
//           Duration(seconds: 3),
//           onTimeout: () {
//             debugPrint('Bluetooth test timeout');
//             subscription.cancel();
//             return false;
//           },
//         );

//         debugPrint('Bluetooth enabled: $result');
//         return result;
//       } catch (e) {
//         debugPrint('Error checking Bluetooth: $e');
//         subscription.cancel();
//         return false;
//       }
//     } catch (e) {
//       debugPrint('Exception checking Bluetooth: $e');
//       return false;
//     }
//   }

//   Future<void> printReceipt({
//     required EscPrinter printer,
//     required SaleModel sale,
//   }) async {
//     try {
//       debugPrint(
//           'Starting print process for: ${printer.name} (${printer.address})');

//       // Generate receipt content
//       final profile = await CapabilityProfile.load();
//       final generator = Generator(PaperSize.mm58, profile);
//       List<int> bytes = [];

//       // Store Header
//       bytes += generator.text('FALSISTERS',
//           styles: const PosStyles(
//             align: PosAlign.center,
//             height: PosTextSize.size2,
//             width: PosTextSize.size2,
//             bold: true,
//           ));

//       bytes += generator.text('RICE TRADING',
//           styles: const PosStyles(
//             align: PosAlign.center,
//             bold: true,
//           ));

//       bytes += generator.hr();

//       // Receipt Info
//       bytes += generator.row([
//         PosColumn(text: 'Receipt #:', width: 6),
//         PosColumn(
//             text: sale.id.substring(0, 8).toUpperCase(),
//             width: 6,
//             styles: const PosStyles(bold: true)),
//       ]);

//       bytes += generator.row([
//         PosColumn(text: 'Date:', width: 6),
//         PosColumn(text: _formatDate(sale.createdAt), width: 6),
//       ]);

//       bytes += generator.row([
//         PosColumn(text: 'Cashier:', width: 6),
//         PosColumn(text: sale.cashierId.substring(0, 8), width: 6),
//       ]);

//       bytes += generator.hr();

//       // Items
//       for (final item in sale.saleItems) {
//         final isDiscounted = item.isDiscounted && item.discountedPrice != null;
//         double itemTotal;
//         String quantityDisplay;

//         if (item.sackPrice != null) {
//           itemTotal = isDiscounted
//               ? item.discountedPrice!
//               : item.sackPrice!.price * item.quantity;
//           quantityDisplay =
//               '${item.quantity.toInt()} sack${item.quantity > 1 ? "s" : ""}';
//         } else if (item.perKiloPrice != null) {
//           itemTotal = isDiscounted
//               ? item.discountedPrice!
//               : item.perKiloPrice!.price * item.quantity;
//           quantityDisplay = '${item.quantity.toStringAsFixed(2)} kg';
//           if (item.isGantang) {
//             quantityDisplay += ' (Gantang)';
//           }
//         } else {
//           itemTotal = isDiscounted ? item.discountedPrice! : 0;
//           quantityDisplay = '${item.quantity.toInt()} pcs';
//         }

//         bytes += generator.text(item.product.name,
//             styles: const PosStyles(bold: true));

//         bytes += generator.row([
//           PosColumn(text: quantityDisplay, width: 8),
//           PosColumn(
//               text: '₱${itemTotal.toStringAsFixed(2)}',
//               width: 4,
//               styles: const PosStyles(align: PosAlign.right)),
//         ]);

//         if (isDiscounted) {
//           bytes +=
//               generator.text('DISCOUNTED', styles: const PosStyles(bold: true));
//         }

//         bytes += generator.text('');
//       }

//       bytes += generator.hr();

//       // Total
//       bytes += generator.row([
//         PosColumn(
//             text: 'TOTAL:',
//             width: 8,
//             styles: const PosStyles(bold: true, height: PosTextSize.size2)),
//         PosColumn(
//             text: '₱${sale.totalAmount.toStringAsFixed(2)}',
//             width: 4,
//             styles: const PosStyles(
//                 align: PosAlign.right, bold: true, height: PosTextSize.size2)),
//       ]);

//       bytes += generator.text(
//           'Payment: ${sale.paymentMethod.toString().split('.').last.replaceAll('_', ' ')}');

//       bytes += generator.text('');
//       bytes += generator.text('Thank you for your business!',
//           styles: const PosStyles(align: PosAlign.center, bold: true));
//       bytes += generator.text('Please come again',
//           styles: const PosStyles(align: PosAlign.center));

//       bytes += generator.text('');
//       bytes += generator.hr();
//       bytes += generator.cut();

//       debugPrint('Generated ${bytes.length} bytes for printing');

//       // Reset manager for printing
//       _printerManager = PrinterBluetoothManager();

//       // Find and connect to the target printer
//       PrinterBluetooth? targetPrinter;
//       final Completer<PrinterBluetooth?> printerCompleter = Completer();
//       bool foundPrinter = false;

//       late StreamSubscription printSubscription;
//       printSubscription = _printerManager.scanResults.listen(
//         (devices) {
//           if (!foundPrinter) {
//             for (var device in devices) {
//               debugPrint(
//                   'Checking print device: ${device.name} - ${device.address}');
//               if (device.address == printer.address) {
//                 debugPrint('Found target printer for printing: ${device.name}');
//                 foundPrinter = true;
//                 printSubscription.cancel();
//                 printerCompleter.complete(device);
//                 return;
//               }
//             }
//           }
//         },
//         onError: (error) {
//           debugPrint('Print scan error: $error');
//           if (!printerCompleter.isCompleted) {
//             printSubscription.cancel();
//             printerCompleter.complete(null);
//           }
//         },
//       );

//       // Scan for the specific printer
//       debugPrint('Scanning for target printer: ${printer.address}');
//       _printerManager.startScan(Duration(seconds: 5));

//       try {
//         targetPrinter = await printerCompleter.future.timeout(
//           Duration(seconds: 7),
//           onTimeout: () {
//             debugPrint('Target printer search timeout');
//             printSubscription.cancel();
//             return null;
//           },
//         );
//       } catch (e) {
//         debugPrint('Error finding target printer: $e');
//         printSubscription.cancel();
//         targetPrinter = null;
//       }

//       if (targetPrinter == null) {
//         throw Exception(
//             'Could not find printer: ${printer.name} (${printer.address})');
//       }

//       debugPrint('Attempting to connect and print...');

//       // Connect and print
//       _printerManager.selectPrinter(targetPrinter);

//       // Wait a moment for connection
//       await Future.delayed(Duration(milliseconds: 500));

//       final printResult = await _printerManager.printTicket(bytes);

//       debugPrint('Print result: ${printResult?.msg ?? "No result"}');

//       if (printResult?.msg != 'Success') {
//         throw Exception('Print failed: ${printResult?.msg ?? "Unknown error"}');
//       }

//       debugPrint('Receipt printed successfully');
//     } catch (e) {
//       debugPrint('Print receipt error: $e');
//       throw Exception('Failed to print receipt: $e');
//     }
//   }

//   String _formatDate(String dateString) {
//     try {
//       final date = DateTime.parse(dateString);
//       return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return dateString;
//     }
//   }

//   void dispose() {
//     try {
//       _printerManager.stopScan();
//     } catch (e) {
//       debugPrint('Error disposing printer manager: $e');
//     }
//   }
// }

// final escPrintingServiceProvider = Provider<EscPrintingService>((ref) {
//   final service = EscPrintingService();
//   ref.onDispose(() => service.dispose());
//   return service;
// });
