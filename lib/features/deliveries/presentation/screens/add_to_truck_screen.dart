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

  // State management variables
  dynamic _quantity = 1;
  String? _selectedSackPriceId;
  bool _isPerKiloSelected = false;

  @override
  void initState() {
    super.initState();
    // Default to per kilo if available and no sack prices
    if (widget.product.sackPrice.isEmpty &&
        widget.product.perKiloPrice != null) {
      _isPerKiloSelected = true;
    } else if (widget.product.sackPrice.isNotEmpty) {
      // Default to the first sack price if available
      _selectedSackPriceId = widget.product.sackPrice.first.id;
      _isPerKiloSelected = false;
    }

    // Initialize the controller with the initial quantity
    _quantityController.text = _quantity.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
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
        _quantity = (_quantity as int) + 1;
      } else {
        // Per kilo price, allow decimal
        _quantity = ((_quantity as double) * 10 + 1) / 10;
      }
      _quantityController.text = _quantity.toString();
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (_selectedSackPriceId != null) {
        if (_quantity > 1) {
          _quantity = (_quantity as int) - 1;
        }
      } else {
        // Per kilo price, allow decimal
        if (_quantity > 0.1) {
          _quantity = ((_quantity as double) * 10 - 1) / 10;
        }
      }
      _quantityController.text = _quantity.toString();
    });
  }

  void _addToTruck() {
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Icon(Icons.local_shipping_rounded, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(Icons.local_shipping_rounded,
                                          color: AppColors.secondary, size: 20),
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
                                        color:
                                            AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping_outlined, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Add to Truck',
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
    return Column(
      children: [
        // Quantity Input Field
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Manual Input Field
                TextFormField(
                  controller: _quantityController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.primary.withOpacity(0.05),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    suffixText: _isPerKiloSelected ? 'kg' : 'sacks',
                    suffixStyle: TextStyle(
                      color: AppColors.primary.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter quantity';
                    }
                    final qty = double.tryParse(value);
                    if (qty == null || qty <= 0) {
                      return 'Invalid quantity';
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

                const SizedBox(height: 16),

                // Quantity Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuantityButton(
                      icon: Icons.remove_rounded,
                      onPressed: _decreaseQuantity,
                      color: Colors.red,
                    ),
                    _buildQuantityButton(
                      icon: Icons.add_rounded,
                      onPressed: _increaseQuantity,
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            width: 48,
            height: 48,
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}
