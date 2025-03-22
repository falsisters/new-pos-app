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
  dynamic _quantity = 1;
  String? _selectedSackPriceId;
  String? _selectedSpecialPriceId;
  bool _isPerKiloSelected = false;

  @override
  void initState() {
    super.initState();
    // Default to per kilo if available and no sack prices
    if (widget.product.sackPrice.isEmpty &&
        widget.product.perKiloPrice != null) {
      _isPerKiloSelected = true;
    }
  }

  void _selectSackPrice(String id, {bool isSpecial = false, int? minimumQty}) {
    setState(() {
      _selectedSackPriceId = id;
      _isSpecialPrice = isSpecial;
      _isPerKiloSelected = false;

      if (isSpecial && minimumQty != null) {
        _selectedSpecialPriceId = widget.product.sackPrice
            .firstWhere((sp) => sp.id == id)
            .specialPrice!
            .id;
        _quantity = minimumQty;
      } else {
        _selectedSpecialPriceId = null;
        _quantity = 1;
      }
    });
  }

  void _selectPerKilo() {
    setState(() {
      _selectedSackPriceId = null;
      _selectedSpecialPriceId = null;
      _isSpecialPrice = false;
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
      if (_isSpecialPrice && _selectedSackPriceId != null) {
        final sackPrice = widget.product.sackPrice
            .firstWhere((sp) => sp.id == _selectedSackPriceId);
        if (_quantity > (sackPrice.specialPrice?.minimumQty ?? 1)) {
          _quantity = (_quantity as int) - 1;
        }
      } else if (_selectedSackPriceId != null) {
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

  void _addToCart() {
    if (!_formKey.currentState!.validate()) return;

    final salesNotifier = ref.read(salesProvider.notifier);

    if (_selectedSackPriceId != null) {
      // Using a sack price
      final sackPrice = widget.product.sackPrice
          .firstWhere((sp) => sp.id == _selectedSackPriceId);

      final productDto = ProductDto(
        id: widget.product.id,
        name: widget.product.name,
        isGantang: false,
        isSpecialPrice: _isSpecialPrice,
        sackPrice: SackPriceDto(
          id: sackPrice.id,
          price:
              _isSpecialPrice ? sackPrice.specialPrice!.price : sackPrice.price,
          // Convert int quantity to double for consistency
          quantity: _quantity.toDouble(),
          type: sackPrice.type,
        ),
      );

      salesNotifier.addProductToCart(productDto);
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      // Using per kilo price
      final perKiloPrice = widget.product.perKiloPrice!;

      final productDto = ProductDto(
        id: widget.product.id,
        name: widget.product.name,
        isGantang: false,
        isSpecialPrice: false,
        perKiloPrice: PerKiloPriceDto(
          id: perKiloPrice.id,
          price: perKiloPrice.price,
          quantity: _quantity,
        ),
      );

      salesNotifier.addProductToCart(productDto);
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('${widget.product.name} added to cart')
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
        title: const Text('Add to Cart'),
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
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Image
                Card(
                  elevation: 4,
                  shadowColor: AppColors.primary.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: 'product-${widget.product.id}',
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
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
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Multiple pricing options available',
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
                ),

                const SizedBox(height: 24),

                // Pricing Options Title
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Icon(Icons.payments_outlined, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text(
                        'Pricing Options',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Combined Pricing Options Section
                Card(
                  elevation: 3,
                  shadowColor: AppColors.primary.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Per Kilo Price option (if available)
                        if (widget.product.perKiloPrice != null) ...[
                          Row(
                            children: [
                              Text(
                                'Per Kilo Price',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: _selectPerKilo,
                                child: Container(
                                  width: 130,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _isPerKiloSelected
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                      width: _isPerKiloSelected ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: _isPerKiloSelected
                                        ? AppColors.primaryLight
                                        : Colors.white,
                                    boxShadow: _isPerKiloSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Per Kilo',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _isPerKiloSelected
                                              ? AppColors.primary
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Stock: ${widget.product.perKiloPrice!.stock}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _isPerKiloSelected
                                              ? AppColors.primary
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '₱${widget.product.perKiloPrice!.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: _isPerKiloSelected
                                              ? AppColors.primary
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (widget.product.sackPrice.isNotEmpty)
                            const Divider(height: 24),
                        ],

                        // Sack Prices Section (if available)
                        if (widget.product.sackPrice.isNotEmpty) ...[
                          Text(
                            'Sack Prices',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: widget.product.sackPrice.map((sackPrice) {
                              return Column(
                                children: [
                                  // Regular Sack Price
                                  GestureDetector(
                                    onTap: () => _selectSackPrice(sackPrice.id),
                                    child: Container(
                                      width: 130,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _selectedSackPriceId ==
                                                      sackPrice.id &&
                                                  !_isSpecialPrice
                                              ? AppColors.primary
                                              : Colors.grey.shade300,
                                          width: _selectedSackPriceId ==
                                                      sackPrice.id &&
                                                  !_isSpecialPrice
                                              ? 2
                                              : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        color: _selectedSackPriceId ==
                                                    sackPrice.id &&
                                                !_isSpecialPrice
                                            ? AppColors.primaryLight
                                            : Colors.white,
                                        boxShadow: _selectedSackPriceId ==
                                                    sackPrice.id &&
                                                !_isSpecialPrice
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                )
                                              ]
                                            : null,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            parseSackType(sackPrice.type),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _selectedSackPriceId ==
                                                          sackPrice.id &&
                                                      !_isSpecialPrice
                                                  ? AppColors.primary
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Stock: ${sackPrice.stock}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _selectedSackPriceId ==
                                                          sackPrice.id &&
                                                      !_isSpecialPrice
                                                  ? AppColors.primary
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '₱${sackPrice.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: _selectedSackPriceId ==
                                                          sackPrice.id &&
                                                      !_isSpecialPrice
                                                  ? AppColors.primary
                                                  : Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Regular',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Special Price - if available
                                  if (sackPrice.specialPrice != null) ...[
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () => _selectSackPrice(
                                        sackPrice.id,
                                        isSpecial: true,
                                        minimumQty:
                                            sackPrice.specialPrice!.minimumQty,
                                      ),
                                      child: Container(
                                        width: 130,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: _selectedSackPriceId ==
                                                        sackPrice.id &&
                                                    _isSpecialPrice
                                                ? AppColors.primary
                                                : Colors.grey.shade300,
                                            width: _selectedSackPriceId ==
                                                        sackPrice.id &&
                                                    _isSpecialPrice
                                                ? 2
                                                : 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: _selectedSackPriceId ==
                                                      sackPrice.id &&
                                                  _isSpecialPrice
                                              ? AppColors.primaryLight
                                              : Colors.white,
                                          boxShadow: _selectedSackPriceId ==
                                                      sackPrice.id &&
                                                  _isSpecialPrice
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors.primary
                                                        .withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  )
                                                ]
                                              : null,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  parseSackType(sackPrice.type),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        _selectedSackPriceId ==
                                                                    sackPrice
                                                                        .id &&
                                                                _isSpecialPrice
                                                            ? AppColors.primary
                                                            : Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    'SPECIAL',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.red.shade700,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '₱${sackPrice.specialPrice!.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: _selectedSackPriceId ==
                                                            sackPrice.id &&
                                                        _isSpecialPrice
                                                    ? AppColors.primary
                                                    : Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Min: ${sackPrice.specialPrice!.minimumQty}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Quantity Input
                Container(
                  margin: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.scale, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 3,
                  shadowColor: AppColors.primary.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          key: ValueKey(
                              _quantity), // Force rebuild when quantity model changes
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
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                            hintText: 'Enter quantity',
                            labelText: 'Quantity',
                            labelStyle: TextStyle(color: AppColors.primary),
                            suffixIcon: Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.remove,
                                          color: AppColors.primary),
                                      onPressed: _decreaseQuantity,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.add,
                                          color: AppColors.primary),
                                      onPressed: _increaseQuantity,
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
                              if (_isSpecialPrice) {
                                final sackPrice = widget.product.sackPrice
                                    .firstWhere(
                                        (sp) => sp.id == _selectedSackPriceId);
                                if (qty <
                                    (sackPrice.specialPrice?.minimumQty ?? 0)) {
                                  return 'Minimum quantity is ${sackPrice.specialPrice?.minimumQty}';
                                }
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
                        const SizedBox(height: 8),
                        Text(
                          _selectedSackPriceId != null
                              ? 'Enter whole numbers only'
                              : 'Decimal numbers allowed (e.g., 1.5 kg)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _addToCart,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
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
