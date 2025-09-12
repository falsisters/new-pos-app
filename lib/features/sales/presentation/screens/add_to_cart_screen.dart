// ignore_for_file: unused_local_variable, unused_field

import 'package:decimal/decimal.dart';
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
  static final Decimal gantangToKgRatio = Decimal.parse('2.25');

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
    _perKiloQuantityController = TextEditingController(text: '1.00');
    _perKiloTotalPriceController = TextEditingController();
    _wholeQuantityController = TextEditingController(text: '1');
    _decimalQuantityController = TextEditingController(text: '0.00');
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
      final isIncrease = event.logicalKey == LogicalKeyboardKey.keyD;

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

  // Gantang conversion helpers
  Decimal _convertGantangToKg(Decimal gantangValue) {
    return gantangValue * gantangToKgRatio;
  }

  Decimal _convertKgToGantang(Decimal kgValue) {
    return (kgValue / gantangToKgRatio).toDecimal(scaleOnInfinitePrecision: 3);
  }

  Decimal _getCurrentQuantityInKg() {
    final wholeValue = int.tryParse(_wholeQuantityController.text) ?? 0;
    final decimalValue =
        double.tryParse(_decimalQuantityController.text) ?? 0.0;

    // Combine whole and decimal parts
    final displayQuantity =
        Decimal.fromInt(wholeValue) + Decimal.parse(decimalValue.toString());

    return _isGantangMode
        ? _convertGantangToKg(displayQuantity)
        : displayQuantity;
  }

  void _setQuantityFromKg(Decimal kgQuantity) {
    final displayQuantity =
        _isGantangMode ? _convertKgToGantang(kgQuantity) : kgQuantity;
    final wholePart = displayQuantity.floor();
    final fractionalPart = displayQuantity - wholePart;

    _wholeQuantityController.text = wholePart.toBigInt().toString();
    _decimalQuantityController.text = fractionalPart.toStringAsFixed(2);
    _perKiloQuantityController.text = kgQuantity.toStringAsFixed(2);
  }

  void _updatePerKiloTotalPriceFromQuantity() {
    if (_isUpdatingPriceAndQuantityInternally) return;

    // Only update price when quantity is being modified, NOT when total price field has focus
    if ((_perKiloQuantityFocusNode.hasFocus ||
            _quantitySectionFocusNode.hasFocus ||
            _decimalQuantityFocusNode.hasFocus) &&
        !_perKiloTotalPriceFocusNode.hasFocus) {
      _isUpdatingPriceAndQuantityInternally = true;
      final String currentQuantityText = _perKiloQuantityController.text;
      final kgQuantity = Decimal.tryParse(currentQuantityText) ?? Decimal.zero;

      if (widget.product.perKiloPrice != null) {
        final perKgPrice =
            Decimal.parse(widget.product.perKiloPrice!.price.toString());

        if (perKgPrice <= Decimal.zero) {
          _perKiloTotalPriceController.clear();
        } else if (kgQuantity > Decimal.zero) {
          final totalPrice =
              _calculateUnifiedTotalPrice(perKgPrice, kgQuantity);
          _perKiloTotalPriceController.text = totalPrice.toStringAsFixed(2);
        } else {
          if (currentQuantityText.isEmpty) {
            _perKiloTotalPriceController.clear();
          }
        }
      }
      _isUpdatingPriceAndQuantityInternally = false;
    }
  }

  void _updatePerKiloQuantityFromTotalPrice() {
    if (_isUpdatingPriceAndQuantityInternally) return;

    // Update quantity when total price is being modified OR when neither field has focus
    if (_perKiloTotalPriceFocusNode.hasFocus ||
        (!_perKiloQuantityFocusNode.hasFocus &&
            !_perKiloTotalPriceFocusNode.hasFocus &&
            !_quantitySectionFocusNode.hasFocus &&
            !_decimalQuantityFocusNode.hasFocus)) {
      _isUpdatingPriceAndQuantityInternally = true;
      final String currentTotalPriceText = _perKiloTotalPriceController.text;
      final totalPrice =
          Decimal.tryParse(currentTotalPriceText) ?? Decimal.zero;

      if (widget.product.perKiloPrice != null) {
        final perKgPrice =
            Decimal.parse(widget.product.perKiloPrice!.price.toString());

        if (perKgPrice <= Decimal.zero) {
          _perKiloQuantityController.clear();
          _wholeQuantityController.clear();
          _decimalQuantityController.text = '00';
        } else if (totalPrice >= Decimal.zero) {
          // Use gantang-adjusted price when in gantang mode for calculation
          final effectivePrice = _isGantangMode
              ? _getGantangAdjustedPrice(perKgPrice)
              : perKgPrice;

          // Calculate display quantity based on effective price
          final calculatedDisplayQuantity = totalPrice / effectivePrice;

          // Convert to decimal with proper scale handling for infinite precision
          final displayQuantityDecimal =
              calculatedDisplayQuantity.toDecimal(scaleOnInfinitePrecision: 3);

          // Calculate kg quantity for internal tracking
          final kgQuantity = _isGantangMode
              ? _convertGantangToKg(displayQuantityDecimal)
              : displayQuantityDecimal;

          // Update the per kilo quantity controller (always in kg)
          _perKiloQuantityController.text = kgQuantity.toStringAsFixed(2);

          // Update the display quantities
          final wholePart = displayQuantityDecimal.floor();
          final fractionalPart = displayQuantityDecimal - wholePart;
          _wholeQuantityController.text = wholePart.toBigInt().toString();
          _decimalQuantityController.text = fractionalPart.toStringAsFixed(2);
        } else {
          if (currentTotalPriceText.isEmpty) {
            _perKiloQuantityController.clear();
            _wholeQuantityController.clear();
            _decimalQuantityController.text = '00';
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
      _setQuantityFromKg(Decimal.one);
      if (widget.product.perKiloPrice != null) {
        final perKgPrice =
            Decimal.parse(widget.product.perKiloPrice!.price.toString());
        final kgQuantity = Decimal.one;
        final totalPrice = _calculateUnifiedTotalPrice(perKgPrice, kgQuantity);
        _perKiloTotalPriceController.text = totalPrice.toStringAsFixed(2);
      }
    });
  }

  bool _hasStock() {
    if (_selectedSackPriceId != null) {
      final sackPrice = widget.product.sackPrice
          .firstWhere((sp) => sp.id == _selectedSackPriceId);
      return sackPrice.stock > Decimal.zero;
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      return widget.product.perKiloPrice!.stock > Decimal.zero;
    }
    return false;
  }

  Decimal _getAvailableStock() {
    if (_selectedSackPriceId != null) {
      final sackPrice = widget.product.sackPrice
          .firstWhere((sp) => sp.id == _selectedSackPriceId);
      return sackPrice.stock;
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      return widget.product.perKiloPrice!.stock;
    }
    return Decimal.zero;
  }

  void _calculateInitialPerKiloTotalPrice() {
    if (widget.product.perKiloPrice != null) {
      final perKgPrice =
          Decimal.parse(widget.product.perKiloPrice!.price.toString());
      final kgQuantity = Decimal.one;
      final totalPrice = _calculateUnifiedTotalPrice(perKgPrice, kgQuantity);
      _perKiloTotalPriceController.text = totalPrice.toStringAsFixed(2);
    }
  }

  void _updateCombinedQuantityAndTotal() {
    if (!_isUpdatingPriceAndQuantityInternally) {
      final wholeValue = int.tryParse(_wholeQuantityController.text) ?? 0;
      final decimalValue =
          double.tryParse(_decimalQuantityController.text) ?? 0.0;

      // Combine whole and decimal parts
      final displayQuantity =
          Decimal.fromInt(wholeValue) + Decimal.parse(decimalValue.toString());

      // Convert to kg if in gantang mode
      final kgQuantity = _isGantangMode
          ? _convertGantangToKg(displayQuantity)
          : displayQuantity;

      _isUpdatingPriceAndQuantityInternally = true;
      _perKiloQuantityController.text = kgQuantity.toStringAsFixed(2);

      // Update total price using unified calculation
      if (widget.product.perKiloPrice != null && kgQuantity > Decimal.zero) {
        final perKgPrice =
            Decimal.parse(widget.product.perKiloPrice!.price.toString());
        final totalPrice = _calculateUnifiedTotalPrice(perKgPrice, kgQuantity);
        _perKiloTotalPriceController.text = totalPrice.toStringAsFixed(2);
      } else if (kgQuantity == Decimal.zero) {
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
      final decimalValue =
          double.tryParse(_decimalQuantityController.text) ?? 0.0;
      final displayQuantity =
          Decimal.fromInt(newValue) + Decimal.parse(decimalValue.toString());
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
        if (Decimal.fromInt(currentQuantity) < sackPrice.stock) {
          currentQuantity++;
          _sackQuantityController.text = currentQuantity.toString();
        }
      } else if (_isPerKiloSelected) {
        double currentQuantity =
            double.tryParse(_perKiloQuantityController.text) ?? 1.0;
        double newQuantity = currentQuantity + 1.0; // Increment by 1kg
        if (Decimal.parse(newQuantity.toString()) <=
            widget.product.perKiloPrice!.stock) {
          _setQuantityFromKg(Decimal.parse(newQuantity.toString()));
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
        if (currentQuantity > 1.0) {
          double newQuantity = currentQuantity - 1.0; // Decrement by 1kg
          _setQuantityFromKg(Decimal.parse(newQuantity.toString()));
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
    final currentValue =
        double.tryParse(_decimalQuantityController.text) ?? 0.0;
    final newValue = (currentValue + 0.05).clamp(0.0, 0.99);

    // Check stock limit in kg
    if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final wholeValue = int.tryParse(_wholeQuantityController.text) ?? 0;
      final displayQuantity =
          Decimal.fromInt(wholeValue) + Decimal.parse(newValue.toString());
      final kgQuantity = _isGantangMode
          ? _convertGantangToKg(displayQuantity)
          : displayQuantity;

      if (kgQuantity <= widget.product.perKiloPrice!.stock) {
        setState(() {
          _decimalQuantityController.text = newValue.toStringAsFixed(2);
        });
      }
    } else {
      setState(() {
        _decimalQuantityController.text = newValue.toStringAsFixed(2);
      });
    }
  }

  void _decreaseDecimalQuantity() {
    final currentValue =
        double.tryParse(_decimalQuantityController.text) ?? 0.0;
    final newValue = (currentValue - 0.05).clamp(0.0, 0.99);
    setState(() {
      _decimalQuantityController.text = newValue.toStringAsFixed(2);
    });
  }

  void _setQuickQuantity(double quantity) {
    setState(() {
      if (_selectedSackPriceId != null) {
        final sackPrice = widget.product.sackPrice
            .firstWhere((sp) => sp.id == _selectedSackPriceId);
        int intQuantity = quantity.toInt();
        if (Decimal.fromInt(intQuantity) <= sackPrice.stock) {
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
        final displayQuantity = Decimal.parse(quantity.toString());
        final kgQuantity = _isGantangMode
            ? _convertGantangToKg(displayQuantity)
            : displayQuantity;

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

  // Unified method for calculating total price based on kg quantity and display mode
  Decimal _calculateUnifiedTotalPrice(Decimal perKgPrice, Decimal kgQuantity) {
    if (_isGantangMode) {
      // Calculate gantang unit price with custom rounding rule
      final gantangUnitPrice = _getGantangAdjustedPrice(perKgPrice);
      // Convert kg quantity to gantang quantity for multiplication
      final gantangQuantity = _convertKgToGantang(kgQuantity);
      // Multiply rounded gantang unit price by gantang quantity
      final rawTotalPrice = gantangUnitPrice * gantangQuantity;

      // Apply custom rounding rule to the total: if decimal < 0.1, truncate; else round up
      final wholePart = rawTotalPrice.floor();
      final fractionalPart = rawTotalPrice - wholePart;

      Decimal finalTotalPrice;
      if (fractionalPart < Decimal.parse('0.1')) {
        // Truncate - keep only whole number
        finalTotalPrice = wholePart;
      } else {
        // Round up to next whole number
        finalTotalPrice = wholePart + Decimal.one;
      }

      debugPrint('=== GANTANG TOTAL CALCULATION ===');
      debugPrint('Gantang Unit Price: ${gantangUnitPrice.toStringAsFixed(2)}');
      debugPrint('Gantang Quantity: ${gantangQuantity.toStringAsFixed(4)}');
      debugPrint('Raw Total: ${rawTotalPrice.toStringAsFixed(4)}');
      debugPrint('Fractional Part: ${fractionalPart.toStringAsFixed(4)}');
      debugPrint('Final Total: ${finalTotalPrice.toStringAsFixed(2)}');

      return finalTotalPrice;
    } else {
      // For kg mode, apply custom rounding rule to the total
      final totalPrice = kgQuantity * perKgPrice;

      // Apply custom rounding rule: if decimal < 0.1, truncate; else round up
      final wholePart = totalPrice.floor();
      final fractionalPart = totalPrice - wholePart;

      Decimal roundedTotal;
      if (fractionalPart < Decimal.parse('0.1')) {
        // Truncate - keep only whole number
        roundedTotal = wholePart;
      } else {
        // Round up to next whole number
        roundedTotal = wholePart + Decimal.one;
      }

      debugPrint('=== KG TOTAL CALCULATION ===');
      debugPrint('Raw Total: ${totalPrice.toStringAsFixed(4)}');
      debugPrint('Fractional Part: ${fractionalPart.toStringAsFixed(4)}');
      debugPrint('Rounded Total: ${roundedTotal.toStringAsFixed(2)}');

      return roundedTotal;
    }
  }

  // Helper method for consistent price calculation with ceiling rounding (legacy - for non-gantang)
  Decimal _calculateTotalPrice(Decimal unitPrice, Decimal quantity) {
    if (_isGantangMode) {
      // For gantang mode, use no additional rounding since unitPrice is already rounded
      return unitPrice * quantity;
    } else {
      // For kg mode, apply custom rounding rule to the total
      final totalPrice = quantity * unitPrice;

      // Apply custom rounding rule: if decimal < 0.1, truncate; else round up
      final wholePart = totalPrice.floor();
      final fractionalPart = totalPrice - wholePart;

      if (fractionalPart < Decimal.parse('0.1')) {
        // Truncate - keep only whole number
        return wholePart;
      } else {
        // Round up to next whole number
        return wholePart + Decimal.one;
      }
    }
  }

  // Helper method to get gantang-adjusted unit price with custom rounding rule
  Decimal _getGantangAdjustedPrice(Decimal perKgPrice) {
    final gantangPrice = perKgPrice * gantangToKgRatio;

    // Apply custom rounding rule: if decimal < 0.1, truncate; else round up
    final wholePart = gantangPrice.floor();
    final fractionalPart = gantangPrice - wholePart;

    Decimal roundedPrice;
    if (fractionalPart < Decimal.parse('0.1')) {
      // Truncate - keep only whole number
      roundedPrice = wholePart;
    } else {
      // Round up to next whole number
      roundedPrice = wholePart + Decimal.one;
    }

    debugPrint('=== GANTANG PRICE CALCULATION ===');
    debugPrint('Per KG Price: ${perKgPrice.toStringAsFixed(2)}');
    debugPrint('Gantang Price (×2.25): ${gantangPrice.toStringAsFixed(4)}');
    debugPrint('Fractional Part: ${fractionalPart.toStringAsFixed(4)}');
    debugPrint('Rounded Gantang Price: ${roundedPrice.toStringAsFixed(2)}');

    return roundedPrice;
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
      final quantity =
          Decimal.tryParse(_sackQuantityController.text) ?? Decimal.one;

      final unitPrice = Decimal.parse(
          (_isSpecialPrice ? sackPrice.specialPrice!.price : sackPrice.price)
              .toString());

      // For discounted items, use the discount price without additional rounding
      final finalDiscountedPrice = _isDiscounted
          ? Decimal.tryParse(
              _discountedPriceController.text.replaceAll(',', ''))
          : null;

      // Use the original unit price for calculation - no pre-rounding
      final effectiveUnitPrice = finalDiscountedPrice ?? unitPrice;

      debugPrint('=== SACK PRICE CALCULATION ===');
      debugPrint('Original unit price: ${unitPrice.toStringAsFixed(4)}');
      debugPrint('Quantity: ${quantity.toStringAsFixed(4)}');
      debugPrint('Is discounted: $_isDiscounted');
      debugPrint(
          'Discount price input: ${finalDiscountedPrice?.toStringAsFixed(4) ?? "none"}');
      debugPrint(
          'Effective unit price: ${effectiveUnitPrice.toStringAsFixed(4)}');
      debugPrint(
          'Total (no rounding): ${(effectiveUnitPrice * quantity).toStringAsFixed(4)}');

      // Calculate total for sack items
      final totalPrice = finalDiscountedPrice != null
          ? finalDiscountedPrice * quantity
          : effectiveUnitPrice * quantity;

      productDto = ProductDto(
        id: widget.product.id,
        name: widget.product.name,
        price: totalPrice, // Store the calculated total
        isGantang: _isGantangMode,
        isSpecialPrice: _isSpecialPrice,
        sackPrice: SackPriceDto(
          id: sackPrice.id,
          price: Decimal.zero, // Dummy value - server ignores this
          quantity: quantity,
          type: sackPrice.type,
        ),
        isDiscounted: _isDiscounted,
        discountedPrice: finalDiscountedPrice,
      );
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final perKiloPrice = widget.product.perKiloPrice!;
      final kgQuantity = _getCurrentQuantityInKg();

      // For discounted items, use the discount price directly
      final finalDiscountedPrice = _isDiscounted
          ? Decimal.tryParse(
              _discountedPriceController.text.replaceAll(',', ''))
          : null;

      // Use the exact total price from the text field (no recalculation)
      final totalPriceFromField = Decimal.tryParse(
              _perKiloTotalPriceController.text.replaceAll(',', '')) ??
          Decimal.zero;

      // Use appropriate pricing based on mode
      final baseUnitPrice = Decimal.parse(perKiloPrice.price.toString());

      Decimal effectiveUnitPrice;
      Decimal effectiveQuantity;

      if (finalDiscountedPrice != null) {
        // For discounted items, use the discount price as the total price
        if (_isGantangMode) {
          effectiveQuantity = _convertKgToGantang(kgQuantity);
        } else {
          effectiveQuantity = kgQuantity;
        }
        effectiveUnitPrice =
            finalDiscountedPrice; // Store discount price as total
      } else {
        // For non-discounted items, use exact total from field as price
        if (_isGantangMode) {
          effectiveQuantity = _convertKgToGantang(kgQuantity);
        } else {
          effectiveQuantity = kgQuantity;
        }
        // Use the exact total price from field as the "price"
        effectiveUnitPrice = totalPriceFromField;
      }

      debugPrint('=== PER KILO CALCULATION ===');
      debugPrint('Original per-kg price: ${baseUnitPrice.toStringAsFixed(4)}');
      debugPrint('KG Quantity: ${kgQuantity.toStringAsFixed(4)}');
      debugPrint('Total from field: ${totalPriceFromField.toStringAsFixed(4)}');
      debugPrint('Is discounted: $_isDiscounted');
      debugPrint(
          'Discount price input: ${finalDiscountedPrice?.toStringAsFixed(4) ?? "none"}');
      debugPrint('Storing as price: ${effectiveUnitPrice.toStringAsFixed(4)}');
      debugPrint(
          'Storing as quantity: ${effectiveQuantity.toStringAsFixed(4)}');
      debugPrint('Is Gantang: $_isGantangMode');

      productDto = ProductDto(
        id: widget.product.id,
        name: widget.product.name,
        price: finalDiscountedPrice ??
            totalPriceFromField, // Store the exact total from field
        isGantang: _isGantangMode,
        isSpecialPrice: false,
        perKiloPrice: PerKiloPriceDto(
          id: perKiloPrice.id,
          quantity:
              effectiveQuantity, // Store the actual quantity (gantang or kg)
          price: Decimal.zero, // Dummy value - server ignores this field
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
    final Decimal availableStock = _getAvailableStock();

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
        title: Text('Add to Cart',
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
                                // Recalculate total with new pricing mode
                                if (widget.product.perKiloPrice != null) {
                                  final unitPrice = Decimal.parse(widget
                                      .product.perKiloPrice!.price
                                      .toString());
                                  final displayQuantity = Decimal.fromInt(
                                          int.tryParse(_wholeQuantityController
                                                  .text) ??
                                              0) +
                                      Decimal.parse((double.tryParse(
                                                  _decimalQuantityController
                                                      .text) ??
                                              0.0)
                                          .toString());
                                  final effectivePrice = _isGantangMode
                                      ? _getGantangAdjustedPrice(unitPrice)
                                      : unitPrice;
                                  final totalPrice = _calculateTotalPrice(
                                      effectivePrice, displayQuantity);
                                  _perKiloTotalPriceController.text =
                                      totalPrice.toStringAsFixed(2);
                                }
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
