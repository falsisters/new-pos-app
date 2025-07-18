import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/core/utils/currency_formatter.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_payment_method.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:falsisters_pos_android/features/sales_check/data/providers/sales_check_provider.dart';
import 'package:falsisters_pos_android/features/shift/data/providers/shift_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final List<ProductDto> products;
  final double total; // This will be ignored in favor of calculated total

  const CheckoutScreen({
    super.key,
    required this.products,
    required this.total,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late PaymentMethod _selectedPaymentMethod;
  final _cashGivenController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Add ceiling rounding method for total price consistency with improved precision
  double _ceilRoundPrice(double value) {
    if (value.isNaN || value.isInfinite) return 0.0;
    if (value < 0) return 0.0;

    // Fix precision loss by converting to string first, then parsing back
    final valueStr = value.toStringAsFixed(10);
    final preciseValue = double.parse(valueStr);

    // Use proper rounding to avoid floating point precision issues
    final centsValue = (preciseValue * 100.0).round();
    final ceiledCents =
        ((centsValue + 99) ~/ 100) * 100; // Ceiling to next cent

    return ceiledCents / 100.0;
  }

  // Calculate individual item total with ceiling rounding
  double _calculateItemTotal(ProductDto product) {
    final bool isDiscountApplied =
        product.isDiscounted == true && product.discountedPrice != null;

    double itemTotal;

    if (isDiscountApplied) {
      // For discounted items, the discounted price should already be ceiling-rounded
      // Apply it per quantity
      double quantity = 1.0;
      if (product.perKiloPrice != null) {
        quantity = product.perKiloPrice!.quantity;
      } else if (product.sackPrice != null) {
        quantity = product.sackPrice!.quantity;
      }

      // Use ceiling-rounded discount price
      final ceiledDiscountPrice = _ceilRoundPrice(product.discountedPrice!);
      itemTotal = ceiledDiscountPrice * quantity;
    } else if (product.sackPrice != null) {
      // Use ceiling-rounded unit price
      final ceiledUnitPrice = _ceilRoundPrice(product.sackPrice!.price);
      itemTotal = ceiledUnitPrice * product.sackPrice!.quantity;
    } else if (product.perKiloPrice != null) {
      // Use ceiling-rounded unit price
      final ceiledUnitPrice = _ceilRoundPrice(product.perKiloPrice!.price);
      itemTotal = ceiledUnitPrice * product.perKiloPrice!.quantity;
    } else {
      itemTotal = 0.0;
    }

    // Apply ceiling rounding to individual item total
    return _ceilRoundPrice(itemTotal);
  }

  // Calculate grand total with ceiling rounding
  double _calculateGrandTotal() {
    double total = 0.0;

    for (final product in widget.products) {
      // Add each ceiling-rounded item total
      total += _calculateItemTotal(product);
    }

    // Apply final ceiling rounding to the grand total
    return _ceilRoundPrice(total);
  }

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = PaymentMethod.CASH; // Initialize with CASH
    _cashGivenController.addListener(() {
      setState(
          () {}); // To update UI based on cash given input, e.g., change calculation
    });
    _focusNode.requestFocus(); // Request focus for keyboard input
  }

  @override
  void dispose() {
    _cashGivenController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      _completePurchase();
    }
  }

  void _completePurchase() {
    if (_formKey.currentState!.validate()) {
      double changeAmount = 0.0;
      String? cashierId;
      String? cashierName;

      // Get current shift and cashier info
      final currentShift = ref.read(currentShiftProvider);
      if (currentShift?.shift?.employees.isNotEmpty == true) {
        // First employee is always the cashier
        final cashierEmployee = currentShift!.shift!.employees[0];
        cashierId = cashierEmployee.id;
        cashierName = cashierEmployee.name;
        debugPrint('Cashier found: ID=$cashierId, Name=$cashierName');
      }

      // Use ceiling-rounded total for calculation
      final ceiledTotal = _calculateGrandTotal();

      if (_selectedPaymentMethod == PaymentMethod.CASH) {
        final String cashGivenText =
            _cashGivenController.text.replaceAll(',', '');
        if (cashGivenText.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Please enter the amount tendered for cash payment.'),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }
        final double? tenderedAmount = double.tryParse(cashGivenText);
        if (tenderedAmount == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid amount tendered.'),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }
        if (tenderedAmount < ceiledTotal) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Cash tendered (₱${CurrencyFormatter.formatCurrency(tenderedAmount)}) is less than the total amount (₱${CurrencyFormatter.formatCurrency(ceiledTotal)}).'),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }

        // Calculate change using ceiling-rounded total
        changeAmount = tenderedAmount - ceiledTotal;
        debugPrint(
            'Change calculated: ₱${changeAmount.toStringAsFixed(2)} (Tendered: ₱${tenderedAmount.toStringAsFixed(2)}, Total: ₱${ceiledTotal.toStringAsFixed(2)})');
      }

      final salesNotifier = ref.read(salesProvider.notifier);
      final salesCheckNotifier = ref.read(salesCheckProvider.notifier);

      // Pass change amount, cashier info and name to the sale using ceiling-rounded total
      debugPrint(
          'Submitting sale with change: ₱${changeAmount.toStringAsFixed(2)}');
      salesNotifier.submitSaleWithDetails(
        ceiledTotal, // Use ceiling-rounded total
        _selectedPaymentMethod,
        changeAmount: changeAmount,
        cashierId: cashierId,
        cashierName: cashierName,
      );
      salesCheckNotifier.refresh();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ALWAYS use the calculated ceiling-rounded total, never widget.total
    final ceiledTotal = _calculateGrandTotal();

    double cashGiven = 0.0;
    double changeAmount = 0.0;
    bool showChange = false;
    if (_selectedPaymentMethod == PaymentMethod.CASH &&
        _cashGivenController.text.isNotEmpty) {
      // Remove commas and parse cash given
      final cleanedText = _cashGivenController.text.replaceAll(',', '');
      final parsedCash = double.tryParse(cleanedText);
      if (parsedCash != null) {
        cashGiven = parsedCash;
        if (cashGiven >= ceiledTotal) {
          changeAmount = cashGiven - ceiledTotal;
          showChange = true;
        }
      }
    }

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
          title: const Text(
            'Checkout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[50]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Press Enter to complete purchase hint
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.keyboard,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Press Enter to complete purchase',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Order Summary & Payment Method Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.1),
                                      AppColors.primary.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(Icons.shopping_bag_rounded,
                                          color: AppColors.primary, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Order Summary',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${widget.products.length} item${widget.products.length > 1 ? "s" : ""}',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Products List (Compact)
                              Container(
                                constraints: BoxConstraints(maxHeight: 200),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: widget.products.length,
                                  separatorBuilder: (context, index) => Divider(
                                      height: 1, color: Colors.grey[200]),
                                  itemBuilder: (context, index) {
                                    final product = widget.products[index];
                                    final bool isDiscountApplied =
                                        product.isDiscounted == true &&
                                            product.discountedPrice != null;

                                    // Use ceiling-rounded item total
                                    final itemDisplayPrice =
                                        _calculateItemTotal(product);

                                    String priceDetails;
                                    if (product.sackPrice != null) {
                                      priceDetails =
                                          '${product.sackPrice!.quantity.toInt()} sack${product.sackPrice!.quantity > 1 ? "s" : ""}';
                                    } else if (product.perKiloPrice != null) {
                                      priceDetails =
                                          '${product.perKiloPrice!.quantity.toStringAsFixed(2)} kg';
                                    } else {
                                      priceDetails = "N/A";
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  priceDetails,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                if (isDiscountApplied)
                                                  Text(
                                                    'Discounted',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.secondary,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '₱${CurrencyFormatter.formatCurrency(itemDisplayPrice)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: AppColors.accent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Totals Section
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    if (showChange) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Cash Tendered',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600])),
                                          Text(
                                              '₱${CurrencyFormatter.formatCurrency(cashGiven)}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[800])),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Change',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.secondary,
                                                  fontWeight: FontWeight.w500)),
                                          Text(
                                              '₱${CurrencyFormatter.formatCurrency(changeAmount)}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.secondary,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                    ],
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '₱${CurrencyFormatter.formatCurrency(ceiledTotal)}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.accent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Payment Method Section
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.secondary.withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(Icons.payment_rounded,
                                          color: AppColors.secondary, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Payment',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<PaymentMethod>(
                                  decoration: InputDecoration(
                                    labelText: 'Method',
                                    labelStyle: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: AppColors.secondary
                                              .withOpacity(0.3)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: AppColors.secondary
                                              .withOpacity(0.3)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: AppColors.secondary, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                    isDense: true,
                                  ),
                                  value: _selectedPaymentMethod,
                                  items: PaymentMethod.values
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(parsePaymentMethod(e),
                                                style: TextStyle(fontSize: 14)),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedPaymentMethod = value;
                                        if (_selectedPaymentMethod !=
                                            PaymentMethod.CASH) {
                                          _cashGivenController.clear();
                                        }
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a payment method';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Cash Tendered (if cash payment)
                  if (_selectedPaymentMethod == PaymentMethod.CASH)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.green.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.money_rounded,
                                      color: Colors.green[700], size: 20),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Cash Tendered',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _cashGivenController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                CurrencyInputFormatter(),
                              ],
                              autofocus: true,
                              onFieldSubmitted: (_) => _completePurchase(),
                              decoration: InputDecoration(
                                labelText: 'Amount Tendered',
                                labelStyle: TextStyle(
                                    color: Colors.green[700], fontSize: 14),
                                prefixText: '₱',
                                suffixIcon: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.keyboard_return,
                                        color: Colors.green[700], size: 16),
                                    onPressed: _completePurchase,
                                    tooltip: 'Press Enter to complete',
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.green.withOpacity(0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.green.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.green[700]!, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                              validator: (value) {
                                if (_selectedPaymentMethod ==
                                    PaymentMethod.CASH) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter amount tendered';
                                  }
                                  final cleanedValue =
                                      value.replaceAll(',', '');
                                  final double? amount =
                                      double.tryParse(cleanedValue);
                                  if (amount == null) {
                                    return 'Invalid amount';
                                  }
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Checkout Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent,
                          AppColors.accent.withOpacity(0.8)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _completePurchase,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                'Complete Purchase (Enter)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
