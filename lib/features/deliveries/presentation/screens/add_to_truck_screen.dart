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
  }

  void _selectSackPrice(String id) {
    setState(() {
      _selectedSackPriceId = id;
      _isPerKiloSelected = false;
      _quantity = 1;
    });
  }

  void _selectPerKilo() {
    setState(() {
      _selectedSackPriceId = null;
      _isPerKiloSelected = true;
      _quantity = 1.0;
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

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('${widget.product.name} added to truck')
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
        title: const Text('Add to Truck'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Image
                Card(
                  elevation: 3,
                  shadowColor: AppColors.primary.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'product-${widget.product.id}',
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.local_shipping_outlined,
                              size: 30,
                              color: AppColors.primary,
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Product ID: ${widget.product.id}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Pricing Options Title
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(Icons.local_shipping,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Loading Options',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
                              ),
                            ),
                            if (widget.product.perKiloPrice != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.yellow.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  'NOTE: Per Kilogram will be loaded into Kahon.',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 10,
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

                // Combined Pricing Options Section
                Card(
                  elevation: 2,
                  shadowColor: AppColors.primary.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Wrap options in a horizontal grid
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            // Per Kilo Price option (if available)
                            if (widget.product.perKiloPrice != null)
                              SizedBox(
                                width: (MediaQuery.of(context).size.width -
                                        24 -
                                        24 -
                                        8) /
                                    2,
                                child: InkWell(
                                  onTap: _selectPerKilo,
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _isPerKiloSelected
                                          ? AppColors.primary.withOpacity(0.15)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: _isPerKiloSelected
                                            ? AppColors.primary
                                            : Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Per Kilogram',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Radio(
                                              value: true,
                                              groupValue: _isPerKiloSelected,
                                              onChanged: (_) =>
                                                  _selectPerKilo(),
                                              activeColor: AppColors.primary,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Custom weight',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            // Sack Prices as cards
                            ...widget.product.sackPrice.map((sackPrice) {
                              final isSelected =
                                  _selectedSackPriceId == sackPrice.id;
                              return SizedBox(
                                width: (MediaQuery.of(context).size.width -
                                        24 -
                                        24 -
                                        8) /
                                    2,
                                child: InkWell(
                                  onTap: () => _selectSackPrice(sackPrice.id),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withOpacity(0.15)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                parseSackType(sackPrice.type),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Radio(
                                              value: sackPrice.id,
                                              groupValue: _selectedSackPriceId,
                                              onChanged: (_) =>
                                                  _selectSackPrice(
                                                      sackPrice.id),
                                              activeColor: AppColors.primary,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Sack Type',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Quantity Input
                Container(
                  margin: const EdgeInsets.only(left: 4, bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.scale, color: AppColors.primary, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Quantity',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 2,
                  shadowColor: AppColors.primary.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          key: ValueKey(
                              '${_selectedSackPriceId ?? 'kilo'}_$_quantity'),
                          initialValue: _quantity.toString(),
                          keyboardType: _selectedSackPriceId != null
                              ? TextInputType.number
                              : const TextInputType.numberWithOptions(
                                  decimal: true),
                          inputFormatters: _selectedSackPriceId != null
                              ? [FilteringTextInputFormatter.digitsOnly]
                              : [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}')),
                                ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppColors.primary.withOpacity(0.7)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 10.0),
                            hintText: 'Enter quantity',
                            labelText: 'Quantity',
                            labelStyle: TextStyle(
                                color: AppColors.primary, fontSize: 14),
                            suffixIcon: Container(
                              margin: const EdgeInsets.only(right: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.remove,
                                          color: AppColors.primary, size: 20),
                                      onPressed: _decreaseQuantity,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.add,
                                          color: AppColors.primary, size: 20),
                                      onPressed: _increaseQuantity,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a quantity';
                            }

                            if (_selectedSackPriceId != null) {
                              // Validate for sack price (integers only)
                              final qty = int.tryParse(value);
                              if (qty == null || qty <= 0) {
                                return 'Please enter a valid quantity';
                              }
                            } else {
                              // Validate for per kilo price (decimals allowed)
                              final qty = double.tryParse(value);
                              if (qty == null || qty <= 0) {
                                return 'Please enter a valid quantity';
                              }
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (_selectedSackPriceId != null) {
                              // For sack price, use integer
                              final qty = int.tryParse(value);
                              if (qty != null && qty > 0) {
                                setState(() {
                                  _quantity = qty;
                                });
                              }
                            } else {
                              // For per kilo price, use double
                              final qty = double.tryParse(value);
                              if (qty != null && qty > 0) {
                                setState(() {
                                  _quantity = qty;
                                });
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _selectedSackPriceId != null
                              ? 'Enter whole numbers only'
                              : 'Decimal numbers allowed (e.g., 1.5 kg)',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Add to Truck Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _addToTruck,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping_outlined, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'Add to Truck',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
