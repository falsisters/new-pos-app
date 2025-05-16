import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:falsisters_pos_android/features/bill_count/data/models/bill_type.dart';

class BillEntryWidget extends StatefulWidget {
  final BillType type;
  final int initialAmount;
  final Function(int) onChanged;

  const BillEntryWidget({
    Key? key,
    required this.type,
    required this.initialAmount,
    required this.onChanged,
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
    widget.onChanged(_currentAmount);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total value
    final totalValue = _currentAmount * widget.type.value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Bill type (e.g. "1,000")
          SizedBox(
            width: 90,
            child: Text(
              billTypeToString(widget.type.name),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Equal sign
          const SizedBox(
            width: 20,
            child: Text(
              "=",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),

          // Amount input field
          SizedBox(
            width: 100, // Increased width from 70 to 100
            child: TextField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                final intValue = int.tryParse(value) ?? 0;
                _updateAmount(intValue);
              },
            ),
          ),

          // Value
          Expanded(
            child: Text(
              "₱ ${currencyFormat.format(totalValue)}",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
