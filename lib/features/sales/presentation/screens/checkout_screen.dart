import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_payment_method.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final List<ProductDto> products;
  final double total;

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

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = PaymentMethod.CASH; // Initialize with CASH
    _cashGivenController.addListener(() {
      setState(
          () {}); // To update UI based on cash given input, e.g., change calculation
    });
  }

  @override
  void dispose() {
    _cashGivenController.dispose();
    super.dispose();
  }

  Widget _buildCashTenderedCard() {
    if (_selectedPaymentMethod != PaymentMethod.CASH) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.money, color: AppColors.primary),
                const SizedBox(width: 12),
                const Text(
                  'Cash Tendered',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cashGivenController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Enter amount tendered',
                prefixText: '₱',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
              validator: (value) {
                if (_selectedPaymentMethod == PaymentMethod.CASH) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount tendered';
                  }
                  final double? amount = double.tryParse(value);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final salesNotifier = ref.watch(salesProvider.notifier);

    double cashGiven = 0.0;
    double changeAmount = 0.0;
    bool showChange = false;

    if (_selectedPaymentMethod == PaymentMethod.CASH &&
        _cashGivenController.text.isNotEmpty) {
      final parsedCash = double.tryParse(_cashGivenController.text);
      if (parsedCash != null) {
        cashGiven = parsedCash;
        if (cashGiven >= widget.total) {
          changeAmount = cashGiven - widget.total;
          showChange = true;
        }
      }
    }

    return Scaffold(
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cash Tendered Card (Conditional)
                _buildCashTenderedCard(),
                if (_selectedPaymentMethod == PaymentMethod.CASH)
                  const SizedBox(height: 24),

                // Order Summary Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_bag,
                                color: AppColors.primary),
                            const SizedBox(width: 12),
                            const Text(
                              'Order Summary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${widget.products.length} item${widget.products.length > 1 ? "s" : ""}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Products List
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.products.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final product = widget.products[index];
                          final bool isDiscountApplied =
                              product.isDiscounted == true &&
                                  product.discountedPrice != null;

                          double itemDisplayPrice;
                          String priceDetails;

                          if (product.sackPrice != null) {
                            itemDisplayPrice = isDiscountApplied
                                ? product.discountedPrice!
                                : product.sackPrice!.price *
                                    product.sackPrice!.quantity;
                            priceDetails =
                                '${product.sackPrice!.quantity.toInt()} sack${product.sackPrice!.quantity > 1 ? "s" : ""} • ₱${product.sackPrice!.price.toStringAsFixed(2)} /sack';
                          } else if (product.perKiloPrice != null) {
                            itemDisplayPrice = isDiscountApplied
                                ? product.discountedPrice!
                                : product.perKiloPrice!.price *
                                    product.perKiloPrice!.quantity;
                            priceDetails =
                                '${product.perKiloPrice!.quantity.toStringAsFixed(2)} kg • ₱${product.perKiloPrice!.price.toStringAsFixed(2)} /kg';
                          } else {
                            itemDisplayPrice = 0; // Should not happen
                            priceDetails = "N/A";
                          }

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    priceDetails,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      decoration: isDiscountApplied
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  if (isDiscountApplied)
                                    Text(
                                      'Discounted Price',
                                      style: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            trailing: Text(
                              '₱${itemDisplayPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.accent,
                              ),
                            ),
                          );
                        },
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  '₱${widget.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                            if (showChange) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Cash Tendered',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    '₱${cashGiven.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Change',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '₱${changeAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 8),
                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '₱${widget.total.toStringAsFixed(2)}',
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

                const SizedBox(height: 24),

                // Payment Method Section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.payment, color: AppColors.primary),
                            const SizedBox(width: 12),
                            const Text(
                              'Payment Method',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<PaymentMethod>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            hintText: 'Select payment method',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.primary),
                            ),
                          ),
                          value: _selectedPaymentMethod,
                          items: PaymentMethod.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(parsePaymentMethod(e)),
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
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedPaymentMethod == PaymentMethod.CASH) {
                          final String cashGivenText =
                              _cashGivenController.text;
                          if (cashGivenText.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please enter the amount tendered for cash payment.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          final double? tenderedAmount =
                              double.tryParse(cashGivenText);
                          if (tenderedAmount == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid amount tendered.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          if (tenderedAmount < widget.total) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Cash tendered (₱${tenderedAmount.toStringAsFixed(2)}) is less than the total amount (₱${widget.total.toStringAsFixed(2)}).'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                        }

                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Confirm Checkout'),
                            content: Text(
                              'Complete your purchase for ₱${widget.total.toStringAsFixed(2)}?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Process the sale
                                  salesNotifier.submitSale(
                                      widget.total, _selectedPaymentMethod);

                                  // Show success and return
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.check_circle,
                                              color: Colors.white),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Checkout successful!',
                                          )
                                        ],
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                  Navigator.pop(context); // Pop CheckoutScreen
                                },
                                child: const Text('CONFIRM'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Complete Purchase',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
