// ignore_for_file: unused_local_variable, unused_field

import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/per_kilo_price_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sack_price_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:falsisters_pos_android/features/sales/presentation/widgets/add_to_cart/decimal_quantity_widget.dart';
import 'package:falsisters_pos_android/features/sales/presentation/widgets/add_to_cart/discount_section_widget.dart';
import 'package:falsisters_pos_android/features/sales/presentation/widgets/add_to_cart/pricing_options_widget.dart';
import 'package:falsisters_pos_android/features/sales/presentation/widgets/add_to_cart/product_header_widget.dart';
import 'package:falsisters_pos_android/features/sales/presentation/widgets/add_to_cart/quantity_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_android/core/utils/extensions.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters except decimal point
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Handle multiple decimal points
    List<String> parts = digitsOnly.split('.');
    if (parts.length > 2) {
      digitsOnly = '${parts[0]}.${parts.sublist(1).join('')}';
    }

    // Limit to 2 decimal places
    if (parts.length == 2 && parts[1].length > 2) {
      digitsOnly = '${parts[0]}.${parts[1].substring(0, 2)}';
    }

    if (digitsOnly.isEmpty) {
      return const TextEditingValue();
    }

    // Parse the number
    double? value = double.tryParse(digitsOnly);
    if (value == null) {
      return oldValue;
    }

    // Format with commas
    String formatted;
    if (digitsOnly.contains('.')) {
      List<String> splitValue = digitsOnly.split('.');
      String integerPart = splitValue[0];
      String decimalPart = splitValue.length > 1 ? splitValue[1] : '';

      // Add commas to integer part
      if (integerPart.isNotEmpty) {
        int intValue = int.tryParse(integerPart) ?? 0;
        String formattedInteger = intValue.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
        formatted = decimalPart.isNotEmpty
            ? '$formattedInteger.$decimalPart'
            : formattedInteger;
      } else {
        formatted = '.$decimalPart';
      }
    } else {
      int intValue = int.tryParse(digitsOnly) ?? 0;
      formatted = intValue.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class AddToCartScreen extends ConsumerStatefulWidget {
  final Product product;

  const AddToCartScreen({super.key, required this.product});

  @override
  ConsumerState<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends ConsumerState<AddToCartScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _keyboardFocusNode = FocusNode();

  // State management variables
  bool _isSpecialPrice = false;
  String? _selectedSackPriceId;
  String? _selectedSpecialPriceId;
  bool _isPerKiloSelected = false;

  // New state variables
  bool _isDiscounted = false;
  bool _isGantangMode = false; // Add this new state variable
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

  // Gantang conversion constant
  static const double gantangToKgRatio = 2.25;

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

    // Request focus for keyboard input - this is the key part that was missing!
    _keyboardFocusNode.requestFocus();
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
    _keyboardFocusNode.dispose();
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

  // Add new helper methods for Gantang conversion
  double _convertGantangToKg(double gantangValue) {
    return gantangValue * gantangToKgRatio;
  }

  double _convertKgToGantang(double kgValue) {
    return kgValue / gantangToKgRatio;
  }

  double _getCurrentQuantityInKg() {
    final wholeValue = int.tryParse(_wholeQuantityController.text) ?? 0;
    final decimalValue = int.tryParse(_decimalQuantityController.text) ?? 0;

    // Always treat decimal as hundredths (0-99 -> 0.00-0.99)
    final decimalPart = decimalValue / 100.0;
    final displayQuantity = wholeValue + decimalPart;

    return _isGantangMode
        ? _convertGantangToKg(displayQuantity)
        : displayQuantity;
  }

  void _setQuantityFromKg(double kgQuantity) {
    final displayQuantity =
        _isGantangMode ? _convertKgToGantang(kgQuantity) : kgQuantity;
    final wholePart = displayQuantity.floor();
    final fractionalPart = displayQuantity - wholePart;

    // Convert fractional part to hundredths (0.0-0.99 -> 0-99)
    final decimalPart = (fractionalPart * 100).round();

    _wholeQuantityController.text = wholePart.toString();
    _decimalQuantityController.text = decimalPart.toString().padLeft(2, '0');
    _perKiloQuantityController.text = kgQuantity.toStringAsFixed(2);
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

          // Update display quantity based on current mode
          _setQuantityFromKg(calculatedQuantity);
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
      _setQuantityFromKg(1.0);
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
      final kgQuantity = _getCurrentQuantityInKg();
      return widget.product.perKiloPrice!.stock < kgQuantity;
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

      // Always treat decimal as hundredths (0-99 -> 0.00-0.99)
      final decimalPart = decimalValue / 100.0;
      final displayQuantity = wholeValue + decimalPart;

      // Convert to kg if in gantang mode
      final kgQuantity = _isGantangMode
          ? _convertGantangToKg(displayQuantity)
          : displayQuantity;

      _isUpdatingPriceAndQuantityInternally = true;
      _perKiloQuantityController.text = kgQuantity.toStringAsFixed(2);

      // Update total price based on kg quantity
      if (widget.product.perKiloPrice != null && kgQuantity > 0) {
        final double unitPrice = widget.product.perKiloPrice!.price;
        double calculatedTotalPrice =
            (kgQuantity * unitPrice * 100).round() / 100;
        calculatedTotalPrice = _customRoundValue(calculatedTotalPrice);
        _perKiloTotalPriceController.text =
            calculatedTotalPrice.toStringAsFixed(2);
      } else if (kgQuantity == 0) {
        _perKiloTotalPriceController.clear();
      }

      _isUpdatingPriceAndQuantityInternally = false;
    }
  }

  void _increaseWholeQuantity() {
    final currentValue = int.tryParse(_wholeQuantityController.text) ?? 0;
    final newValue = currentValue + 1;

    // Check stock limit in kg
    if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final decimalValue = int.tryParse(_decimalQuantityController.text) ?? 0;
      final decimalPart = decimalValue / 100.0;
      final displayQuantity = newValue + decimalPart;
      final kgQuantity = _isGantangMode
          ? _convertGantangToKg(displayQuantity)
          : displayQuantity;

      if (kgQuantity <= widget.product.perKiloPrice!.stock) {
        setState(() {
          _wholeQuantityController.text = newValue.toString();
        });
      }
    }
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

    // Check stock limit in kg
    if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final wholeValue = int.tryParse(_wholeQuantityController.text) ?? 0;
      final decimalPart = newValue / 100.0;
      final displayQuantity = wholeValue + decimalPart;
      final kgQuantity = _isGantangMode
          ? _convertGantangToKg(displayQuantity)
          : displayQuantity;

      if (kgQuantity <= widget.product.perKiloPrice!.stock) {
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
        final kgQuantity =
            _isGantangMode ? _convertGantangToKg(quantity) : quantity;

        if (kgQuantity <= widget.product.perKiloPrice!.stock) {
          _setQuantityFromKg(kgQuantity);
        }
      }
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      _addToCart();
    }
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

    final salesNotifier = ref.read(salesProvider.notifier);
    ProductDto productDto;

    if (_selectedSackPriceId != null) {
      final sackPrice = widget.product.sackPrice
          .firstWhere((sp) => sp.id == _selectedSackPriceId);
      final quantity = double.tryParse(_sackQuantityController.text) ?? 1.0;

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
            ? double.tryParse(
                    _discountedPriceController.text.replaceAll(',', ''))
                ?.let((val) => double.parse(val.toStringAsFixed(2)))
            : null,
      );
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final perKiloPrice = widget.product.perKiloPrice!;
      final kgQuantity = _getCurrentQuantityInKg();

      final roundedPrice = double.parse(perKiloPrice.price.toStringAsFixed(2));
      final roundedQuantity = double.parse(kgQuantity.toStringAsFixed(2));

      productDto = ProductDto(
        id: widget.product.id,
        name: widget.product.name,
        isGantang: _isGantangMode,
        isSpecialPrice: false,
        perKiloPrice: PerKiloPriceDto(
          id: perKiloPrice.id,
          price: roundedPrice,
          quantity: roundedQuantity,
        ),
        isDiscounted: _isDiscounted,
        discountedPrice: _isDiscounted
            ? double.tryParse(
                    _discountedPriceController.text.replaceAll(',', ''))
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

  @override
  Widget build(BuildContext context) {
    final bool hasStock = _hasStock();
    final double availableStock = _getAvailableStock();

    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
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
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add keyboard shortcut hint
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                          'Press Enter to add to cart',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Product Header Card
                  ProductHeaderWidget(product: widget.product),

                  const SizedBox(height: 12),

                  // Pricing Options
                  PricingOptionsWidget(
                    product: widget.product,
                    selectedSackPriceId: _selectedSackPriceId,
                    isSpecialPrice: _isSpecialPrice,
                    isPerKiloSelected: _isPerKiloSelected,
                    onSelectSackPrice: _selectSackPrice,
                    onSelectPerKilo: _selectPerKilo,
                  ),

                  const SizedBox(height: 12),

                  // Main content row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column - Quantity
                      Expanded(
                        flex: _selectedSackPriceId != null ? 3 : 2,
                        child: QuantitySectionWidget(
                          product: widget.product,
                          selectedSackPriceId: _selectedSackPriceId,
                          isPerKiloSelected: _isPerKiloSelected,
                          isGantangMode: _isGantangMode,
                          hasStock: hasStock,
                          availableStock: availableStock,
                          sackQuantityController: _sackQuantityController,
                          wholeQuantityController: _wholeQuantityController,
                          perKiloTotalPriceController:
                              _perKiloTotalPriceController,
                          perKiloTotalPriceFocusNode:
                              _perKiloTotalPriceFocusNode,
                          onIncreaseQuantity: _increaseQuantity,
                          onDecreaseQuantity: _decreaseQuantity,
                          onIncreaseWholeQuantity: _increaseWholeQuantity,
                          onDecreaseWholeQuantity: _decreaseWholeQuantity,
                          onSetQuickQuantity: _setQuickQuantity,
                          onToggleGantangMode: (isGantang) {
                            setState(() {
                              if (_isGantangMode != isGantang) {
                                _isGantangMode = isGantang;
                                final currentKg = _getCurrentQuantityInKg();
                                _setQuantityFromKg(currentKg);
                              }
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Right Column
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            // Decimal quantity section (only for per kilo)
                            if (_isPerKiloSelected) ...[
                              DecimalQuantityWidget(
                                isGantangMode: _isGantangMode,
                                decimalQuantityController:
                                    _decimalQuantityController,
                                onIncreaseDecimalQuantity:
                                    _increaseDecimalQuantity,
                                onDecreaseDecimalQuantity:
                                    _decreaseDecimalQuantity,
                              ),
                              const SizedBox(height: 8),
                            ],
                            // Discount section
                            DiscountSectionWidget(
                              isDiscounted: _isDiscounted,
                              isSackSelected: _selectedSackPriceId != null,
                              discountedPriceController:
                                  _discountedPriceController,
                              onDiscountToggle: (bool? value) {
                                setState(() {
                                  _isDiscounted = value ?? false;
                                  if (!_isDiscounted)
                                    _discountedPriceController.clear();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Add to Cart Button
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  hasStock
                                      ? Icons.shopping_cart_rounded
                                      : Icons.block,
                                  color: Colors.white,
                                  size: 18),
                              const SizedBox(width: 8),
                              Text(
                                hasStock
                                    ? 'Add to Cart (Enter)'
                                    : 'Out of Stock',
                                style: TextStyle(
                                  fontSize: 14,
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
