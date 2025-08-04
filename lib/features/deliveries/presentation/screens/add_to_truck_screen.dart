// ignore_for_file: unused_local_variable, unused_field

import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_per_kilo_price_dto_model.dart';
import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_product_dto_model.dart';
import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_sack_price_dto_model.dart';
import 'package:falsisters_pos_android/features/deliveries/data/providers/delivery_provider.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_sack_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToTruckScreen extends ConsumerStatefulWidget {
  final Product product;

  const AddToTruckScreen({super.key, required this.product});

  @override
  ConsumerState<AddToTruckScreen> createState() => _AddToTruckScreenState();
}

class _AddToTruckScreenState extends ConsumerState<AddToTruckScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final FocusNode _screenFocusNode = FocusNode();

  // State management variables
  dynamic _quantity = 1;
  String? _selectedSackPriceId;
  bool _isPerKiloSelected = false;
  bool _isProcessing = false; // Track processing state

  @override
  void initState() {
    super.initState();
    _initializeDefaultSelection();
    _quantityController.text = _quantity.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _screenFocusNode.dispose();
    super.dispose();
  }

  /// Initialize default selection based on available options
  void _initializeDefaultSelection() {
    if (widget.product.sackPrice.isEmpty &&
        widget.product.perKiloPrice != null) {
      _isPerKiloSelected = true;
    } else if (widget.product.sackPrice.isNotEmpty) {
      _selectedSackPriceId = widget.product.sackPrice.first.id;
      _isPerKiloSelected = false;
    }
  }

  /// Handle hardware keyboard events
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Safety checks to prevent interference from disposed widgets or processing states
    if (!mounted || _isProcessing) {
      debugPrint(
          'Add to Truck - Key event ignored: mounted=$mounted, processing=$_isProcessing');
      return KeyEventResult.ignored;
    }

    // Only handle key down events to prevent double triggering
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
        debugPrint('Add to Truck - Enter pressed, adding to truck');
        _addToTruck();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.escape:
        debugPrint('Add to Truck - Escape pressed, closing screen');
        Navigator.pop(context);
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.equal:
      case LogicalKeyboardKey.numpadAdd:
        _increaseQuantity();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.minus:
      case LogicalKeyboardKey.numpadSubtract:
        _decreaseQuantity();
        return KeyEventResult.handled;

      // Quick quantity shortcuts
      case LogicalKeyboardKey.digit1:
      case LogicalKeyboardKey.numpad1:
        if (HardwareKeyboard.instance.isControlPressed) {
          _setQuickQuantity(_isPerKiloSelected ? 1.0 : 1);
          return KeyEventResult.handled;
        }
        break;

      case LogicalKeyboardKey.digit2:
      case LogicalKeyboardKey.numpad2:
        if (HardwareKeyboard.instance.isControlPressed) {
          _setQuickQuantity(_isPerKiloSelected ? 2.0 : 2);
          return KeyEventResult.handled;
        }
        break;

      case LogicalKeyboardKey.digit5:
      case LogicalKeyboardKey.numpad5:
        if (HardwareKeyboard.instance.isControlPressed) {
          _setQuickQuantity(_isPerKiloSelected ? 5.0 : 5);
          return KeyEventResult.handled;
        }
        break;
    }

    return KeyEventResult.ignored;
  }

  void _selectSackPrice(String id) {
    setState(() {
      _selectedSackPriceId = id;
      _isPerKiloSelected = false;
      _quantity = 1;
      _quantityController.text = _quantity.toString();
    });
  }

  void _selectPerKilo() {
    setState(() {
      _selectedSackPriceId = null;
      _isPerKiloSelected = true;
      _quantity = 1.0;
      _quantityController.text = _quantity.toString();
    });
  }

  void _increaseQuantity() {
    setState(() {
      if (_selectedSackPriceId != null) {
        // Ensure _quantity is int before incrementing
        int qty = 1;
        if (_quantity is int) {
          qty = _quantity as int;
        } else if (_quantity is double) {
          qty = (_quantity as double).toInt();
        }
        _quantity = qty + 1;
      } else {
        // Per kilo price, allow decimal
        double qty = 1.0;
        if (_quantity is double) {
          qty = _quantity as double;
        } else if (_quantity is int) {
          qty = (_quantity as int).toDouble();
        }
        _quantity = ((qty * 10 + 1) / 10);
        _quantity = double.parse(_quantity.toStringAsFixed(2));
      }
      _quantityController.text = _quantity.toString();
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (_selectedSackPriceId != null) {
        int qty = 1;
        if (_quantity is int) {
          qty = _quantity as int;
        } else if (_quantity is double) {
          qty = (_quantity as double).toInt();
        }
        if (qty > 1) {
          _quantity = qty - 1;
        }
      } else {
        double qty = 1.0;
        if (_quantity is double) {
          qty = _quantity as double;
        } else if (_quantity is int) {
          qty = (_quantity as int).toDouble();
        }
        if (qty > 0.1) {
          _quantity = ((qty * 10 - 1) / 10);
          _quantity = double.parse(_quantity.toStringAsFixed(2));
        }
      }
      _quantityController.text = _quantity.toString();
    });
  }

  void _addToTruck() {
    if (_isProcessing || !mounted) {
      debugPrint('Add to Truck - Already processing or not mounted, skipping');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    // Ensure a pricing option is selected
    if (_selectedSackPriceId == null && !_isPerKiloSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Please select a loading option.'),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final deliveryNotifier = ref.read(deliveryProvider.notifier);

      if (_selectedSackPriceId != null) {
        // Using a sack price
        final sackPrice = widget.product.sackPrice
            .firstWhere((sp) => sp.id == _selectedSackPriceId);

        final productDto = DeliveryProductDtoModel(
          id: widget.product.id,
          name: widget.product.name,
          sackPrice: DeliverySackPriceDtoModel(
            id: sackPrice.id,
            quantity: _quantity.toDouble(),
            type: sackPrice.type,
          ),
        );

        deliveryNotifier.addProductToTruck(productDto);
      } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
        // Using per kilo price
        final perKiloPrice = widget.product.perKiloPrice!;

        final productDto = DeliveryProductDtoModel(
          id: widget.product.id,
          name: widget.product.name,
          perKiloPrice: DeliveryPerKiloPriceDtoModel(
            id: perKiloPrice.id,
            quantity: _quantity,
          ),
        );

        deliveryNotifier.addProductToTruck(productDto);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error in _addToTruck: $e');
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding to truck: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _screenFocusNode,
      autofocus: !_isProcessing, // Don't autofocus during processing
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_shipping_rounded, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add to Truck",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, size: 20),
                tooltip: 'Close (Esc)',
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[50]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Product Info Card - Fixed at top
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'product-${widget.product.id}',
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.15),
                                  AppColors.primary.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.1)),
                            ),
                            child: Icon(
                              Icons.inventory_2_rounded,
                              size: 28,
                              color: AppColors.primary,
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'ID: ${widget.product.id.substring(0, 8).toUpperCase()}',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Content - Flexible
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Loading Options - Left side
                        Expanded(
                          flex: 6,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                            Icons.local_shipping_rounded,
                                            color: AppColors.secondary,
                                            size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Loading Options',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.secondary,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: _buildLoadingOptions(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Quantity Section - Right side
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(Icons.numbers_rounded,
                                            color: AppColors.primary, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Quantity',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: _buildQuantitySection(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Add to Truck Button - Fixed at bottom
                Container(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: AppColors.secondary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _addToTruck,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_shipping_outlined, size: 24),
                          SizedBox(width: 12),
                          Text(
                            'Add to Truck (Enter)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
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

  Widget _buildLoadingOptions() {
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
                'No loading options available for this product',
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
          subtitle: 'Custom weight loading',
          color: Colors.green,
        ),
      );
    }

    // Add sack options
    if (hasSackPrices) {
      for (final sack in widget.product.sackPrice) {
        final isSelected = _selectedSackPriceId == sack.id;
        allOptions.add(
          _buildOptionCard(
            isSelected: isSelected,
            onTap: () => _selectSackPrice(sack.id),
            icon: Icons.inventory_rounded,
            title: parseSackType(sack.type),
            subtitle: 'Sack loading option',
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
            padding:
                EdgeInsets.only(bottom: i + 2 < allOptions.length ? 12 : 0),
            child: Row(
              children: [
                Expanded(child: allOptions[i]),
                if (i + 1 < allOptions.length) ...[
                  const SizedBox(width: 12),
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
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
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
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.2) : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : Colors.grey[700],
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected
                          ? color.withOpacity(0.8)
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySection() {
    final hasValidSelection =
        _selectedSackPriceId != null || _isPerKiloSelected;

    return Column(
      children: [
        // Quick Actions for both sack and per kilo quantities
        if (hasValidSelection) ...[
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _selectedSackPriceId != null
                  ? [
                      _buildQuickActionButton('1', 1),
                      const SizedBox(width: 8),
                      _buildQuickActionButton('2', 2),
                      const SizedBox(width: 8),
                      _buildQuickActionButton('5', 5),
                      const SizedBox(width: 8),
                      _buildQuickActionButton('10', 10),
                      const SizedBox(width: 8),
                      _buildQuickActionButton('25', 25),
                      const SizedBox(width: 8),
                      _buildQuickActionButton('50', 50),
                    ]
                  : [
                      _buildQuickActionButton('0.5', 0.5),
                      const SizedBox(width: 8),
                      _buildQuickActionButton('1', 1.0),
                      const SizedBox(width: 8),
                      _buildQuickActionButton('2.5', 2.5),
                      const SizedBox(width: 8),
                      _buildQuickActionButton('5', 5.0),
                      const SizedBox(width: 8),
                      _buildQuickActionButton('10', 10.0),
                      const SizedBox(width: 8),
                      _buildQuickActionButton('25', 25.0),
                    ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Quantity Input Field
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Manual Input Field with enhanced design
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
                    controller: _quantityController,
                    onFieldSubmitted: (_) => _addToTruck(),
                    textAlign: TextAlign.center,
                    enabled: hasValidSelection,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: hasValidSelection
                          ? AppColors.primary
                          : Colors.grey[500],
                    ),
                    keyboardType: _selectedSackPriceId != null
                        ? TextInputType.number
                        : const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: _selectedSackPriceId != null
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'))
                          ],
                    decoration: InputDecoration(
                      labelText: _isPerKiloSelected ? 'Kg' : 'Sacks',
                      labelStyle: TextStyle(
                        color: hasValidSelection
                            ? AppColors.primary
                            : Colors.grey[500],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      filled: true,
                      fillColor:
                          hasValidSelection ? Colors.white : Colors.grey[100],
                      suffixIcon:
                          hasValidSelection ? _buildQuantityControls() : null,
                      helperText: hasValidSelection
                          ? 'Enter the quantity to add to inventory'
                          : 'Please select a loading option first',
                      helperStyle:
                          TextStyle(fontSize: 12, color: Colors.grey[600]),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                    ),
                    validator: (value) {
                      if (!hasValidSelection) {
                        return 'Please select a loading option';
                      }

                      if (value == null || value.isEmpty) {
                        return 'Enter quantity';
                      }

                      final qty = double.tryParse(value);
                      if (qty == null || qty <= 0) {
                        return 'Valid quantity > 0';
                      }

                      if (_selectedSackPriceId != null && qty % 1 != 0) {
                        return 'Sack quantity must be a whole number';
                      }

                      // Set reasonable upper limits for data integrity
                      if (_selectedSackPriceId != null && qty > 10000) {
                        return 'Maximum 10,000 sacks allowed';
                      }

                      if (_isPerKiloSelected && qty > 50000) {
                        return 'Maximum 50,000 kg allowed';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      if (_selectedSackPriceId != null) {
                        final qty = int.tryParse(value);
                        if (qty != null && qty > 0) {
                          _quantity = qty;
                        }
                      } else {
                        final qty = double.tryParse(value);
                        if (qty != null && qty > 0) {
                          _quantity = qty;
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Minus button
        Container(
          height: 32,
          width: 32,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: _quantity > (_isPerKiloSelected ? 0.1 : 1)
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _quantity > (_isPerKiloSelected ? 0.1 : 1)
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.grey[300]!,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _quantity > (_isPerKiloSelected ? 0.1 : 1)
                  ? _decreaseQuantity
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                Icons.remove_rounded,
                color: _quantity > (_isPerKiloSelected ? 0.1 : 1)
                    ? AppColors.primary
                    : Colors.grey[500],
                size: 16,
              ),
            ),
          ),
        ),
        // Plus button
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _increaseQuantity,
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                Icons.add_rounded,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(String label, double quantity) {
    String unit = _selectedSackPriceId != null ? 'sacks' : 'kg';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _setQuickQuantity(quantity),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          width: 60,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setQuickQuantity(double quantity) {
    setState(() {
      _quantity = quantity;
      _quantityController.text = _quantity.toString();
    });
  }
}
