import 'package:falsisters_pos_android/features/app/data/services/settings_service.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:falsisters_pos_android/features/sales/data/services/thermal_printing_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrintingOrchestrator extends ConsumerStatefulWidget {
  final Widget child;
  const PrintingOrchestrator({super.key, required this.child});

  @override
  ConsumerState<PrintingOrchestrator> createState() =>
      _PrintingOrchestratorState();
}

class _PrintingOrchestratorState extends ConsumerState<PrintingOrchestrator> {
  bool _isPrinting = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(salesProvider, (previous, next) {
      if (!mounted || _isPrinting) return;

      final saleToPrint = next.value?.saleToPrint;
      if (saleToPrint != null) {
        _handleThermalPrinting(saleToPrint);
      }
    });

    return widget.child;
  }

  Future<void> _handleThermalPrinting(dynamic saleToPrint) async {
    if (_isPrinting || !mounted) return;

    setState(() {
      _isPrinting = true;
    });

    try {
      // 1. Get the selected thermal printer
      final settingsService = ref.read(settingsServiceProvider);
      final selectedPrinter = await settingsService.getSelectedPrinter();

      if (selectedPrinter == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('No printer selected. Please select one in Settings.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // 2. Show a "Printing..." snackbar with connection type info
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Printing receipt to ${selectedPrinter.name} via ${selectedPrinter.connectionDisplayName}...',
                  ),
                ),
              ],
            ),
            duration: Duration(seconds: selectedPrinter.isUSBPrinter ? 4 : 8),
            backgroundColor:
                selectedPrinter.isUSBPrinter ? Colors.orange : Colors.blue,
          ),
        );
      }

      // 3. Call the thermal printing service
      final printingService = ref.read(thermalPrintingServiceProvider);

      // Add debug logging
      debugPrint(
          'Starting print job for sale data type: ${saleToPrint.runtimeType}');
      debugPrint('Sale data content: ${saleToPrint.toString()}');
      debugPrint(
          'Printer: ${selectedPrinter.name} (${selectedPrinter.connectionDisplayName} - ${selectedPrinter.address})');

      // Try to get some basic info regardless of type
      try {
        final saleItems = saleToPrint is SaleModel
            ? saleToPrint.saleItems
            : saleToPrint?.saleItems ?? saleToPrint?.SaleItem ?? [];
        debugPrint('Sale items count: ${saleItems?.length ?? 0}');

        final totalAmount = saleToPrint is SaleModel
            ? saleToPrint.totalAmount
            : saleToPrint?.totalAmount ?? 0.0;
        debugPrint('Total amount: $totalAmount');
      } catch (e) {
        debugPrint('Error extracting sale info for debug: $e');
      }

      // Use the main receipt printing method (now supports both USB and Bluetooth)
      await printingService.printReceipt(
        printer: selectedPrinter,
        sale: saleToPrint,
        context: context,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                    'Receipt printed successfully via ${selectedPrinter.connectionDisplayName}!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint('Thermal printing error: $e');
      debugPrint('Sale data: ${saleToPrint?.toString()}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Printing failed'),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  e.toString().length > 100
                      ? '${e.toString().substring(0, 100)}...'
                      : e.toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 6),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _handleThermalPrinting(saleToPrint),
            ),
          ),
        );
      }
    } finally {
      // 4. Clear the sale to print flag and reset printing state
      if (mounted) {
        ref.read(salesProvider.notifier).clearSaleToPrint();
        setState(() {
          _isPrinting = false;
        });
      }
    }
  }
}
