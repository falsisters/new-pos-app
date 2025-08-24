import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/app/data/model/settings_state.dart';
import 'package:falsisters_pos_android/features/app/data/providers/settings_provider.dart';
import 'package:falsisters_pos_android/features/app/data/model/printer_model.dart';
import 'package:falsisters_pos_android/features/app/data/services/settings_service.dart';
import 'package:falsisters_pos_android/features/sales/data/services/thermal_printing_service.dart';
import 'package:falsisters_pos_android/features/sales/data/services/receipt_storage_service.dart';
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
                  _buildPrintCopiesSection(context, ref, state),
                  const SizedBox(height: 24),
                  _buildReceiptStorageSection(context, ref),
                  const SizedBox(height: 24),
                  _buildKioskModeSection(context, ref, state),
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

  Widget _buildPrintCopiesSection(
      BuildContext context, WidgetRef ref, dynamic state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.content_copy,
                  color: AppColors.secondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Print Copies',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Choose how many receipt copies to print',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ...PrintCopiesSetting.values.map((setting) {
              String title;
              String subtitle;
              IconData icon;

              switch (setting) {
                case PrintCopiesSetting.ONE_COPY:
                  title = '1 Copy';
                  subtitle = 'Print only one receipt';
                  icon = Icons.looks_one;
                  break;
                case PrintCopiesSetting.TWO_COPIES:
                  title = '2 Copies';
                  subtitle = 'Print two identical receipts';
                  icon = Icons.looks_two;
                  break;
                case PrintCopiesSetting.PROMPT_EVERY_SALE:
                  title = 'Prompt Every Sale';
                  subtitle = 'Ask before each sale how many copies to print';
                  icon = Icons.help_outline;
                  break;
              }

              return RadioListTile<PrintCopiesSetting>(
                title: Text(title),
                subtitle: Text(subtitle),
                value: setting,
                groupValue: state.printCopiesSetting,
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(settingsProvider.notifier)
                        .updatePrintCopiesSetting(value);
                  }
                },
                secondary: Icon(icon, color: AppColors.secondary),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptStorageSection(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: Colors.purple[700],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Receipt Storage',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Recent receipts are stored locally for 24 hours and can be reprinted if needed.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showRecentReceipts(context, ref),
                    icon: Icon(Icons.list),
                    label: Text('View Recent Receipts'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _clearStoredReceipts(context, ref),
                  icon: Icon(Icons.delete_sweep),
                  label: Text('Clear All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRecentReceipts(BuildContext context, WidgetRef ref) async {
    try {
      final receiptStorage = ref.read(receiptStorageServiceProvider);
      final recentReceipts = await receiptStorage.getRecentReceipts();

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.purple[700]),
              const SizedBox(width: 8),
              Text('Recent Receipts'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: recentReceipts.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No recent receipts found',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: recentReceipts.length,
                    itemBuilder: (context, index) {
                      final receipt = recentReceipts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading:
                              Icon(Icons.receipt, color: Colors.purple[700]),
                          title: Text(
                            'Receipt #${receipt.id.substring(0, 8).toUpperCase()}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total: ₱${receipt.totalAmount.toStringAsFixed(2)}',
                              ),
                              Text(
                                _formatReceiptDate(receipt.createdAt),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.print, color: Colors.blue),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _reprintReceipt(context, ref, receipt);
                            },
                            tooltip: 'Reprint this receipt',
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading recent receipts: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _reprintReceipt(
      BuildContext context, WidgetRef ref, dynamic receipt) async {
    try {
      // Get current printer
      final settingsService = ref.read(settingsServiceProvider);
      final selectedPrinter = await settingsService.getSelectedPrinter();

      if (selectedPrinter == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No printer selected. Please select one first.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Show reprinting message
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

      // Get copies setting
      final settingsState = ref.read(settingsProvider).value;
      final printCopiesSetting =
          settingsState?.printCopiesSetting ?? PrintCopiesSetting.TWO_COPIES;

      int copies = 2;
      switch (printCopiesSetting) {
        case PrintCopiesSetting.ONE_COPY:
          copies = 1;
          break;
        case PrintCopiesSetting.TWO_COPIES:
          copies = 2;
          break;
        case PrintCopiesSetting.PROMPT_EVERY_SALE:
          copies = 2; // Default for manual reprint
          break;
      }

      // Print the receipt
      final printingService = ref.read(thermalPrintingServiceProvider);
      await printingService.printReceipt(
        printer: selectedPrinter,
        sale: receipt,
        context: context,
        copies: copies,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Receipt reprinted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reprint failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _clearStoredReceipts(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            Text('Clear All Receipts'),
          ],
        ),
        content: Text(
            'Are you sure you want to clear all stored receipts? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final receiptStorage = ref.read(receiptStorageServiceProvider);
        await receiptStorage.clearAllReceipts();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All stored receipts cleared'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing receipts: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatReceiptDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes} minutes ago';
        }
        return '${difference.inHours} hours ago';
      } else {
        return '${difference.inDays} days ago';
      }
    } catch (e) {
      return dateString;
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
            Row(
              children: [
                // Add hard reset button
                IconButton(
                  onPressed: () => _showHardResetDialog(context, ref),
                  icon: Icon(Icons.refresh_outlined, color: Colors.red),
                  tooltip: 'Hard Reset Printer Settings',
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: state.isScanning
                      ? null
                      : () =>
                          ref.read(settingsProvider.notifier).scanForPrinters(),
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

  Future<void> _showHardResetDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text('Hard Reset Printer Settings'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will completely reset all printer and Bluetooth settings:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('• Clear selected printer'),
            Text('• Reset Bluetooth scanner'),
            Text('• Clear printer cache'),
            Text('• Force re-scan all devices'),
            const SizedBox(height: 12),
            Text(
              'Use this if you\'re stuck in USB mode or having connection issues.',
              style: TextStyle(
                color: Colors.orange[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hard Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(settingsProvider.notifier).hardResetPrinterSettings();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Printer settings reset successfully. Please scan again.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reset failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

  Widget _buildKioskModeSection(
      BuildContext context, WidgetRef ref, dynamic state) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.security,
                  color: Colors.indigo[700],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Kiosk Mode',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Kiosk mode prevents users from accessing other apps and system functions. Only this POS app will be available.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable Kiosk Mode',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        state.isKioskModeEnabled
                            ? 'Device is in kiosk mode'
                            : 'Device can access other apps',
                        style: TextStyle(
                          color: state.isKioskModeEnabled
                              ? Colors.orange[700]
                              : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: state.isKioskModeEnabled,
                  onChanged: (value) =>
                      _showKioskModePasswordDialog(context, ref, value),
                  activeColor: Colors.indigo[700],
                ),
              ],
            ),
            if (state.isKioskModeEnabled) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber,
                        color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Kiosk mode is active. Users cannot exit this app or access system functions.',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showKioskModePasswordDialog(
      BuildContext context, WidgetRef ref, bool targetState) async {
    final TextEditingController passwordController = TextEditingController();
    bool isPasswordVisible = false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.security,
                color: Colors.indigo[700],
              ),
              const SizedBox(width: 8),
              Text(
                targetState ? 'Enable Kiosk Mode' : 'Disable Kiosk Mode',
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                targetState
                    ? 'Enter password to enable kiosk mode. This will restrict access to other apps.'
                    : 'Enter password to disable kiosk mode and restore normal device access.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    targetState ? Colors.orange[700] : Colors.indigo[700],
                foregroundColor: Colors.white,
              ),
              child: Text(targetState ? 'Enable' : 'Disable'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      final password = passwordController.text;
      final success =
          await ref.read(settingsProvider.notifier).toggleKioskMode(password);

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(targetState
                ? 'Kiosk mode enabled successfully'
                : 'Kiosk mode disabled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid password. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    passwordController.dispose();
  }
}
