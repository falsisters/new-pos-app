import 'package:falsisters_pos_android/features/app/data/model/settings_state.dart';
import 'package:falsisters_pos_android/features/app/data/providers/settings_provider.dart';
import 'package:falsisters_pos_android/features/app/data/services/settings_service.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sale_model.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:falsisters_pos_android/features/sales/data/services/receipt_storage_service.dart';
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
  String? _lastPrintedReceiptId;

  @override
  Widget build(BuildContext context) {
    ref.listen(salesProvider, (previous, next) {
      if (!mounted || _isPrinting) return;

      final saleToPrint = next.value?.saleToPrint;
      if (saleToPrint != null) {
        // Process printing asynchronously without blocking navigation
        Future.microtask(() => _handleThermalPrinting(saleToPrint));
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
      debugPrint('=== PRINTING ORCHESTRATOR START ===');

      // Clear the sale to print flag immediately to prevent UI blocking
      ref.read(salesProvider.notifier).clearSaleToPrint();

      // 1. Get the selected thermal printer
      final settingsService = ref.read(settingsServiceProvider);
      final selectedPrinter = await settingsService.getSelectedPrinter();

      if (selectedPrinter == null) {
        debugPrint('No printer selected for printing');
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

      // 2. Get copies count - CHECK SETTINGS FIRST, then metadata fallback
      debugPrint('=== COPIES DETERMINATION ===');
      debugPrint('Sale type: ${saleToPrint.runtimeType}');

      // ALWAYS get the current settings first
      final settingsState = ref.read(settingsProvider).value;
      final printCopiesSetting =
          settingsState?.printCopiesSetting ?? PrintCopiesSetting.TWO_COPIES;

      debugPrint('Current settings print copies: $printCopiesSetting');

      int copies = 2; // Default fallback only

      // Start with settings-based copies
      switch (printCopiesSetting) {
        case PrintCopiesSetting.ONE_COPY:
          copies = 1;
          break;
        case PrintCopiesSetting.TWO_COPIES:
          copies = 2;
          break;
        case PrintCopiesSetting.PROMPT_EVERY_SALE:
          copies = 2; // Default for prompt mode
          break;
      }
      debugPrint('Initial copies from settings: $copies');

      // Override with metadata ONLY if it exists and is valid
      if (saleToPrint is SaleModel) {
        debugPrint('Sale metadata: ${saleToPrint.metadata}');

        if (saleToPrint.metadata != null &&
            saleToPrint.metadata!.containsKey('printCopies')) {
          final metadataCopies = saleToPrint.metadata!['printCopies'];
          debugPrint(
              'Found printCopies in metadata: $metadataCopies (${metadataCopies.runtimeType})');

          if (metadataCopies is int && metadataCopies > 0) {
            copies = metadataCopies;
            debugPrint('Using copies from sale metadata: $copies');
          } else if (metadataCopies is String) {
            final parsedCopies = int.tryParse(metadataCopies);
            if (parsedCopies != null && parsedCopies > 0) {
              copies = parsedCopies;
              debugPrint('Parsed copies from metadata string: $copies');
            } else {
              debugPrint(
                  'Invalid metadata string, keeping settings-based copies: $copies');
            }
          } else {
            debugPrint(
                'Invalid printCopies type in metadata, keeping settings-based copies: $copies');
          }
        } else {
          debugPrint(
              'No printCopies in metadata, using settings-based copies: $copies');
        }
      } else {
        debugPrint(
            'Sale is not SaleModel, using settings-based copies: $copies');
      }

      debugPrint('FINAL COPIES COUNT: $copies');

      // 3. Show printing snackbar (non-blocking)
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                    'Printing $copies ${copies == 1 ? "copy" : "copies"} to ${selectedPrinter.name} via ${selectedPrinter.connectionDisplayName}...',
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

      // 4. Print in background (non-blocking)
      final printingService = ref.read(thermalPrintingServiceProvider);

      debugPrint('Starting background print job with $copies copies');
      debugPrint('Sale data type: ${saleToPrint.runtimeType}');
      debugPrint(
          'Printer: ${selectedPrinter.name} (${selectedPrinter.connectionDisplayName})');

      // Run printing in background without blocking
      await printingService.printReceipt(
        printer: selectedPrinter,
        sale: saleToPrint,
        context: context,
        copies: copies,
      );

      // 5. Save receipt for reprint
      if (saleToPrint is SaleModel) {
        final receiptStorage = ref.read(receiptStorageServiceProvider);
        await receiptStorage.saveReceiptForReprint(saleToPrint);
        _lastPrintedReceiptId = saleToPrint.id;
        debugPrint('Receipt ${saleToPrint.id} saved for potential reprint');
      }

      // 6. Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                      '$copies ${copies == 1 ? "copy" : "copies"} printed successfully via ${selectedPrinter.connectionDisplayName}!'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 8),
            action: _lastPrintedReceiptId != null
                ? SnackBarAction(
                    label: 'Reprint',
                    textColor: Colors.white,
                    onPressed: () => _reprintLastReceipt(),
                  )
                : null,
          ),
        );
      }

      debugPrint('=== PRINTING ORCHESTRATOR SUCCESS ===');
    } catch (e) {
      debugPrint('Thermal printing error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
            duration: const Duration(seconds: 10),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _handleThermalPrinting(saleToPrint),
            ),
          ),
        );
      }
    } finally {
      // 7. Reset printing state
      if (mounted) {
        setState(() {
          _isPrinting = false;
        });
      }
      debugPrint('=== PRINTING ORCHESTRATOR END ===');
    }
  }

  Future<void> _reprintLastReceipt() async {
    if (_lastPrintedReceiptId == null) return;

    try {
      // Show reprinting message
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
                Text('Reprinting receipt...'),
              ],
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.blue,
          ),
        );
      }

      // Get the stored receipt
      final receiptStorage = ref.read(receiptStorageServiceProvider);
      final storedSale =
          await receiptStorage.getReceiptForReprint(_lastPrintedReceiptId!);

      if (storedSale == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Receipt no longer available for reprint'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Reprint the receipt
      await _handleThermalPrinting(storedSale);
    } catch (e) {
      debugPrint('Reprint error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reprint failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _reprintLastReceipt(),
            ),
          ),
        );
      }
    }
  }
}
