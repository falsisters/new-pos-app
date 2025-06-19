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

  // New separate controllers for whole and decimal quantities
  late TextEditingController _wholeQuantityController;
  late TextEditingController _decimalQuantityController;

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

    // Initialize new controllers
    _wholeQuantityController = TextEditingController(text: '1');
    _decimalQuantityController = TextEditingController(text: '0');

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

    // Add listeners for new controllers
    _wholeQuantityController.addListener(_updateCombinedQuantityAndTotal);
    _decimalQuantityController.addListener(_updateCombinedQuantityAndTotal);
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

    // Dispose new controllers
    _wholeQuantityController.removeListener(_updateCombinedQuantityAndTotal);
    _decimalQuantityController.removeListener(_updateCombinedQuantityAndTotal);
    _wholeQuantityController.dispose();
    _decimalQuantityController.dispose();

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
          _wholeQuantityController.clear();
          _decimalQuantityController.text = '0';
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

          // Separate whole and decimal parts
          final wholePart = calculatedQuantity.floor();
          final decimalPart = ((calculatedQuantity - wholePart) * 100).round();

          _wholeQuantityController.text = wholePart.toString();
          _decimalQuantityController.text =
              decimalPart.toString().padLeft(2, '0');
        } else {
          if (currentTotalPriceText.isEmpty &&
              (_perKiloTotalPriceFocusNode.hasFocus ||
                  (!_perKiloQuantityFocusNode.hasFocus &&
                      !_perKiloTotalPriceFocusNode.hasFocus))) {
            _perKiloQuantityController.clear();
            _wholeQuantityController.clear();
            _decimalQuantityController.text = '0';
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

      // Reset to 1.0 kg
      _wholeQuantityController.text = '1';
      _decimalQuantityController.text = '0';
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

  bool _isOutOfStock() {
    if (_selectedSackPriceId != null) {
      final sackPrice = widget.product.sackPrice
          .firstWhere((sp) => sp.id == _selectedSackPriceId);
      final requestedQuantity = int.tryParse(_sackQuantityController.text) ?? 0;
      return sackPrice.stock < requestedQuantity;
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final requestedQuantity =
          double.tryParse(_perKiloQuantityController.text) ?? 0.0;
      return widget.product.perKiloPrice!.stock < requestedQuantity;
    }
    return false;
  }

  bool _hasStock() {
    if (_selectedSackPriceId != null) {
      final sackPrice = widget.product.sackPrice
          .firstWhere((sp) => sp.id == _selectedSackPriceId);
      return sackPrice.stock > 0;
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      return widget.product.perKiloPrice!.stock > 0;
    }
    return false;
  }

  double _getAvailableStock() {
    if (_selectedSackPriceId != null) {
      final sackPrice = widget.product.sackPrice
          .firstWhere((sp) => sp.id == _selectedSackPriceId);
      return sackPrice.stock.toDouble();
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      return widget.product.perKiloPrice!.stock;
    }
    return 0.0;
  }

  void _increaseQuantity() {
    setState(() {
      if (_selectedSackPriceId != null) {
        final sackPrice = widget.product.sackPrice
            .firstWhere((sp) => sp.id == _selectedSackPriceId);
        int currentQuantity = int.tryParse(_sackQuantityController.text) ?? 1;
        if (currentQuantity < sackPrice.stock) {
          currentQuantity++;
          _sackQuantityController.text = currentQuantity.toString();
        }
      } else if (_isPerKiloSelected) {
        double currentQuantity =
            double.tryParse(_perKiloQuantityController.text) ?? 1.0;
        double newQuantity = currentQuantity + 0.1;
        if (newQuantity <= widget.product.perKiloPrice!.stock) {
          _perKiloQuantityController.text = newQuantity.toStringAsFixed(1);
        }
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
          double newQuantity = currentQuantity - 0.1;
          if (newQuantity < 0.1) newQuantity = 0.1;
          _perKiloQuantityController.text = newQuantity.toStringAsFixed(1);
        }
      }
    });
  }

  void _setQuickQuantity(double quantity) {
    setState(() {
      if (_selectedSackPriceId != null) {
        final sackPrice = widget.product.sackPrice
            .firstWhere((sp) => sp.id == _selectedSackPriceId);
        int intQuantity = quantity.toInt();
        if (intQuantity <= sackPrice.stock) {
          if (_isSpecialPrice) {
            final minQty = sackPrice.specialPrice?.minimumQty ?? 1;
            if (intQuantity >= minQty) {
              _sackQuantityController.text = intQuantity.toString();
            }
          } else {
            _sackQuantityController.text = intQuantity.toString();
          }
        }
      } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
        if (quantity <= widget.product.perKiloPrice!.stock) {
          _perKiloQuantityController.text = quantity.toStringAsFixed(1);
        }
      }
    });
  }

  void _addToCart() {
    if (!_formKey.currentState!.validate()) return;

    // Check stock before adding to cart
    if (!_hasStock()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This item is out of stock'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isOutOfStock()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Insufficient stock. Available: ${_getAvailableStock().toStringAsFixed(_selectedSackPriceId != null ? 0 : 1)} ${_selectedSackPriceId != null ? 'sacks' : 'kg'}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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

  void _updateCombinedQuantityAndTotal() {
    if (!_isUpdatingPriceAndQuantityInternally) {
      final wholeValue = int.tryParse(_wholeQuantityController.text) ?? 0;
      final decimalValue = int.tryParse(_decimalQuantityController.text) ?? 0;
      final combinedValue = wholeValue + (decimalValue / 100);

      _isUpdatingPriceAndQuantityInternally = true;
      _perKiloQuantityController.text = combinedValue.toStringAsFixed(2);

      // Update total price based on combined quantity
      if (widget.product.perKiloPrice != null && combinedValue > 0) {
        final double unitPrice = widget.product.perKiloPrice!.price;
        double calculatedTotalPrice =
            (combinedValue * unitPrice * 100).round() / 100;
        calculatedTotalPrice = _customRoundValue(calculatedTotalPrice);
        _perKiloTotalPriceController.text =
            calculatedTotalPrice.toStringAsFixed(2);
      } else if (combinedValue == 0) {
        _perKiloTotalPriceController.clear();
      }

      _isUpdatingPriceAndQuantityInternally = false;
    }
  }

  void _increaseWholeQuantity() {
    final currentValue = int.tryParse(_wholeQuantityController.text) ?? 0;
    final newValue = currentValue + 1;

    // Check stock limit
    if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final decimalValue = int.tryParse(_decimalQuantityController.text) ?? 0;
      final totalQuantity = newValue + (decimalValue / 100);
      if (totalQuantity <= widget.product.perKiloPrice!.stock) {
        setState(() {
          _wholeQuantityController.text = newValue.toString();
        });
      }
    }
  }

  void _decreaseWholeQuantity() {
    final currentValue = int.tryParse(_wholeQuantityController.text) ?? 0;
    if (currentValue > 0) {
      setState(() {
        _wholeQuantityController.text = (currentValue - 1).toString();
      });
    }
  }

  void _increaseDecimalQuantity() {
    final currentValue = int.tryParse(_decimalQuantityController.text) ?? 0;
    final newValue = (currentValue + 5).clamp(0, 99);

    // Check stock limit
    if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final wholeValue = int.tryParse(_wholeQuantityController.text) ?? 0;
      final totalQuantity = wholeValue + (newValue / 100);
      if (totalQuantity <= widget.product.perKiloPrice!.stock) {
        setState(() {
          _decimalQuantityController.text = newValue.toString().padLeft(2, '0');
        });
      }
    }
  }

  void _decreaseDecimalQuantity() {
    final currentValue = int.tryParse(_decimalQuantityController.text) ?? 0;
    final newValue = (currentValue - 5).clamp(0, 99);
    setState(() {
      _decimalQuantityController.text = newValue.toString().padLeft(2, '0');
    });
  }

  void _setDecimalQuickQuantity(double decimal) {
    final decimalAsInt = (decimal * 100).round();

    // Check stock limit
    if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final wholeValue = int.tryParse(_wholeQuantityController.text) ?? 0;
      final totalQuantity = wholeValue + decimal;
      if (totalQuantity <= widget.product.perKiloPrice!.stock) {
        setState(() {
          _decimalQuantityController.text =
              decimalAsInt.toString().padLeft(2, '0');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasStock = _hasStock();

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
          padding: const EdgeInsets.all(12.0), // Reduced padding
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Header Card - reduced size
                Container(
                  padding: const EdgeInsets.all(12), // Reduced padding
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12), // Reduced radius
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'product-${widget.product.id}',
                        child: Container(
                          width: 50, // Reduced size
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: TextStyle(
                                fontSize: 16, // Reduced size
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2), // Reduced padding
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Configure your order',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10, // Reduced size
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

                const SizedBox(height: 12), // Reduced spacing

                // Pricing Options - reduced size
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.accent.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12), // Reduced padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.payments_outlined,
                                  color: AppColors.accent,
                                  size: 16), // Reduced size
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Pricing Options',
                              style: TextStyle(
                                fontSize: 14, // Reduced size
                                fontWeight: FontWeight.w600,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildPricingOptions(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Main content row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Quantity
                    Expanded(
                      flex: _selectedSackPriceId != null ? 3 : 2,
                      child: _buildQuantitySection(),
                    ),

                    const SizedBox(width: 8),

                    // Right Column - Decimal (Per Kilo only) and Discount
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Decimal quantity section (only for per kilo)
                          if (_isPerKiloSelected) ...[
                            _buildDecimalQuantitySection(),
                            const SizedBox(height: 8),
                          ],
                          // Discount section
                          _buildDiscountSection(),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Add to Cart Button - reduced size
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: hasStock
                        ? LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.8)
                            ],
                          )
                        : LinearGradient(
                            colors: [Colors.grey[400]!, Colors.grey[300]!],
                          ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: hasStock
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: hasStock ? _addToCart : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12), // Reduced padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                                hasStock
                                    ? Icons.shopping_cart_rounded
                                    : Icons.block,
                                color: Colors.white,
                                size: 18), // Reduced size
                            const SizedBox(width: 8),
                            Text(
                              hasStock ? 'Add to Cart' : 'Out of Stock',
                              style: TextStyle(
                                fontSize: 14, // Reduced size
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
    // Determine if this option is out of stock
    bool isOutOfStock = false;
    if (title == 'Per Kilogram' && widget.product.perKiloPrice != null) {
      isOutOfStock = widget.product.perKiloPrice!.stock <= 0;
    } else {
      // For sack prices, find the matching sack by title
      final matchingSack = widget.product.sackPrice.firstWhere(
        (sack) => parseSackType(sack.type) == title,
        orElse: () => widget.product.sackPrice.first,
      );
      isOutOfStock = matchingSack.stock <= 0;
    }

    return GestureDetector(
      onTap: isOutOfStock ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isOutOfStock
              ? Colors.grey[100]
              : isSelected
                  ? color.withOpacity(0.1)
                  : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOutOfStock
                ? Colors.grey[300]!
                : isSelected
                    ? color
                    : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected && !isOutOfStock
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
                if (isSelected && !isOutOfStock)
                  Icon(Icons.check_circle_rounded, color: color, size: 16),
                if (isOutOfStock)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'OUT',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isOutOfStock
                    ? Colors.grey[500]
                    : isSelected
                        ? color.withOpacity(0.8)
                        : Colors.grey[600],
                decoration: isOutOfStock ? TextDecoration.lineThrough : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              stock,
              style: TextStyle(
                fontSize: 9,
                color: isOutOfStock
                    ? Colors.red[600]
                    : isSelected
                        ? color.withOpacity(0.7)
                        : Colors.grey[500],
                fontWeight: isOutOfStock ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySection() {
    final bool hasStock = _hasStock();
    final double availableStock = _getAvailableStock();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.scale_outlined,
                      color: AppColors.secondary, size: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  _selectedSackPriceId != null ? 'Sacks' : 'Whole Kg',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildMainQuantityInput(hasStock, availableStock),
          ],
        ),
      ),
    );
  }

  Widget _buildDecimalQuantitySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.tune_outlined,
                      color: Colors.purple[700], size: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  'Decimal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildDecimalInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.local_offer_outlined,
                      color: Colors.orange[700], size: 14),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Discount',
                    style: TextStyle(
                      fontSize: 12,
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
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orange[700], size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Price per ${_selectedSackPriceId != null ? 'sack' : 'kg'}',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: _inputDecoration(
                    labelText: 'Unit Price ₱',
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
          ),
      ],
    );
  }

  Widget _buildMainQuantityInput(bool hasStock, double availableStock) {
    return Column(
      children: [
        // Quick Action Buttons - reduced size
        if (hasStock) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildQuickActionButton('1', 1.0)),
              const SizedBox(width: 2),
              Expanded(child: _buildQuickActionButton('2', 2.0)),
              const SizedBox(width: 2),
              Expanded(child: _buildQuickActionButton('3', 3.0)),
              const SizedBox(width: 2),
              Expanded(child: _buildQuickActionButton('5', 5.0)),
            ],
          ),
          const SizedBox(height: 8),
        ],

        // Stock status messages - reduced
        if (!hasStock)
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.red[700], size: 12),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Out of Stock',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Quantity input field
        if (_selectedSackPriceId != null)
          _buildSackQuantityField(hasStock)
        else if (_isPerKiloSelected)
          _buildWholeQuantityField(hasStock),

        // Total price field for per kilo
        if (_isPerKiloSelected) ...[
          const SizedBox(height: 6),
          _buildTotalPriceField(hasStock),
        ],
      ],
    );
  }

  Widget _buildDecimalInput() {
    return Column(
      children: [
        // Quick decimal buttons
        Row(
          children: [
            Expanded(child: _buildDecimalQuickButton('0.25', 0.25)),
            const SizedBox(width: 2),
            Expanded(child: _buildDecimalQuickButton('0.50', 0.50)),
            const SizedBox(width: 2),
            Expanded(child: _buildDecimalQuickButton('0.75', 0.75)),
          ],
        ),
        const SizedBox(height: 8),

        // Decimal input field
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextFormField(
            controller: _decimalQuantityController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: _inputDecoration(
              labelText: 'Decimal',
              prefixText: '0.',
              suffixIcon: _buildDecimalControls(),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final decimal = int.tryParse(value);
                if (decimal == null || decimal < 0 || decimal > 99) {
                  return 'Range: 0-99';
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSackQuantityField(bool hasStock) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: _sackQuantityController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        enabled: hasStock,
        decoration: _inputDecoration(
          labelText: 'Sacks',
          suffixIcon: hasStock ? _buildQuantityControls() : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Enter quantity';
          final qty = int.tryParse(value);
          if (qty == null || qty <= 0) return 'Valid quantity > 0';

          final sackPrice = widget.product.sackPrice
              .firstWhere((sp) => sp.id == _selectedSackPriceId);

          if (qty > sackPrice.stock) {
            return 'Only ${sackPrice.stock} available';
          }

          if (_isSpecialPrice) {
            if (qty < (sackPrice.specialPrice?.minimumQty ?? 0)) {
              return 'Min qty is ${sackPrice.specialPrice?.minimumQty}';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildWholeQuantityField(bool hasStock) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: _wholeQuantityController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        enabled: hasStock,
        decoration: _inputDecoration(
          labelText: 'Whole Kg',
          suffixIcon: hasStock ? _buildWholeQuantityControls() : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Enter quantity';
          final wholeQty = int.tryParse(value) ?? 0;
          final decimalQty = int.tryParse(_decimalQuantityController.text) ?? 0;
          final totalQty = wholeQty + (decimalQty / 100);

          if (totalQty <= 0) return 'Valid quantity > 0';

          if (widget.product.perKiloPrice != null &&
              totalQty > widget.product.perKiloPrice!.stock) {
            return 'Only ${widget.product.perKiloPrice!.stock.toStringAsFixed(1)} kg available';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildTotalPriceField(bool hasStock) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: _perKiloTotalPriceController,
        focusNode: _perKiloTotalPriceFocusNode,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        enabled: hasStock,
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
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    String? prefixText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: AppColors.primary, fontSize: 10),
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildQuantityControls() {
    return SizedBox(
      width: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _quantityButton(Icons.remove, _decreaseQuantity),
          const SizedBox(width: 2),
          _quantityButton(Icons.add, _increaseQuantity),
        ],
      ),
    );
  }

  Widget _buildWholeQuantityControls() {
    return SizedBox(
      width: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _quantityButton(Icons.remove, _decreaseWholeQuantity),
          const SizedBox(width: 2),
          _quantityButton(Icons.add, _increaseWholeQuantity),
        ],
      ),
    );
  }

  Widget _buildDecimalControls() {
    return SizedBox(
      width: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _quantityButton(Icons.remove, _decreaseDecimalQuantity),
          const SizedBox(width: 2),
          _quantityButton(Icons.add, _increaseDecimalQuantity),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: AppColors.primary, size: 12),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildQuickActionButton(String label, double quantity) {
    bool isEnabled = true;
    String unit = _selectedSackPriceId != null ? 'sack' : 'kg';

    // Check if quantity is available
    if (_selectedSackPriceId != null) {
      final sackPrice = widget.product.sackPrice
          .firstWhere((sp) => sp.id == _selectedSackPriceId);
      isEnabled = quantity.toInt() <= sackPrice.stock;

      if (_isSpecialPrice) {
        final minQty = sackPrice.specialPrice?.minimumQty ?? 1;
        isEnabled = isEnabled && quantity.toInt() >= minQty;
      }
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      isEnabled = quantity <= widget.product.perKiloPrice!.stock;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? () => _setQuickQuantity(quantity) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isEnabled
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isEnabled
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isEnabled ? AppColors.primary : Colors.grey[500],
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: isEnabled
                      ? AppColors.primary.withOpacity(0.7)
                      : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecimalQuickButton(String label, double decimal) {
    bool isEnabled = true;

    if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final wholeValue = int.tryParse(_wholeQuantityController.text) ?? 0;
      final totalQuantity = wholeValue + decimal;
      isEnabled = totalQuantity <= widget.product.perKiloPrice!.stock;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? () => _setDecimalQuickQuantity(decimal) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color:
                isEnabled ? Colors.purple.withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isEnabled
                  ? Colors.purple.withOpacity(0.3)
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isEnabled ? Colors.purple[700] : Colors.grey[500],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ...existing code for _buildDiscountInput and other methods...
}
