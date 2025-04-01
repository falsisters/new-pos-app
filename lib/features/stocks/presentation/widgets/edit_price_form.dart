import 'package:falsisters_pos_android/features/products/data/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/edit_per_kilo_price_dto.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/edit_per_kilo_price_request.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/edit_sack_price_dto.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/edit_special_price_dto.dart';
import 'package:falsisters_pos_android/features/stocks/data/models/edit_sack_price_request_model.dart';
import 'package:falsisters_pos_android/features/stocks/data/repository/stock_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPriceForm extends ConsumerStatefulWidget {
  final Product product;

  const EditPriceForm({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<EditPriceForm> createState() => _EditPriceFormState();
}

class _EditPriceFormState extends ConsumerState<EditPriceForm> {
  final _formKey = GlobalKey<FormState>();
  final _stockRepository = StockRepository();

  late double _perKiloPrice;
  late List<SackPriceFormModel> _sackPrices;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _perKiloPrice = widget.product.perKiloPrice?.price ?? 0.0;
    _sackPrices = widget.product.sackPrice
        .map((sackPrice) => SackPriceFormModel(
              id: sackPrice.id,
              specialPriceId: sackPrice.specialPrice?.id ?? '',
              price: sackPrice.price,
              specialPrice: sackPrice.specialPrice?.price ?? 0.0,
              minimumQty: sackPrice.specialPrice?.minimumQty ?? 0,
              hasSpecialPrice: sackPrice.specialPrice != null,
            ))
        .toList();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isLoading = true);

      try {
        // Update sack prices
        if (_sackPrices.isNotEmpty) {
          final sackPriceRequest = EditSackPriceRequestModel(
            sackPrice: _sackPrices
                .map((sack) => EditSackPriceDto(
                      id: sack.id,
                      price: sack.price,
                      specialPrice: sack.hasSpecialPrice
                          ? EditSpecialPriceDto(
                              id: sack.specialPriceId,
                              price: sack.specialPrice,
                              minimumQty: sack.minimumQty,
                            )
                          : null,
                    ))
                .toList(),
          );
          await _stockRepository.editSackPrice(
              widget.product.id, sackPriceRequest);
        }

        // Update per kilo price
        final perKiloPriceRequest = EditPerKiloPriceRequest(
          perKiloPrice: EditPerKiloPriceDto(price: _perKiloPrice),
        );
        await _stockRepository.editPerKiloPrice(
            widget.product.id, perKiloPriceRequest);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prices updated successfully'),
              backgroundColor: AppColors.secondary,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating prices: $e'),
              backgroundColor: Colors.red,
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
    final ref = this.ref;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Product Prices',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Per Kilo Price Section
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColors.primaryLight, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Per Kilo Price',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPriceField(
                      initialValue: _perKiloPrice.toString(),
                      labelText: 'Per Kilo Price',
                      onSaved: (value) {
                        _perKiloPrice = double.parse(value!);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sack Prices Section
            if (_sackPrices.isNotEmpty) ...[
              Text(
                'Sack Prices',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _sackPrices.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final sack = _sackPrices[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sack ID: ${sack.id}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPriceField(
                            initialValue: sack.price.toString(),
                            labelText: 'Regular Price',
                            onSaved: (value) {
                              _sackPrices[index].price = double.parse(value!);
                            },
                          ),

                          // Only show special price and minimum quantity if the sack has them
                          if (sack.hasSpecialPrice) ...[
                            const SizedBox(height: 12),
                            _buildPriceField(
                              initialValue: sack.specialPrice.toString(),
                              labelText: 'Special Price',
                              onSaved: (value) {
                                _sackPrices[index].specialPrice =
                                    value?.isEmpty == true
                                        ? 0
                                        : double.parse(value!);
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildQuantityField(
                              initialValue: sack.minimumQty.toString(),
                              labelText: 'Minimum Quantity',
                              onSaved: (value) {
                                _sackPrices[index].minimumQty =
                                    value?.isEmpty == true
                                        ? 0
                                        : int.parse(value!);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 32),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        _submitForm();
                        ref.read(productProvider.notifier).getProducts();
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : const Text(
                        'Update Prices',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceField({
    required String initialValue,
    required String labelText,
    required Function(String?) onSaved,
    bool required = true,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
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
        prefixIcon: const Icon(Icons.attach_money, color: AppColors.secondary),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Please enter a price';
        }
        if (value != null &&
            value.isNotEmpty &&
            double.tryParse(value) == null) {
          return 'Please enter a valid price';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }

  Widget _buildQuantityField({
    required String initialValue,
    required String labelText,
    required Function(String?) onSaved,
    bool required = true,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
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
        prefixIcon: const Icon(Icons.numbers, color: AppColors.secondary),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Please enter a quantity';
        }
        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
          return 'Please enter a valid quantity';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}

class SackPriceFormModel {
  final String id;
  final String specialPriceId;
  double price;
  double specialPrice;
  int minimumQty;
  bool hasSpecialPrice;

  SackPriceFormModel({
    required this.id,
    required this.price,
    required this.specialPrice,
    required this.specialPriceId,
    required this.minimumQty,
    required this.hasSpecialPrice,
  });
}
