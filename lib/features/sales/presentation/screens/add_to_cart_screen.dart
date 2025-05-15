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
    } else if (widget.product.sackPrice.isNotEmpty) {
      // Default to first sack price if no per kilo or if both exist
      _selectSackPrice(widget.product.sackPrice.first.id);
    }
    _updatePerKiloTotalPriceFromQuantity();

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
    super.dispose();
  }

  void _updatePerKiloTotalPriceFromQuantity() {
    if (_isUpdatingPriceAndQuantityInternally ||
        !_isPerKiloSelected ||
        widget.product.perKiloPrice == null) return;

    _isUpdatingPriceAndQuantityInternally = true;
    final quantity = double.tryParse(_perKiloQuantityController.text);
    if (quantity != null && quantity > 0) {
      final unitPrice = widget.product.perKiloPrice!.price;
      _perKiloTotalPriceController.text =
          (quantity * unitPrice).toStringAsFixed(2);
    } else {
      _perKiloTotalPriceController.clear();
    }
    _isUpdatingPriceAndQuantityInternally = false;
  }

  void _updatePerKiloQuantityFromTotalPrice() {
    if (_isUpdatingPriceAndQuantityInternally ||
        !_isPerKiloSelected ||
        widget.product.perKiloPrice == null) return;

    _isUpdatingPriceAndQuantityInternally = true;
    final totalPrice = double.tryParse(_perKiloTotalPriceController.text);
    if (totalPrice != null && totalPrice >= 0) {
      final unitPrice = widget.product.perKiloPrice!.price;
      if (unitPrice > 0) {
        _perKiloQuantityController.text =
            (totalPrice / unitPrice).toStringAsFixed(2);
      } else {
        _perKiloQuantityController.clear();
      }
    } else {
      _perKiloQuantityController.clear();
    }
    _isUpdatingPriceAndQuantityInternally = false;
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
      _updatePerKiloTotalPriceFromQuantity();
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
          // Ensure it doesn't go below 0.1
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

      productDto = ProductDto(
        id: widget.product.id,
        name: widget.product.name,
        isGantang: false,
        isSpecialPrice: _isSpecialPrice,
        sackPrice: SackPriceDto(
          id: sackPrice.id,
          price:
              _isSpecialPrice ? sackPrice.specialPrice!.price : sackPrice.price,
          quantity: quantity,
          type: sackPrice.type,
        ),
        isDiscounted: _isDiscounted,
        discountedPrice: _isDiscounted
            ? double.tryParse(_discountedPriceController.text)
            : null,
      );
    } else if (_isPerKiloSelected && widget.product.perKiloPrice != null) {
      final perKiloPrice = widget.product.perKiloPrice!;
      final quantity = double.tryParse(_perKiloQuantityController.text) ?? 1.0;

      productDto = ProductDto(
        id: widget.product.id,
        name: widget.product.name,
        isGantang: false,
        isSpecialPrice: false,
        perKiloPrice: PerKiloPriceDto(
          id: perKiloPrice.id,
          price: perKiloPrice.price,
          quantity: quantity,
        ),
        isDiscounted: _isDiscounted,
        discountedPrice: _isDiscounted
            ? double.tryParse(_discountedPriceController.text)
            : null,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a pricing option.')),
      );
      return;
    }

    salesNotifier.addProductToCart(productDto);

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
        title: const Text('Add to Cart', style: TextStyle(fontSize: 18)),
      ),
      body: Padding(
        // Changed from Container with gradient to simple Padding
        padding: const EdgeInsets.all(12.0), // Reduced padding
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Info - More compact
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'product-${widget.product.id}',
                        child: Container(
                          width: 70, // Reduced size
                          height: 70, // Reduced size
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(8), // Reduced radius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(widget.product.picture),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12), // Reduced spacing
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontSize: 18, // Reduced size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2), // Reduced spacing
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2), // Reduced padding
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(4), // Reduced radius
                              ),
                              child: Text(
                                'Select pricing & quantity',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11, // Reduced size
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

                _buildSectionTitle('Pricing Options', Icons.payments_outlined),
                _buildPricingOptions(),
                const SizedBox(height: 12), // Reduced spacing

                _buildSectionTitle('Quantity', Icons.scale_outlined),
                _buildQuantityInput(),
                const SizedBox(height: 12), // Reduced spacing

                _buildSectionTitle(
                    'Discount (Optional)', Icons.local_offer_outlined),
                _buildDiscountInput(),
                const SizedBox(height: 20), // Reduced spacing

                SizedBox(
                  width: double.infinity,
                  height: 50, // Slightly reduced height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Reduced radius
                      ),
                    ),
                    onPressed: _addToCart,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, size: 22), // Reduced size
                        SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold), // Reduced size
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12), // Reduced spacing
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 6.0), // Reduced padding
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20), // Reduced size
          const SizedBox(width: 6), // Reduced spacing
          Text(
            title,
            style: const TextStyle(
              fontSize: 16, // Reduced size
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingOptions() {
    return Card(
      elevation: 2, // Reduced elevation
      margin: EdgeInsets.zero, // Removed default card margin
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)), // Reduced radius
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Reduced padding
        child: Wrap(
          spacing: 8, // Reduced spacing
          runSpacing: 8, // Reduced spacing
          children: [
            if (widget.product.perKiloPrice != null)
              _buildPriceChip(
                label: 'Per Kilo',
                price: widget.product.perKiloPrice!.price,
                stock: widget.product.perKiloPrice!.stock,
                isSelected: _isPerKiloSelected,
                onTap: _selectPerKilo,
                isPerKilo: true,
              ),
            ...widget.product.sackPrice.expand((sackPrice) {
              List<Widget> sackChips = [];
              // Regular Price Chip for Sack
              sackChips.add(_buildPriceChip(
                label: parseSackType(sackPrice.type),
                price: sackPrice.price,
                stock: sackPrice.stock.toDouble(),
                isSelected:
                    _selectedSackPriceId == sackPrice.id && !_isSpecialPrice,
                onTap: () => _selectSackPrice(sackPrice.id),
                subLabel: 'Regular',
              ));
              // Special Price Chip for Sack (if exists)
              if (sackPrice.specialPrice != null) {
                sackChips.add(_buildPriceChip(
                  label: parseSackType(sackPrice.type),
                  price: sackPrice.specialPrice!.price,
                  stock:
                      sackPrice.stock.toDouble(), // Stock is same for special
                  isSelected:
                      _selectedSackPriceId == sackPrice.id && _isSpecialPrice,
                  onTap: () => _selectSackPrice(
                    sackPrice.id,
                    isSpecial: true,
                    minimumQty: sackPrice.specialPrice!.minimumQty,
                  ),
                  isSpecial: true,
                  minimumQty: sackPrice.specialPrice!.minimumQty,
                  subLabel: 'Special',
                ));
              }
              return sackChips;
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceChip({
    required String label,
    required double price,
    required double stock,
    required bool isSelected,
    required VoidCallback onTap,
    bool isPerKilo = false,
    bool isSpecial = false,
    int? minimumQty,
    String? subLabel,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 8), // Reduced padding
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1, // Adjusted width
          ),
          borderRadius: BorderRadius.circular(8), // Reduced radius
          color: isSelected
              ? AppColors.primaryLight.withOpacity(0.7)
              : Colors.white,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 4, // Reduced blur
                    offset: const Offset(0, 2), // Reduced offset
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13, // Reduced size
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : Colors.black87,
                  ),
                ),
                if (isSpecial)
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      'SPECIAL',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 8, // Reduced size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            if (subLabel != null &&
                !isSpecial) // Show sublabel like "Regular" only if not special (special has its own badge)
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Text(subLabel,
                    style: TextStyle(
                        fontSize: 9,
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.8)
                            : Colors.grey.shade600)),
              ),
            const SizedBox(height: 2), // Reduced spacing
            Text(
              '₱${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14, // Reduced size
                color: isSelected ? AppColors.primary : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 1), // Reduced spacing
            Text(
              'Stock: ${isPerKilo ? stock.toStringAsFixed(1) + "kg" : stock.toInt()}',
              style: TextStyle(
                fontSize: 10, // Reduced size
                color: isSelected
                    ? AppColors.primary.withOpacity(0.8)
                    : Colors.grey.shade600,
              ),
            ),
            if (isSpecial && minimumQty != null)
              Text(
                'Min: $minimumQty',
                style: TextStyle(
                  fontSize: 10, // Reduced size
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.8)
                      : Colors.grey.shade600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityInput() {
    return Card(
      elevation: 2, // Reduced elevation
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)), // Reduced radius
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Reduced padding
        child: Column(
          children: [
            if (_selectedSackPriceId != null)
              TextFormField(
                controller: _sackQuantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration(
                  labelText: 'Sack Quantity',
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
              ),
            if (_isPerKiloSelected) ...[
              TextFormField(
                controller: _perKiloQuantityController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: _inputDecoration(
                  labelText: 'Quantity (kg)',
                  suffixIcon: _buildQuantityControls(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter quantity';
                  final qty = double.tryParse(value);
                  if (qty == null || qty <= 0) return 'Valid quantity > 0';
                  return null;
                },
              ),
              const SizedBox(height: 8), // Reduced spacing
              TextFormField(
                controller: _perKiloTotalPriceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: _inputDecoration(
                  labelText: 'Total Price (₱)',
                  prefixText: '₱ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Enter total price';
                  final priceVal = double.tryParse(value);
                  if (priceVal == null || priceVal < 0)
                    return 'Valid price >= 0';
                  return null;
                },
              ),
            ],
            const SizedBox(height: 4), // Reduced spacing
            Text(
              _selectedSackPriceId != null
                  ? 'Enter whole numbers for sacks.'
                  : 'Enter kg quantity or total price. The other calculates automatically.',
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic), // Reduced size
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      {required String labelText, String? prefixText, Widget? suffixIcon}) {
    return InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8)), // Reduced radius
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), // Reduced radius
        borderSide:
            BorderSide(color: AppColors.primary, width: 1.5), // Adjusted width
      ),
      labelText: labelText,
      labelStyle:
          TextStyle(color: AppColors.primary, fontSize: 14), // Reduced size
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 10), // Reduced padding
      isDense: true,
    );
  }

  Widget _buildQuantityControls() {
    return SizedBox(
      // Wrapped in SizedBox to constrain width
      width: 80, // Reduced width
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _quantityButton(Icons.remove, _decreaseQuantity),
          const SizedBox(width: 4), // Reduced spacing
          _quantityButton(Icons.add, _increaseQuantity),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 30, // Reduced height
      width: 30, // Reduced width
      margin:
          const EdgeInsets.symmetric(vertical: 4), // Added margin for alignment
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6), // Reduced radius
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: AppColors.primary, size: 18), // Reduced size
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildDiscountInput() {
    return Card(
      elevation: 2, // Reduced elevation
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)), // Reduced radius
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0), // Adjusted padding
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Apply Discounted Price',
                  style: TextStyle(fontSize: 14)), // Reduced size
              value: _isDiscounted,
              onChanged: (bool? value) {
                setState(() {
                  _isDiscounted = value ?? false;
                  if (!_isDiscounted) _discountedPriceController.clear();
                });
              },
              activeColor: AppColors.primary,
              controlAffinity: ListTileControlAffinity.leading,
              dense: true, // Made denser
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 6), // Reduced padding
            ),
            if (_isDiscounted)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0), // Reduced padding
                child: TextFormField(
                  controller: _discountedPriceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: _inputDecoration(
                    labelText: 'Discounted Price (Total)',
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
      ),
    );
  }
}
