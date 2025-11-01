import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_type.dart';
import 'package:falsisters_pos_android/features/bill_count/presentation/utils/currency_input_formatter.dart';

class BillEntryWidget extends StatefulWidget {
  final BillType type;
  final int initialAmount;
  final Function(int)? onChanged;

  const BillEntryWidget({
    Key? key,
    required this.type,
    required this.initialAmount,
    this.onChanged,
  }) : super(key: key);

  @override
  State<BillEntryWidget> createState() => _BillEntryWidgetState();
}

class _BillEntryWidgetState extends State<BillEntryWidget> {
  late TextEditingController _controller;
  late int _currentAmount;
  final currencyFormat = NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    _currentAmount = widget.initialAmount;
    _controller = TextEditingController(text: _currentAmount.toString());
  }

  @override
  void didUpdateWidget(BillEntryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialAmount != widget.initialAmount) {
      _currentAmount = widget.initialAmount;
      _controller.text = _currentAmount.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateAmount(int value) {
    setState(() {
      _currentAmount = value;
      _controller.text = _currentAmount.toString();
    });
    widget.onChanged?.call(_currentAmount);
  }

  @override
  Widget build(BuildContext context) {
    final totalValue = _currentAmount * widget.type.value;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              billTypeToString(widget.type.name),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
            child: Text(
              "×",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              enabled: widget.onChanged != null,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                border: InputBorder.none,
                isDense: true,
                hintText: "0",
              ),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: widget.onChanged != null ? Colors.black : Colors.grey,
              ),
              inputFormatters: [
                CurrencyInputFormatter(),
                LengthLimitingTextInputFormatter(
                    15), // Allow up to 999,999,999,999
              ],
              onChanged: (value) {
                if (widget.onChanged == null) return;
                // Remove commas and parse the value
                final cleanValue = value.replaceAll(',', '');
                final intValue = int.tryParse(cleanValue) ?? 0;
                _updateAmount(intValue);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "₱ ${currencyFormat.format(totalValue)}",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
