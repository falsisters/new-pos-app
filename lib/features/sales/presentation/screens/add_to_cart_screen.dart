// ignore_for_file: unused_local_variable, unused_field

import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_sack_type.dart';
import 'package:falsisters_pos_android/features/sales/data/model/per_kilo_price_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sack_price_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/core/utils/extensions.dart';

class AddToCartScreen extends ConsumerStatefulWidget {
  final Product product;

  const AddToCartScreen({super.key, required this.product});

  @override
  ConsumerState<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends ConsumerState<AddToCartScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // State management variables
  bool _isSpecialPrice = false;
  String? _selectedSackPriceId;
  String? _selectedSpecialPriceId;
  bool _isPerKiloSelected = false;

  // New state variables
  bool _isDiscounted = false;
  late TextEditingController _discountedPriceController;
  late TextEditingController _sackQuantityController;
  late TextEditingController _perKiloQuantityController;
  late TextEditingController _perKiloTotalPriceController;
  bool _isUpdatingPriceAndQuantityInternally = false;

  // FocusNodes for per kilo inputs
  final FocusNode _perKiloQuantityFocusNode = FocusNode();
  final FocusNode _perKiloTotalPriceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _discountedPriceController = TextEditingController();
    _sackQuantityController = TextEditingController(text: '1');
    _perKiloQuantityController = TextEditingController(text: '1.0');
    _perKiloTotalPriceController = TextEditingController();

    if (widget.product.perKiloPrice != null &&
        widget.product.sackPrice.isEmpty) {
      _isPerKiloSelected = true;
      // Calculate and set initial total price for 1.0 kg
      _calculateInitialPerKiloTotalPrice();
    } else if (widget.product.sackPrice.isNotEmpty) {
      // Default to first sack price if no per kilo or if both exist
      _selectSackPrice(widget.product.sackPrice.first.id);
    }

