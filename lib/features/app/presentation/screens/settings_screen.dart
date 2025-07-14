import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/app/data/providers/settings_provider.dart';
import 'package:falsisters_pos_android/features/app/data/model/printer_model.dart';
import 'package:falsisters_pos_android/features/sales/data/services/thermal_printing_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: settingsState.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) =>
                Text('Error loading settings: ${error.toString()}'),
            data: (state) {
              return ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  _buildSectionHeader(context, 'Printer Settings'),
                  const SizedBox(height: 16),
                  _buildBluetoothStatus(context, ref, state),
                  const SizedBox(height: 16),
                  _buildSelectedPrinterCard(
                      context, ref, state.selectedPrinter),
                  const SizedBox(height: 24),
                  _buildAvailablePrintersSection(context, ref, state),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    _buildErrorCard(context, state.errorMessage!),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBluetoothStatus(
      BuildContext context, WidgetRef ref, dynamic state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              state.isBluetoothEnabled
                  ? Icons.bluetooth
                  : Icons.bluetooth_disabled,
              color: state.isBluetoothEnabled ? Colors.blue : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bluetooth Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    state.isBluetoothEnabled ? 'Enabled' : 'Disabled',
                    style: TextStyle(
                      color:
                          state.isBluetoothEnabled ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (!state.isBluetoothEnabled)
              TextButton(
                onPressed: () =>
                    ref.read(settingsProvider.notifier).checkBluetoothStatus(),
                child: const Text('Refresh'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPrinterCard(
      BuildContext context, WidgetRef ref, ThermalPrinter? selectedPrinter) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selected Printer',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (selectedPrinter != null) ...[
              ListTile(
                leading: Icon(
                  selectedPrinter.isUSBPrinter
                      ? Icons.usb
                      : selectedPrinter.isBonded
                          ? Icons.bluetooth_connected
                          : Icons.bluetooth,
                  color: AppColors.primary,
                ),
                title: Text(selectedPrinter.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(selectedPrinter.address),
                    Text('Type: ${selectedPrinter.connectionDisplayName}'),
                    if (selectedPrinter.isUSBPrinter) ...[
                      if (selectedPrinter.usbVendorId != null)
                        Text('VID: ${selectedPrinter.usbVendorId}'),
                      if (selectedPrinter.usbProductId != null)
                        Text('PID: ${selectedPrinter.usbProductId}'),
                    ] else if (selectedPrinter.isBonded)
                      Text(
                        'Paired Device',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add test print button
                    IconButton(
                      icon: Icon(Icons.print, color: Colors.blue),
                      onPressed: () =>
                          _testPrint(context, ref, selectedPrinter),
                      tooltip: 'Test print',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () =>
                          ref.read(settingsProvider.notifier).forgetPrinter(),
                      tooltip: 'Forget this printer',
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Text(
                  'No printer selected. Scan and select a printer below.'),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _testPrint(
      BuildContext context, WidgetRef ref, ThermalPrinter printer) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Testing printer...'),
            ],
          ),
        ),
      );

      final printingService = ref.read(thermalPrintingServiceProvider);
      await printingService.testPrint(
        printer: printer,
        context: context,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Test print sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Test print failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildAvailablePrintersSection(
      BuildContext context, WidgetRef ref, dynamic state) {
    // Group printers by connection type with proper type casting
    final List<ThermalPrinter> allPrinters =
        List<ThermalPrinter>.from(state.availablePrinters);

    final bluetoothPrinters =
        allPrinters.where((ThermalPrinter p) => !p.isUSBPrinter).toList();
    final usbPrinters =
        allPrinters.where((ThermalPrinter p) => p.isUSBPrinter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Available Printers',
                style: Theme.of(context).textTheme.titleLarge),
            ElevatedButton.icon(
              onPressed: state.isScanning
                  ? null
                  : () => ref.read(settingsProvider.notifier).scanForPrinters(),
              icon: state.isScanning
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.refresh),
              label: Text(state.isScanning ? 'Scanning...' : 'Scan All'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // USB Printers Section
        if (usbPrinters.isNotEmpty) ...[
          Text('USB Printers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  )),
          const SizedBox(height: 8),
          ...usbPrinters.map<Widget>((ThermalPrinter printer) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Icon(
                  Icons.usb,
                  color: Colors.orange,
                ),
                title: Text(printer.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(printer.address),
                    Text('Type: USB'),
                    if (printer.usbVendorId != null)
                      Text('VID: ${printer.usbVendorId}'),
                    if (printer.usbProductId != null)
                      Text('PID: ${printer.usbProductId}'),
                  ],
                ),
                onTap: () =>
                    ref.read(settingsProvider.notifier).selectPrinter(printer),
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
        ],

        // Bluetooth Printers Section
        if (bluetoothPrinters.isNotEmpty) ...[
          Text('Bluetooth Printers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  )),
          const SizedBox(height: 8),
          ...bluetoothPrinters.map<Widget>((ThermalPrinter printer) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Icon(
                  printer.isBonded
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth,
                  color: printer.isBonded ? Colors.green : Colors.blue,
                ),
                title: Text(printer.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(printer.address),
                    Text('Type: Bluetooth'),
                    if (printer.isBonded)
                      Text(
                        'Paired Device',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                onTap: () =>
                    ref.read(settingsProvider.notifier).selectPrinter(printer),
              ),
            );
          }).toList(),
        ],

        // No printers found message
        if (allPrinters.isEmpty && !state.isScanning)
          Column(
            children: [
              const Text(
                  'No printers found. Tap "Scan All" to search for devices.'),
              const SizedBox(height: 8),
              Text(
                'For Bluetooth: Pair your printer in Android settings first.\nFor USB: Connect your printer via USB cable.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildErrorCard(BuildContext context, String errorMessage) {
    return Card(
      elevation: 2,
      color: Colors.red[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Error',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
