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

  // Focus nodes for keyboard navigation
  final FocusNode _pricingOptionsFocusNode = FocusNode();
  final FocusNode _quantitySectionFocusNode = FocusNode();
  final FocusNode _decimalQuantityFocusNode = FocusNode();
  final FocusNode _discountSectionFocusNode = FocusNode();
  final FocusNode _perKiloQuantityFocusNode = FocusNode();
  final FocusNode _perKiloTotalPriceFocusNode = FocusNode();

  // State management variables
  bool _isSpecialPrice = false;
  String? _selectedSackPriceId;
  String? _selectedSpecialPriceId;
  bool _isPerKiloSelected = false;
  bool _isDiscounted = false;
  bool _isGantangMode = false;
  bool _isUpdatingPriceAndQuantityInternally = false;

  // Controllers
  late TextEditingController _discountedPriceController;
  late TextEditingController _sackQuantityController;
  late TextEditingController _perKiloQuantityController;
  late TextEditingController _perKiloTotalPriceController;
  late TextEditingController _wholeQuantityController;
  late TextEditingController _decimalQuantityController;

  // Gantang conversion constant
  static const double gantangToKgRatio = 2.25;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupInitialState();
    _setupListeners();
    _registerKeyboardHandler();
  }

  @override
  void dispose() {
    // Remove keyboard handler first to prevent any race conditions
    _unregisterKeyboardHandler();
    _disposeControllers();
    _disposeFocusNodes();
    super.dispose();
  }

  void _initializeControllers() {
    _discountedPriceController = TextEditingController();
    _sackQuantityController = TextEditingController(text: '1');
    _perKiloQuantityController = TextEditingController(text: '1.0');
    _perKiloTotalPriceController = TextEditingController();
    _wholeQuantityController = TextEditingController(text: '1');
    _decimalQuantityController = TextEditingController(text: '0');
  }

  void _setupInitialState() {
    if (widget.product.perKiloPrice != null &&
        widget.product.sackPrice.isEmpty) {
      _isPerKiloSelected = true;
      _calculateInitialPerKiloTotalPrice();
    } else if (widget.product.sackPrice.isNotEmpty) {
      _selectSackPrice(widget.product.sackPrice.first.id);
    }
  }

  void _setupListeners() {
    _perKiloQuantityController
        .addListener(_updatePerKiloTotalPriceFromQuantity);
    _perKiloTotalPriceController
        .addListener(_updatePerKiloQuantityFromTotalPrice);
    _wholeQuantityController.addListener(_updateCombinedQuantityAndTotal);
    _decimalQuantityController.addListener(_updateCombinedQuantityAndTotal);
  }

  void _registerKeyboardHandler() {
    // Use post-frame callback to prevent race conditions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        HardwareKeyboard.instance.addHandler(_handleKeyEvent);
      }
    });
  }

  void _unregisterKeyboardHandler() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
  }

  void _disposeControllers() {
    _discountedPriceController.dispose();
    _sackQuantityController.dispose();
    _perKiloQuantityController
        .removeListener(_updatePerKiloTotalPriceFromQuantity);
    _perKiloTotalPriceController
        .removeListener(_updatePerKiloQuantityFromTotalPrice);
    _perKiloQuantityController.dispose();
    _perKiloTotalPriceController.dispose();
    _wholeQuantityController.removeListener(_updateCombinedQuantityAndTotal);
    _decimalQuantityController.removeListener(_updateCombinedQuantityAndTotal);
    _wholeQuantityController.dispose();
    _decimalQuantityController.dispose();
  }

  void _disposeFocusNodes() {
    _pricingOptionsFocusNode.dispose();
    _quantitySectionFocusNode.dispose();
    _decimalQuantityFocusNode.dispose();
    _discountSectionFocusNode.dispose();
    _perKiloQuantityFocusNode.dispose();
    _perKiloTotalPriceFocusNode.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    // Safety checks to prevent interference from disposed widgets
    if (!mounted) {
      debugPrint('Add to Cart - Key event ignored: widget not mounted');
      return false;
    }

    if (event is KeyDownEvent) {
      debugPrint('Add to Cart - Key pressed: ${event.logicalKey}');

      // Handle Enter key for adding to cart
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        debugPrint('Add to Cart - Enter pressed, adding to cart');
        _addToCart();
        return true;
      }

      // Handle navigation keys
      if (_handleNavigationKeys(event)) {
        return true;
      }

      // Handle quantity adjustment keys
      if (_handleQuantityAdjustmentKeys(event)) {
        return true;
      }
    }
    return false;
  }

  bool _handleNavigationKeys(KeyEvent event) {
    // Handle left/right arrows for pricing options and focus cycling
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      final isRightArrow = event.logicalKey == LogicalKeyboardKey.arrowRight;

      if (_pricingOptionsFocusNode.hasFocus) {
        _handlePricingOptionsKeyboard(isRightArrow);
      } else {
        _cycleFocus(isRightArrow);
      }
      return true;
    }

    // Handle up/down arrows for vertical focus navigation
    if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      final isUpArrow = event.logicalKey == LogicalKeyboardKey.arrowUp;
      _cycleFocusVertical(isUpArrow);
      return true;
    }

    return false;
  }

  bool _handleQuantityAdjustmentKeys(KeyEvent event) {
    // Handle A and D keys for quantity adjustments
    if (event.logicalKey == LogicalKeyboardKey.keyA ||
        event.logicalKey == LogicalKeyboardKey.keyD) {
      final isIncrease = event.logicalKey == LogicalKeyboardKey.keyA;

      if (_quantitySectionFocusNode.hasFocus) {
        _handleQuantitySectionKeyboard(isIncrease);
      } else if (_decimalQuantityFocusNode.hasFocus) {
        _handleDecimalQuantityKeyboard(isIncrease);
      } else if (_perKiloQuantityFocusNode.hasFocus ||
          _perKiloTotalPriceFocusNode.hasFocus) {
        _handleQuantitySectionKeyboard(isIncrease);
      } else {
        _pricingOptionsFocusNode.requestFocus();
      }
      return true;
    }

    return false;
  }

  // Add centralized ceiling rounding method for all monetary values
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

  double _ceilRoundQuantity(double value) {
    if (value.isNaN || value.isInfinite) return 0.0;
    if (value < 0) return 0.0;

    // For quantities, use similar precision-safe approach
    final valueStr = value.toStringAsFixed(10);
    final preciseValue = double.parse(valueStr);
    final centiUnits = (preciseValue * 100.0).round();
    final ceiledCentiUnits = ((centiUnits + 99) ~/ 100) * 100;

    return ceiledCentiUnits / 100.0;
  }

  double _customRoundValue(double value) {
    // Use ceiling rounding for consistency
    return _ceilRoundPrice(value);
  }

  // Gantang conversion helpers
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
          // Calculate total with proper precision handling
          final totalPriceStr = (quantity * unitPrice).toStringAsFixed(10);
          final preciseTotalPrice = double.parse(totalPriceStr);
          final ceiledTotalPrice = _ceilRoundPrice(preciseTotalPrice);

          _perKiloTotalPriceController.text =
              ceiledTotalPrice.toStringAsFixed(2);
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
          // Calculate quantity with proper precision handling - NO CEILING on quantity when dividing
          // The user entered a specific total price, so we calculate the exact quantity needed
          final calculatedQuantityStr =
              (totalPrice / unitPrice).toStringAsFixed(10);
          final preciseCalculatedQuantity = double.parse(calculatedQuantityStr);

          // For quantity calculation from total price, use the exact calculated quantity
          // Don't apply ceiling rounding here as we want the exact quantity that matches the price
          final exactQuantity = preciseCalculatedQuantity;

          // Update the per kilo quantity controller
          _perKiloQuantityController.text = exactQuantity.toStringAsFixed(2);

          // Most importantly: Update the whole and decimal quantity displays
          _setQuantityFromKg(exactQuantity);
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
        final double totalPrice = quantity * unitPrice;
        final double ceiledTotalPrice = _ceilRoundPrice(totalPrice);
        _perKiloTotalPriceController.text = ceiledTotalPrice.toStringAsFixed(2);
      }
    });
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
      double totalPrice = quantity * unitPrice;

      // Fix precision in initial calculation
      final preciseTotalPrice = double.parse(totalPrice.toStringAsFixed(6));
      final double ceiledTotalPrice = _ceilRoundPrice(preciseTotalPrice);

      _perKiloTotalPriceController.text = ceiledTotalPrice.toStringAsFixed(2);
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

      // Update total price based on kg quantity with ceiling rounding
      if (widget.product.perKiloPrice != null && kgQuantity > 0) {
        final double unitPrice = widget.product.perKiloPrice!.price;
        final totalPriceStr = (kgQuantity * unitPrice).toStringAsFixed(10);
        final preciseTotalPrice = double.parse(totalPriceStr);
        final ceiledTotalPrice = _ceilRoundPrice(preciseTotalPrice);

        _perKiloTotalPriceController.text = ceiledTotalPrice.toStringAsFixed(2);
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
    } else {
      setState(() {
        _decimalQuantityController.text = newValue.toString().padLeft(2, '0');
      });
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

  void _cycleFocus(bool isRightArrow) {
    final focusNodes = [
      _pricingOptionsFocusNode,
      _quantitySectionFocusNode,
      if (_isPerKiloSelected) _decimalQuantityFocusNode,
      _discountSectionFocusNode,
    ];

    int currentIndex = -1;
    for (int i = 0; i < focusNodes.length; i++) {
      if (focusNodes[i].hasFocus) {
        currentIndex = i;
        break;
      }
    }

    int nextIndex;
    if (currentIndex == -1) {
      nextIndex = 0;
    } else {
      if (isRightArrow) {
        nextIndex = (currentIndex + 1) % focusNodes.length;
      } else {
        nextIndex = (currentIndex - 1 + focusNodes.length) % focusNodes.length;
      }
    }

    focusNodes[nextIndex].requestFocus();
  }

  void _handlePricingOptionsKeyboard(bool isRightArrow) {
    final hasPerKilo = widget.product.perKiloPrice != null;
    final hasSackPrices = widget.product.sackPrice.isNotEmpty;

    if (!hasPerKilo && !hasSackPrices) return;

    // Create list of available options
    List<String> availableOptions = [];
    if (hasPerKilo) availableOptions.add('per_kilo');
    for (final sack in widget.product.sackPrice) {
      availableOptions.add(sack.id);
    }

    if (availableOptions.isEmpty) return;

    // Find current selection index
    int currentIndex = -1;
    if (_isPerKiloSelected) {
      currentIndex = availableOptions.indexOf('per_kilo');
    } else if (_selectedSackPriceId != null) {
      currentIndex = availableOptions.indexOf(_selectedSackPriceId!);
    }

    // Calculate next index
    int nextIndex;
    if (currentIndex == -1) {
      nextIndex = 0;
    } else {
      if (isRightArrow) {
        nextIndex = (currentIndex + 1) % availableOptions.length;
      } else {
        nextIndex = (currentIndex - 1 + availableOptions.length) %
            availableOptions.length;
      }
    }

    // Apply selection
    final selectedOption = availableOptions[nextIndex];
    if (selectedOption == 'per_kilo') {
      _selectPerKilo();
    } else {
      _selectSackPrice(selectedOption);
    }
  }

  void _handleQuantitySectionKeyboard(bool isIncrease) {
    if (isIncrease) {
      if (_selectedSackPriceId != null) {
        _increaseQuantity();
      } else if (_isPerKiloSelected) {
        _increaseWholeQuantity();
      }
    } else {
      if (_selectedSackPriceId != null) {
        _decreaseQuantity();
      } else if (_isPerKiloSelected) {
        _decreaseWholeQuantity();
      }
    }
  }

  void _handleDecimalQuantityKeyboard(bool isIncrease) {
    if (isIncrease) {
      _increaseDecimalQuantity();
    } else {
      _decreaseDecimalQuantity();
    }
  }

  void _cycleFocusVertical(bool isUpArrow) {
    final focusNodes = [
      _pricingOptionsFocusNode,
      _quantitySectionFocusNode,
      if (_isPerKiloSelected) _decimalQuantityFocusNode,
      _discountSectionFocusNode,
    ];

    int currentIndex = -1;
    for (int i = 0; i < focusNodes.length; i++) {
      if (focusNodes[i].hasFocus) {
        currentIndex = i;
        break;
      }
    }

    int nextIndex;
    if (currentIndex == -1) {
      nextIndex = 0;
    } else {
      if (isUpArrow) {
        nextIndex = (currentIndex - 1 + focusNodes.length) % focusNodes.length;
      } else {
        nextIndex = (currentIndex + 1) % focusNodes.length;
      }
    }

    focusNodes[nextIndex].requestFocus();
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

      final unitPrice =
          _isSpecialPrice ? sackPrice.specialPrice!.price : sackPrice.price;

      // For discounted items, ceil the discount price first
      final finalDiscountedPrice = _isDiscounted
          ? double.tryParse(_discountedPriceController.text.replaceAll(',', ''))
              ?.let((val) => _ceilRoundPrice(val))
          : null;

      // Use final discount price or original price
      final effectiveUnitPrice = finalDiscountedPrice ?? unitPrice;
      final ceiledUnitPrice = _ceilRoundPrice(effectiveUnitPrice);

      debugPrint('=== SACK PRICE CALCULATION ===');
      debugPrint('Original unit price: ${unitPrice.toStringAsFixed(4)}');
      debugPrint('Quantity: ${quantity.toStringAsFixed(4)}');
      debugPrint('Is discounted: $_isDiscounted');
      debugPrint(
          'Discount price input: ${finalDiscountedPrice?.toStringAsFixed(4) ?? "none"}');
      debugPrint(
          'Effective unit price: ${effectiveUnitPrice.toStringAsFixed(4)}');
      debugPrint('Ceiling unit price: ${ceiledUnitPrice.toStringAsFixed(4)}');
      debugPrint('Total: ${(ceiledUnitPrice * quantity).toStringAsFixed(4)}');

      productDto = ProductDto(
        id: widget.product.id,
        name: widget.product.name,
        isGantang: false,
        isSpecialPrice: _isSpecialPrice,
        sackPrice: SackPriceDto(
          id: sackPrice.id,
          price: ceiledUnitPrice,
          quantity: quantity,
          type: sackPrice.type,
        ),
        isDiscounted: _isDiscounted,
        discountedPrice: finalDiscountedPrice,
      );
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final perKiloPrice = widget.product.perKiloPrice!;
      final kgQuantity = _getCurrentQuantityInKg();

      // For discounted items, ceil the discount price first
      final finalDiscountedPrice = _isDiscounted
          ? double.tryParse(_discountedPriceController.text.replaceAll(',', ''))
              ?.let((val) => _ceilRoundPrice(val))
          : null;

      // Use final discount price or original price
      final effectiveUnitPrice = finalDiscountedPrice ?? perKiloPrice.price;
      final ceiledUnitPrice = _ceilRoundPrice(effectiveUnitPrice);

      debugPrint('=== PER KILO CALCULATION ===');
      debugPrint(
          'Original unit price: ${perKiloPrice.price.toStringAsFixed(4)}');
      debugPrint('Quantity: ${kgQuantity.toStringAsFixed(4)}');
      debugPrint('Is discounted: $_isDiscounted');
      debugPrint(
          'Discount price input: ${finalDiscountedPrice?.toStringAsFixed(4) ?? "none"}');
      debugPrint(
          'Effective unit price: ${effectiveUnitPrice.toStringAsFixed(4)}');
      debugPrint('Ceiling unit price: ${ceiledUnitPrice.toStringAsFixed(4)}');
      debugPrint('Total: ${(ceiledUnitPrice * kgQuantity).toStringAsFixed(4)}');
      debugPrint('Is Gantang: $_isGantangMode');

      productDto = ProductDto(
        id: widget.product.id,
        name: widget.product.name,
        isGantang: _isGantangMode,
        isSpecialPrice: false,
        perKiloPrice: PerKiloPriceDto(
          id: perKiloPrice.id,
          price: ceiledUnitPrice,
          quantity: kgQuantity,
        ),
        isDiscounted: _isDiscounted,
        discountedPrice: finalDiscountedPrice,
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
      body: Focus(
        autofocus: true,
        child: Container(
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
                    focusNode: _pricingOptionsFocusNode,
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
                          focusNode: _quantitySectionFocusNode,
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
                                focusNode: _decimalQuantityFocusNode,
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
                              focusNode: _discountSectionFocusNode,
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