    _perKiloQuantityController
        .addListener(_updatePerKiloTotalPriceFromQuantity);
    _perKiloTotalPriceController
        .addListener(_updatePerKiloQuantityFromTotalPrice);
  }

  @override
  void dispose() {
    _discountedPriceController.dispose();
    _sackQuantityController.dispose();
    _perKiloQuantityController
        .removeListener(_updatePerKiloTotalPriceFromQuantity);
    _perKiloTotalPriceController
        .removeListener(_updatePerKiloQuantityFromTotalPrice);
    _perKiloQuantityController.dispose();
    _perKiloTotalPriceController.dispose();
    _perKiloQuantityFocusNode.dispose();
    _perKiloTotalPriceFocusNode.dispose();
    super.dispose();
  }

  double _customRoundValue(double value) {
    // Round to 2 decimal places to avoid floating point precision issues
    double rounded = double.parse(value.toStringAsFixed(2));
    double decimalPart = rounded - rounded.truncate();

    // Use a more precise threshold for rounding up
    if (decimalPart >= 0.90) {
      return rounded.ceil().toDouble();
    }
    return rounded;
  }

  void _updatePerKiloTotalPriceFromQuantity() {
    if (_isUpdatingPriceAndQuantityInternally) return;

    if (_perKiloQuantityFocusNode.hasFocus ||
        (!_perKiloQuantityFocusNode.hasFocus &&
            !_perKiloTotalPriceFocusNode.hasFocus)) {
      _isUpdatingPriceAndQuantityInternally = true;
      final String currentQuantityText = _perKiloQuantityController.text;
      final double? quantity = double.tryParse(currentQuantityText);

      if (widget.product.perKiloPrice != null) {
        final double unitPrice = widget.product.perKiloPrice!.price;

        if (unitPrice <= 0) {
          _perKiloTotalPriceController.clear();
        } else if (quantity != null && quantity > 0) {
          // Use precise calculation with proper rounding
          double calculatedTotalPrice =
              (quantity * unitPrice * 100).round() / 100;

          // Ensure non-negative result
          if (calculatedTotalPrice < 0) calculatedTotalPrice = 0;

          // Apply custom rounding
          calculatedTotalPrice = _customRoundValue(calculatedTotalPrice);

          _perKiloTotalPriceController.text =
              calculatedTotalPrice.toStringAsFixed(2);
        } else {
          if (currentQuantityText.isEmpty &&
              (_perKiloQuantityFocusNode.hasFocus ||
                  (!_perKiloQuantityFocusNode.hasFocus &&
                      !_perKiloTotalPriceFocusNode.hasFocus))) {
            _perKiloTotalPriceController.clear();
          }
        }
      }
      _isUpdatingPriceAndQuantityInternally = false;
    }
  }

  void _updatePerKiloQuantityFromTotalPrice() {
    if (_isUpdatingPriceAndQuantityInternally) return;

    if (_perKiloTotalPriceFocusNode.hasFocus ||
        (!_perKiloQuantityFocusNode.hasFocus &&
            !_perKiloTotalPriceFocusNode.hasFocus)) {
      _isUpdatingPriceAndQuantityInternally = true;
      final String currentTotalPriceText = _perKiloTotalPriceController.text;
      final double? totalPrice = double.tryParse(currentTotalPriceText);

      if (widget.product.perKiloPrice != null) {
        final double unitPrice = widget.product.perKiloPrice!.price;

        if (unitPrice <= 0) {
          _perKiloQuantityController.clear();
        } else if (totalPrice != null && totalPrice >= 0) {
          // Use precise calculation with proper rounding
          double calculatedQuantity =
              (totalPrice * 100 / unitPrice).round() / 100;

          // Ensure non-negative result
          if (calculatedQuantity < 0) calculatedQuantity = 0;

          // Apply custom rounding
          calculatedQuantity = _customRoundValue(calculatedQuantity);

          _perKiloQuantityController.text =
              calculatedQuantity.toStringAsFixed(2);
        } else {
          if (currentTotalPriceText.isEmpty &&
              (_perKiloTotalPriceFocusNode.hasFocus ||
                  (!_perKiloQuantityFocusNode.hasFocus &&
                      !_perKiloTotalPriceFocusNode.hasFocus))) {
            _perKiloQuantityController.clear();
          }
        }
      }
      _isUpdatingPriceAndQuantityInternally = false;
    }
  }

  void _selectSackPrice(String id, {bool isSpecial = false, int? minimumQty}) {
    setState(() {
      _selectedSackPriceId = id;
      _isSpecialPrice = isSpecial;
      _isPerKiloSelected = false;
      _sackQuantityController.text =
          (isSpecial && minimumQty != null) ? minimumQty.toString() : '1';
      if (isSpecial && minimumQty != null) {
        final sack = widget.product.sackPrice.firstWhere((sp) => sp.id == id);
        _selectedSpecialPriceId = sack.specialPrice?.id;
      } else {
        _selectedSpecialPriceId = null;
      }
    });
  }

  void _selectPerKilo() {
    setState(() {
      _selectedSackPriceId = null;
      _selectedSpecialPriceId = null;
      _isSpecialPrice = false;
      _isPerKiloSelected = true;
      _perKiloQuantityController.text = '1.0';
      // Calculate and set total price for 1.0 kg
      if (widget.product.perKiloPrice != null) {
        final double unitPrice = widget.product.perKiloPrice!.price;
        final double quantity = 1.0;
        final double totalPrice = (quantity * unitPrice * 100).round() / 100;
        final double roundedTotalPrice = _customRoundValue(totalPrice);
        _perKiloTotalPriceController.text =
            roundedTotalPrice.toStringAsFixed(2);
      }
    });
  }

  void _increaseQuantity() {
    setState(() {
      if (_selectedSackPriceId != null) {
        int currentQuantity = int.tryParse(_sackQuantityController.text) ?? 1;
        currentQuantity++;
        _sackQuantityController.text = currentQuantity.toString();
      } else if (_isPerKiloSelected) {
        double currentQuantity =
            double.tryParse(_perKiloQuantityController.text) ?? 1.0;
        currentQuantity = ((currentQuantity * 10) + 1) / 10; // Add 0.1
        _perKiloQuantityController.text = currentQuantity.toStringAsFixed(1);
        _updatePerKiloTotalPriceFromQuantity();
      }
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (_selectedSackPriceId != null) {
        int currentQuantity = int.tryParse(_sackQuantityController.text) ?? 1;
        int minQty = 1;
        if (_isSpecialPrice) {
          final sackPrice = widget.product.sackPrice
              .firstWhere((sp) => sp.id == _selectedSackPriceId);
          minQty = sackPrice.specialPrice?.minimumQty ?? 1;
        }
        if (currentQuantity > minQty) {
          currentQuantity--;
          _sackQuantityController.text = currentQuantity.toString();
        }
      } else if (_isPerKiloSelected) {
        double currentQuantity =
            double.tryParse(_perKiloQuantityController.text) ?? 1.0;
        if (currentQuantity > 0.1) {
          currentQuantity = ((currentQuantity * 10) - 1) / 10; // Subtract 0.1
          _perKiloQuantityController.text = currentQuantity.toStringAsFixed(1);
          _updatePerKiloTotalPriceFromQuantity();
        }
      }
    });
  }

  void _addToCart() {
    if (!_formKey.currentState!.validate()) return;

    final salesNotifier = ref.read(salesProvider.notifier);
    ProductDto productDto;

    if (_selectedSackPriceId != null) {
      final sackPrice = widget.product.sackPrice
          .firstWhere((sp) => sp.id == _selectedSackPriceId);
      final quantity = double.tryParse(_sackQuantityController.text) ?? 1.0;

      // Round the price to avoid precision issues
      final roundedPrice = _isSpecialPrice
          ? double.parse((sackPrice.specialPrice!.price).toStringAsFixed(2))
          : double.parse(sackPrice.price.toStringAsFixed(2));

      productDto = ProductDto(
        id: widget.product.id,
        name: widget.product.name,
        isGantang: false,
        isSpecialPrice: _isSpecialPrice,
        sackPrice: SackPriceDto(
          id: sackPrice.id,
          price: roundedPrice,
          quantity: quantity,
          type: sackPrice.type,
        ),
        isDiscounted: _isDiscounted,
        discountedPrice: _isDiscounted
            ? double.tryParse(_discountedPriceController.text)
                ?.let((val) => double.parse(val.toStringAsFixed(2)))
            : null,
      );
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final perKiloPrice = widget.product.perKiloPrice!;
      final quantity = double.tryParse(_perKiloQuantityController.text) ?? 1.0;

      // Round the price to avoid precision issues
      final roundedPrice = double.parse(perKiloPrice.price.toStringAsFixed(2));
      final roundedQuantity = double.parse(quantity.toStringAsFixed(2));

      productDto = ProductDto(
        id: widget.product.id,
        name: widget.product.name,
        isGantang: false,
        isSpecialPrice: false,
        perKiloPrice: PerKiloPriceDto(
          id: perKiloPrice.id,
          price: roundedPrice,
          quantity: roundedQuantity,
        ),
        isDiscounted: _isDiscounted,
        discountedPrice: _isDiscounted
            ? double.tryParse(_discountedPriceController.text)
                ?.let((val) => double.parse(val.toStringAsFixed(2)))
            : null,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a pricing option.')),
      );
      return;
    }

    salesNotifier.addProductToCart(productDto);
    Navigator.pop(context);
  }

  void _calculateInitialPerKiloTotalPrice() {
    if (widget.product.perKiloPrice != null) {
      final double unitPrice = widget.product.perKiloPrice!.price;
      final double quantity = 1.0;
      final double totalPrice = (quantity * unitPrice * 100).round() / 100;
      final double roundedTotalPrice = _customRoundValue(totalPrice);
      _perKiloTotalPriceController.text = roundedTotalPrice.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
        title: const Text('Add to Cart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Header Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'product-${widget.product.id}',
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(widget.product.picture),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Configure your order',
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
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Pricing Options
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppColors.accent.withOpacity(0.2)),
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
                                color: AppColors.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.payments_outlined,
                                  color: AppColors.accent, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Pricing Options',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildPricingOptions(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Quantity & Discount Row
                Row(
                  children: [
                    // Quantity Section
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
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.secondary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.scale_outlined,
                                        color: AppColors.secondary, size: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildQuantityInput(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Discount Section
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.orange.withOpacity(0.2)),
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
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.local_offer_outlined,
                                        color: Colors.orange[700], size: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Discount',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildDiscountInput(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Add to Cart Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _addToCart,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_rounded,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              'Add to Cart',
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
    );
  }

  Widget _buildPricingOptions() {
    final hasPerKilo = widget.product.perKiloPrice != null;
    final hasSackPrices = widget.product.sackPrice.isNotEmpty;

    if (!hasPerKilo && !hasSackPrices) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'No pricing options available for this product',
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Collect all options
    List<Widget> allOptions = [];

    // Add per kilo option
    if (hasPerKilo) {
      allOptions.add(
        _buildOptionCard(
          isSelected: _isPerKiloSelected,
          onTap: _selectPerKilo,
          icon: Icons.scale_rounded,
          title: 'Per Kilogram',
          subtitle:
              '₱${widget.product.perKiloPrice!.price.toStringAsFixed(2)} / kg',
          stock:
              '${widget.product.perKiloPrice!.stock.toStringAsFixed(1)} kg available',
          color: Colors.green,
        ),
      );
    }

    // Add sack options
    if (hasSackPrices) {
      for (final sack in widget.product.sackPrice) {
        final isSelected = _selectedSackPriceId == sack.id && !_isSpecialPrice;
        allOptions.add(
          _buildOptionCard(
            isSelected: isSelected,
            onTap: () => _selectSackPrice(sack.id),
            icon: Icons.inventory_rounded,
            title: parseSackType(sack.type),
            subtitle: '₱${sack.price.toStringAsFixed(2)} / sack',
            stock: '${sack.stock.toInt()} sacks available',
            color: AppColors.accent,
          ),
        );
      }
    }

    // Create grid layout with 2 columns
    return Column(
      children: [
        for (int i = 0; i < allOptions.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: i + 2 < allOptions.length ? 8 : 0),
            child: Row(
              children: [
                Expanded(child: allOptions[i]),
                if (i + 1 < allOptions.length) ...[
                  const SizedBox(width: 8),
                  Expanded(child: allOptions[i + 1]),
                ] else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildOptionCard({
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    required String stock,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? color.withOpacity(0.2) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? color : Colors.grey[600],
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: color, size: 16),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected ? color.withOpacity(0.8) : Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              stock,
              style: TextStyle(
                fontSize: 9,
                color: isSelected ? color.withOpacity(0.7) : Colors.grey[500],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityInput() {
    return Column(
      children: [
        if (_selectedSackPriceId != null)
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: _sackQuantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _inputDecoration(
                labelText: 'Sacks',
                suffixIcon: _buildQuantityControls(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter quantity';
                final qty = int.tryParse(value);
                if (qty == null || qty <= 0) return 'Valid quantity > 0';
                if (_isSpecialPrice) {
                  final sackPrice = widget.product.sackPrice
                      .firstWhere((sp) => sp.id == _selectedSackPriceId);
                  if (qty < (sackPrice.specialPrice?.minimumQty ?? 0)) {
                    return 'Min qty is ${sackPrice.specialPrice?.minimumQty}';
                  }
                }
                return null;
              },
              // Remove onChanged to prevent focus loss
            ),
          ),
        if (_isPerKiloSelected) ...[
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: _perKiloQuantityController,
              focusNode: _perKiloQuantityFocusNode,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: _inputDecoration(
                labelText: 'Kg',
                suffixIcon: _buildQuantityControls(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter quantity';
                final qty = double.tryParse(value);
                if (qty == null || qty <= 0) return 'Valid quantity > 0';
                return null;
              },
              // Remove onChanged to prevent focus loss - listeners handle updates
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: _perKiloTotalPriceController,
              focusNode: _perKiloTotalPriceFocusNode,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: _inputDecoration(
                labelText: 'Total ₱',
                prefixText: '₱ ',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter total price';
                final priceVal = double.tryParse(value);
                if (priceVal == null || priceVal < 0) return 'Valid price >= 0';
                return null;
              },
              // Remove onChanged to prevent focus loss - listeners handle updates
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    String? prefixText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: AppColors.primary, fontSize: 12),
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildQuantityControls() {
    return SizedBox(
      width: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _quantityButton(Icons.remove, _decreaseQuantity),
          const SizedBox(width: 4),
          _quantityButton(Icons.add, _increaseQuantity),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: AppColors.primary, size: 16),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildDiscountInput() {
    return Column(
      children: [
        Transform.scale(
          scale: 0.8,
          child: CheckboxListTile(
            title: Text('Apply Discount', style: TextStyle(fontSize: 12)),
            value: _isDiscounted,
            onChanged: (bool? value) {
              setState(() {
                _isDiscounted = value ?? false;
                if (!_isDiscounted) _discountedPriceController.clear();
              });
            },
            activeColor: Colors.orange[700],
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (_isDiscounted)
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: _discountedPriceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: _inputDecoration(
                labelText: 'Price ₱',
                prefixText: '₱ ',
              ),
              validator: (value) {
                if (_isDiscounted) {
                  if (value == null || value.isEmpty)
                    return 'Enter discounted price';
                  final priceVal = double.tryParse(value);
                  if (priceVal == null || priceVal <= 0)
                    return 'Valid price > 0';
                }
                return null;
              },
            ),
          ),
      ],
    );
  }
}
