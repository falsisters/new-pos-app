import 'package:falsisters_pos_android/features/app/data/services/settings_service.dart';
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
              content: Text(
                  'No thermal printer selected. Please select one in Settings.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // 2. Show a "Printing..." snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Printing receipt to ${selectedPrinter.name}...'),
            duration: const Duration(seconds: 4),
          ),
        );
      }

      // 3. Call the thermal printing service
      final printingService = ref.read(thermalPrintingServiceProvider);
      await printingService.printReceipt(
        printer: selectedPrinter,
        sale: saleToPrint,
        context: context,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receipt printed successfully on thermal printer!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Thermal printing error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thermal printing failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
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
