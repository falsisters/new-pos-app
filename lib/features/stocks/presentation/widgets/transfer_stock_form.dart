import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/products/data/providers/product_provider.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_sack_type.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/transfer_per_kilo_price_dto.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/transfer_product_dto.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/transfer_product_request.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/transfer_sack_price_dto.dart';
import 'package:falsisters_pos_android/features/stocks/data/repository/stock_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferStockForm extends ConsumerStatefulWidget {
  final Product product;

  const TransferStockForm({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<TransferStockForm> createState() => TransferStockFormState();
}

class TransferStockFormState extends ConsumerState<TransferStockForm> {
  final _formKey = GlobalKey<FormState>();
  final _stockRepository = StockRepository();
  final _quantityController = TextEditingController();

  TransferType _selectedTransferType = TransferType.KAHON;
  bool _isPerKilo = false;
  int _selectedSackIndex = -1;
  double _quantity = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.sackPrice.isNotEmpty) {
      _selectedSackIndex = 0;
      // Set default quantity to 1 if there's stock available
      if (widget.product.sackPrice[0].stock > 0) {
        _quantity = 1;
      }
    } else if (widget.product.perKiloPrice != null) {
      _isPerKilo = true;
      // Set default quantity to 1 if there's stock available
      if (widget.product.perKiloPrice!.stock > 0) {
        _quantity = 1.0;
      }
    }
    _quantityController.text = _quantity.toStringAsFixed(_isPerKilo ? 1 : 0);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isLoading = true);

      try {
        late TransferProductDto productDto;

        if (_isPerKilo && widget.product.perKiloPrice != null) {
          productDto = TransferProductDto(
            id: widget.product.id,
            perKiloPrice: TransferPerKiloPriceDto(
              id: widget.product.perKiloPrice!.id,
              quantity: _quantity,
            ),
          );
        } else if (_selectedSackIndex >= 0) {
          final selectedSack = widget.product.sackPrice[_selectedSackIndex];
          productDto = TransferProductDto(
            id: widget.product.id,
            sackPrice: TransferSackPriceDto(
              id: selectedSack.id,
              quantity: _quantity.toInt(),
              type: selectedSack.type,
            ),
          );
        } else {
          throw Exception("No valid product transfer option selected");
        }

        final request = TransferProductRequest(
          product: productDto,
          transferType: _selectedTransferType,
        );

        await _stockRepository.transferStock(request);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text('Stock transfer successful'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Error: ${e.toString()}')),
                ],
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  // Public method to trigger submit from parent
  void triggerSubmit() {
    if (!_isLoading &&
        _hasValidStock() &&
        _formKey.currentState?.validate() == true) {
      FocusScope.of(context).unfocus();
      _submitForm().then((_) {
        if (mounted) {
          ref.read(productProvider.notifier).getProducts();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[50]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(Icons.swap_horiz_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transfer Stock',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Move inventory for ${widget.product.name}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Transfer Type Selection
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
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
                              color: AppColors.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.category_rounded,
                                color: AppColors.accent, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Transfer Type',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTransferTypeDropdown(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Stock Selection
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: AppColors.secondary.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
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
                              color: AppColors.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.inventory_2_rounded,
                                color: AppColors.secondary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Stock Options',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTransferOptionSelector(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Quantity Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
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
                              color: AppColors.primary.withOpacity(0.1),
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
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildQuantityField(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Enhanced Submit Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isLoading || !_hasValidStock()
                        ? [Colors.grey[400]!, Colors.grey[300]!]
                        : [AppColors.accent, AppColors.accent.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _isLoading || !_hasValidStock()
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _isLoading || !_hasValidStock()
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            _submitForm().then((_) {
                              ref.read(productProvider.notifier).getProducts();
                              if (mounted) {
                                Navigator.pop(context, true);
                              }
                            });
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isLoading) ...[
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ] else if (!_hasValidStock()) ...[
                            Icon(Icons.block_rounded,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                          ] else ...[
                            Icon(Icons.send_rounded,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                          ],
                          Text(
                            _isLoading
                                ? 'Processing Transfer...'
                                : !_hasValidStock()
                                    ? 'No Stock Available'
                                    : 'Transfer Stock',
                            style: TextStyle(
                              fontSize: 16,
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
    );
  }

  Widget _buildTransferTypeDropdown() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<TransferType>(
        decoration: InputDecoration(
          labelText: 'Select Transfer Type',
          labelStyle: TextStyle(
              color: AppColors.accent,
              fontSize: 14,
              fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.accent.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.accent.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.accent, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.swap_horiz_rounded,
                color: AppColors.accent, size: 20),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        value: _selectedTransferType,
        items: TransferType.values.map((type) {
          return DropdownMenuItem<TransferType>(
            value: type,
            child: Text(parseTransferType(type),
                style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedTransferType = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildTransferOptionSelector() {
    final hasPerKilo = widget.product.perKiloPrice != null;
    final hasSackPrices = widget.product.sackPrice.isNotEmpty;
    final perKiloInStock = hasPerKilo && widget.product.perKiloPrice!.stock > 0;
    final sackPricesInStock =
        widget.product.sackPrice.where((sack) => sack.stock > 0).toList();

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
                'No stock options available for this product',
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

    if (!perKiloInStock && sackPricesInStock.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.block_rounded, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'This product is out of stock and cannot be transferred',
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Per Kilo Option
        if (hasPerKilo)
          GestureDetector(
            onTap: perKiloInStock
                ? () {
                    setState(() {
                      _isPerKilo = true;
                      _selectedSackIndex = -1;
                      // Set default quantity to 1 if there's stock
                      _quantity = perKiloInStock ? 1.0 : 0;
                      _quantityController.text = _quantity.toStringAsFixed(1);
                    });
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: !perKiloInStock
                    ? Colors.grey[100]
                    : _isPerKilo
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: !perKiloInStock
                      ? Colors.grey[400]!
                      : _isPerKilo
                          ? Colors.green
                          : Colors.grey[300]!,
                  width: _isPerKilo ? 2 : 1,
                ),
                boxShadow: _isPerKilo && perKiloInStock
                    ? [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Opacity(
                opacity: perKiloInStock ? 1.0 : 0.5,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: !perKiloInStock
                            ? Colors.grey[300]
                            : _isPerKilo
                                ? Colors.green.withOpacity(0.2)
                                : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        perKiloInStock
                            ? Icons.scale_rounded
                            : Icons.block_rounded,
                        color: !perKiloInStock
                            ? Colors.grey[600]
                            : _isPerKilo
                                ? Colors.green[700]
                                : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Per Kilogram Stock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: !perKiloInStock
                                  ? Colors.grey[600]
                                  : _isPerKilo
                                      ? Colors.green[700]
                                      : Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            perKiloInStock
                                ? 'Available: ${widget.product.perKiloPrice!.stock.toStringAsFixed(1)} kg'
                                : 'Out of Stock',
                            style: TextStyle(
                              fontSize: 13,
                              color: !perKiloInStock
                                  ? Colors.red[600]
                                  : _isPerKilo
                                      ? Colors.green[600]
                                      : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isPerKilo && perKiloInStock)
                      Icon(Icons.check_circle_rounded,
                          color: Colors.green[700], size: 24),
                    if (!perKiloInStock)
                      Icon(Icons.block_rounded, color: Colors.red, size: 24),
                  ],
                ),
              ),
            ),
          ),

        if (hasPerKilo && hasSackPrices) const SizedBox(height: 12),

        // Sack Options
        if (hasSackPrices) ...[
          Text(
            'Sack Stock Options',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          ...widget.product.sackPrice.asMap().entries.map((entry) {
            final index = entry.key;
            final sack = entry.value;
            final isSelected = !_isPerKilo && _selectedSackIndex == index;
            final sackInStock = sack.stock > 0;

            return Padding(
              padding: EdgeInsets.only(
                  bottom: index < widget.product.sackPrice.length - 1 ? 8 : 0),
              child: GestureDetector(
                onTap: sackInStock
                    ? () {
                        setState(() {
                          _isPerKilo = false;
                          _selectedSackIndex = index;
                          // Set default quantity to 1 if there's stock
                          _quantity = sackInStock ? 1 : 0;
                          _quantityController.text =
                              _quantity.toStringAsFixed(0);
                        });
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: !sackInStock
                        ? Colors.grey[100]
                        : isSelected
                            ? AppColors.secondary.withOpacity(0.1)
                            : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: !sackInStock
                          ? Colors.grey[400]!
                          : isSelected
                              ? AppColors.secondary
                              : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected && sackInStock
                        ? [
                            BoxShadow(
                              color: AppColors.secondary.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Opacity(
                    opacity: sackInStock ? 1.0 : 0.5,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: !sackInStock
                                ? Colors.grey[300]
                                : isSelected
                                    ? AppColors.secondary.withOpacity(0.2)
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            sackInStock
                                ? Icons.inventory_rounded
                                : Icons.block_rounded,
                            color: !sackInStock
                                ? Colors.grey[600]
                                : isSelected
                                    ? AppColors.secondary
                                    : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                parseSackType(sack.type),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: !sackInStock
                                      ? Colors.grey[600]
                                      : isSelected
                                          ? AppColors.secondary
                                          : Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                sackInStock
                                    ? 'Available: ${sack.stock} sacks'
                                    : 'Out of Stock',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: !sackInStock
                                      ? Colors.red[600]
                                      : isSelected
                                          ? AppColors.secondary
                                          : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected && sackInStock)
                          Icon(Icons.check_circle_rounded,
                              color: AppColors.secondary, size: 24),
                        if (!sackInStock)
                          Icon(Icons.block_rounded,
                              color: Colors.red, size: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ],
    );
  }

  Widget _buildQuantityField() {
    final maxQuantity = _isPerKilo
        ? widget.product.perKiloPrice?.stock ?? 0
        : (_selectedSackIndex >= 0
            ? widget.product.sackPrice[_selectedSackIndex].stock.toDouble()
            : 0);

    final hasValidSelection = (_isPerKilo &&
            widget.product.perKiloPrice != null &&
            widget.product.perKiloPrice!.stock > 0) ||
        (_selectedSackIndex >= 0 &&
            widget.product.sackPrice[_selectedSackIndex].stock > 0);

    bool _isLowStock() => maxQuantity > 0 && maxQuantity <= 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Actions for sack quantities
        if (!_isPerKilo && hasValidSelection) ...[
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickActionButton('1', 1),
                const SizedBox(width: 8),
                _buildQuickActionButton('2', 2),
                const SizedBox(width: 8),
                _buildQuickActionButton('3', 3),
                const SizedBox(width: 8),
                _buildQuickActionButton('4', 4),
                const SizedBox(width: 8),
                _buildQuickActionButton('5', 5),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Stock availability warning
        if (hasValidSelection && _isLowStock())
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
                Icon(Icons.inventory_2, color: Colors.orange[700], size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Only ${maxQuantity.toStringAsFixed(_isPerKilo ? 1 : 0)} ${_isPerKilo ? 'kg' : 'sacks'} available',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Quantity input field
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
            enabled: hasValidSelection,
            keyboardType: _isPerKilo
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.number,
            inputFormatters: _isPerKilo
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                : [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: _isPerKilo ? 'Kg' : 'Sacks',
              labelStyle: TextStyle(
                color: hasValidSelection ? AppColors.primary : Colors.grey[500],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: AppColors.primary.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: AppColors.primary.withOpacity(0.3)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
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
              fillColor: hasValidSelection ? Colors.white : Colors.grey[100],
              prefixIcon: hasValidSelection
                  ? null
                  : Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.numbers_rounded,
                          color: Colors.grey[500], size: 20),
                    ),
              suffixIcon: hasValidSelection ? _buildQuantityControls() : null,
              helperText: hasValidSelection
                  ? 'Maximum available: ${maxQuantity.toStringAsFixed(_isPerKilo ? 1 : 0)} ${_isPerKilo ? 'kg' : 'sacks'}'
                  : 'Please select a stock option first',
              helperStyle: TextStyle(fontSize: 12, color: Colors.grey[600]),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            validator: (value) {
              if (!hasValidSelection) {
                return 'Please select a valid stock option';
              }

              if (value == null || value.isEmpty) {
                return 'Enter quantity';
              }

              final qty = double.tryParse(value);
              if (qty == null || qty <= 0) {
                return 'Valid quantity > 0';
              }

              if (qty > maxQuantity) {
                return 'Only ${maxQuantity.toStringAsFixed(_isPerKilo ? 1 : 0)} available';
              }

              if (!_isPerKilo && qty % 1 != 0) {
                return 'Sack quantity must be a whole number';
              }

              return null;
            },
            onChanged: (value) {
              setState(() {
                _quantity = double.tryParse(value) ?? 0;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControls() {
    final maxQuantity = _isPerKilo
        ? widget.product.perKiloPrice?.stock ?? 0
        : (_selectedSackIndex >= 0
            ? widget.product.sackPrice[_selectedSackIndex].stock.toDouble()
            : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Minus button
        Container(
          height: 32,
          width: 32,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: _quantity > 0
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _quantity > 0
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.grey[300]!,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _quantity > 0 ? _decrementQuantity : null,
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                Icons.remove_rounded,
                color: _quantity > 0 ? AppColors.primary : Colors.grey[500],
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
            color: _quantity < maxQuantity
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _quantity < maxQuantity
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.grey[300]!,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _quantity < maxQuantity ? _incrementQuantity : null,
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                Icons.add_rounded,
                color: _quantity < maxQuantity
                    ? AppColors.primary
                    : Colors.grey[500],
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(String label, double quantity) {
    final maxQuantity = _selectedSackIndex >= 0
        ? widget.product.sackPrice[_selectedSackIndex].stock.toDouble()
        : 0;

    bool isEnabled = quantity <= maxQuantity && maxQuantity > 0;
    String displayLabel =
        label == 'Max' ? maxQuantity.toInt().toString() : label;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? () => _setQuickQuantity(quantity) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          width: 60,
          decoration: BoxDecoration(
            color: isEnabled
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEnabled
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                displayLabel,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isEnabled ? AppColors.primary : Colors.grey[500],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'sacks',
                style: TextStyle(
                  fontSize: 10,
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

  void _setQuickQuantity(double quantity) {
    setState(() {
      _quantity = quantity;
      _quantityController.text = _quantity.toStringAsFixed(_isPerKilo ? 1 : 0);
    });
    // Update the text field
    _formKey.currentState?.validate();
  }

  void _incrementQuantity() {
    final maxQuantity = _isPerKilo
        ? widget.product.perKiloPrice?.stock ?? 0
        : (_selectedSackIndex >= 0
            ? widget.product.sackPrice[_selectedSackIndex].stock.toDouble()
            : 0);

    if (_quantity < maxQuantity) {
      setState(() {
        if (_isPerKilo) {
          _quantity += 0.1;
          _quantity = double.parse(_quantity.toStringAsFixed(1));
        } else {
          _quantity += 1;
        }
        _quantityController.text =
            _quantity.toStringAsFixed(_isPerKilo ? 1 : 0);
      });
    }
  }

  void _decrementQuantity() {
    if (_quantity > 0) {
      setState(() {
        if (_isPerKilo) {
          _quantity -= 0.1;
          _quantity = double.parse(_quantity.toStringAsFixed(1));
          if (_quantity < 0) _quantity = 0;
        } else {
          _quantity -= 1;
          if (_quantity < 0) _quantity = 0;
        }
        _quantityController.text =
            _quantity.toStringAsFixed(_isPerKilo ? 1 : 0);
      });
    }
  }

  bool _hasValidStock() {
    final perKiloInStock = widget.product.perKiloPrice != null &&
        widget.product.perKiloPrice!.stock > 0;
    final sackInStock = widget.product.sackPrice.any((sack) => sack.stock > 0);
    return perKiloInStock || sackInStock;
  }
}
