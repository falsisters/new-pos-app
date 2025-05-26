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
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'product-${widget.product.id}',
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Select pricing & quantity',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
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
                const SizedBox(height: 12),
                _buildSectionTitle('Quantity', Icons.scale_outlined),
                _buildQuantityInput(),
                const SizedBox(height: 12),
                _buildSectionTitle(
                    'Discount (Optional)', Icons.local_offer_outlined),
                _buildDiscountInput(),
                const SizedBox(height: 20),
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
                    onPressed: _addToCart,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingOptions() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
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
              sackChips.add(_buildPriceChip(
                label: parseSackType(sackPrice.type),
                price: sackPrice.price,
                stock: sackPrice.stock.toDouble(),
                isSelected:
                    _selectedSackPriceId == sackPrice.id && !_isSpecialPrice,
                onTap: () => _selectSackPrice(sackPrice.id),
                subLabel: 'Regular',
              ));
              // if (sackPrice.specialPrice != null) {
              //   sackChips.add(_buildPriceChip(
              //     label: parseSackType(sackPrice.type),
              //     price: sackPrice.specialPrice!.price,
              //     stock: sackPrice.stock.toDouble(),
              //     isSelected:
              //         _selectedSackPriceId == sackPrice.id && _isSpecialPrice,
              //     onTap: () => _selectSackPrice(
              //       sackPrice.id,
              //       isSpecial: true,
              //       minimumQty: sackPrice.specialPrice!.minimumQty,
              //     ),
              //     isSpecial: true,
              //     minimumQty: sackPrice.specialPrice!.minimumQty,
              //     subLabel: 'Special',
              //   ));
              // }
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? AppColors.primaryLight.withOpacity(0.7)
              : Colors.white,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
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
                    fontSize: 13,
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
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            if (subLabel != null && !isSpecial)
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Text(subLabel,
                    style: TextStyle(
                        fontSize: 9,
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.8)
                            : Colors.grey.shade600)),
              ),
            const SizedBox(height: 2),
            Text(
              '₱${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? AppColors.primary : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'Stock: ${isPerKilo ? stock.toStringAsFixed(1) + "kg" : stock.toInt()}',
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? AppColors.primary.withOpacity(0.8)
                    : Colors.grey.shade600,
              ),
            ),
            if (isSpecial && minimumQty != null)
              Text(
                'Min: $minimumQty',
                style: TextStyle(
                  fontSize: 10,
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
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
                focusNode: _perKiloQuantityFocusNode,
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
              const SizedBox(height: 8),
              TextFormField(
                controller: _perKiloTotalPriceController,
                focusNode: _perKiloTotalPriceFocusNode,
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
            const SizedBox(height: 4),
            Text(
              _selectedSackPriceId != null
                  ? 'Enter whole numbers for sacks.'
                  : 'Enter kg quantity or total price. The other calculates automatically.',
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      {required String labelText, String? prefixText, Widget? suffixIcon}) {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: AppColors.primary, fontSize: 14),
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      isDense: true,
    );
  }

  Widget _buildQuantityControls() {
    return SizedBox(
      width: 80,
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
      height: 30,
      width: 30,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: AppColors.primary, size: 18),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildDiscountInput() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Apply Discounted Price',
                  style: TextStyle(fontSize: 14)),
              value: _isDiscounted,
              onChanged: (bool? value) {
                setState(() {
                  _isDiscounted = value ?? false;
                  if (!_isDiscounted) _discountedPriceController.clear();
                });
              },
              activeColor: AppColors.primary,
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 6),
            ),
            if (_isDiscounted)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
