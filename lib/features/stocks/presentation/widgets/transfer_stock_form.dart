import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/products/data/providers/product_provider.dart';
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
  ConsumerState<TransferStockForm> createState() => _TransferStockFormState();
}

class _TransferStockFormState extends ConsumerState<TransferStockForm> {
  final _formKey = GlobalKey<FormState>();
  final _stockRepository = StockRepository();

  TransferType _selectedTransferType = TransferType.OWN_CONSUMPTION;
  bool _isPerKilo = false;
  int _selectedSackIndex = -1;
  double _quantity = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // If the product has any sack price, select the first one by default
    if (widget.product.sackPrice.isNotEmpty) {
      _selectedSackIndex = 0;
    } else if (widget.product.perKiloPrice != null) {
      _isPerKilo = true;
    }
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
            const SnackBar(
              content: Text('Stock transfer successful'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.redAccent,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transfer Stock: ${widget.product.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            _buildTransferTypeDropdown(),
            const SizedBox(height: 20),
            _buildTransferOptionSelector(),
            const SizedBox(height: 20),
            _buildQuantityField(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferTypeDropdown() {
    return DropdownButtonFormField<TransferType>(
      decoration: InputDecoration(
        labelText: 'Transfer Type',
        labelStyle: const TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
        prefixIcon: const Icon(Icons.swap_horiz, color: AppColors.secondary),
      ),
      value: _selectedTransferType,
      items: TransferType.values.map((type) {
        return DropdownMenuItem<TransferType>(
          value: type,
          child: Text(parseTransferType(type)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedTransferType = value;
          });
        }
      },
    );
  }

  Widget _buildTransferOptionSelector() {
    final hasPerKilo = widget.product.perKiloPrice != null;
    final hasSackPrices = widget.product.sackPrice.isNotEmpty;

    if (!hasPerKilo && !hasSackPrices) {
      return const Text(
        'No stock options available for this product',
        style: TextStyle(color: Colors.redAccent),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select what to transfer:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),

        // Card containing pricing options
        Card(
          elevation: 3,
          shadowColor: AppColors.primary.withAlpha((0.3 * 255).round()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Per Kilo Option
                if (hasPerKilo) ...[
                  Row(
                    children: [
                      Text(
                        'Per Kilo Stock',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPerKilo = true;
                            _selectedSackIndex = -1;
                            _quantity = 0;
                          });
                        },
                        child: Container(
                          width: 130,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _isPerKilo
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                              width: _isPerKilo ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: _isPerKilo
                                ? AppColors.primaryLight
                                : Colors.white,
                            boxShadow: _isPerKilo
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withAlpha((0.3 * 255).round()),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Per Kilo',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isPerKilo
                                      ? AppColors.primary
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Stock: ${widget.product.perKiloPrice!.stock.toStringAsFixed(2)}kg',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isPerKilo
                                      ? AppColors.primary
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (hasSackPrices) const Divider(height: 24),
                ],

                // Sack Prices Section
                if (hasSackPrices) ...[
                  Text(
                    'Sack Stock',
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
                    children:
                        widget.product.sackPrice.asMap().entries.map((entry) {
                      final index = entry.key;
                      final sack = entry.value;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPerKilo = false;
                            _selectedSackIndex = index;
                            _quantity = 0;
                          });
                        },
                        child: Container(
                          width: 130,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: !_isPerKilo && _selectedSackIndex == index
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                              width: !_isPerKilo && _selectedSackIndex == index
                                  ? 2
                                  : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: !_isPerKilo && _selectedSackIndex == index
                                ? AppColors.primaryLight
                                : Colors.white,
                            boxShadow:
                                !_isPerKilo && _selectedSackIndex == index
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withAlpha((0.3 * 255).round()),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ]
                                    : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sack.type.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      !_isPerKilo && _selectedSackIndex == index
                                          ? AppColors.primary
                                          : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Stock: ${sack.stock}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      !_isPerKilo && _selectedSackIndex == index
                                          ? AppColors.primary
                                          : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityField() {
    final maxQuantity = _isPerKilo
        ? widget.product.perKiloPrice?.stock ?? 0
        : (_selectedSackIndex >= 0
            ? widget.product.sackPrice[_selectedSackIndex].stock.toDouble()
            : 0);

    return TextFormField(
      initialValue: _quantity.toString(),
      decoration: InputDecoration(
        labelText: _isPerKilo ? 'Quantity (kg)' : 'Quantity (sacks)',
        labelStyle: const TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
        prefixIcon: const Icon(Icons.inventory, color: AppColors.secondary),
        helperText: 'Maximum: $maxQuantity',
      ),
      keyboardType: _isPerKilo
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      inputFormatters: _isPerKilo
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
          : [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a quantity';
        }

        final qty = double.tryParse(value);
        if (qty == null) {
          return 'Please enter a valid number';
        }

        if (qty <= 0) {
          return 'Quantity must be greater than zero';
        }

        if (qty > maxQuantity) {
          return 'Cannot exceed available stock';
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
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
                FocusScope.of(context).unfocus(); // Dismiss the keyboard
                _submitForm().then((_) {
                  ref.read(productProvider.notifier).getProducts();
                });
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: AppColors.white)
            : const Text(
                'Transfer Stock',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
