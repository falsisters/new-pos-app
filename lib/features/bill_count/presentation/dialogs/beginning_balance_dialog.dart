import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/utils/bill_count_formatter.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/utils/currency_input_formatter.dart';

class BeginningBalanceDialog extends StatefulWidget {
  final double initialValue;
  final Function(double) onSave;

  const BeginningBalanceDialog({
    Key? key,
    required this.initialValue,
    required this.onSave,
  }) : super(key: key);

  @override
  State<BeginningBalanceDialog> createState() => _BeginningBalanceDialogState();
}

class _BeginningBalanceDialogState extends State<BeginningBalanceDialog> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    // Format the initial value with commas
    final formattedValue =
        widget.initialValue == 0 ? '' : widget.initialValue.toInt().toString();
    _controller = TextEditingController(text: formattedValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter Beginning Balance",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Beginning Balance Amount",
                prefixText: "₱ ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppColors.secondary, width: 2),
                ),
              ),
              inputFormatters: [
                CurrencyInputFormatter(),
                LengthLimitingTextInputFormatter(
                    15), // Allow up to 999,999,999,999
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    // Remove commas before parsing
                    final cleanValue = _controller.text.replaceAll(',', '');
                    final value = double.tryParse(cleanValue) ?? 0.0;
                    widget.onSave(value);
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
