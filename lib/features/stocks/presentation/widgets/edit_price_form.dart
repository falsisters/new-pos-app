import 'package:falsisters_pos_android/features/products/data/providers/product_provider.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_sack_type.dart';
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
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text('Prices updated successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );

          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Error updating prices: $e')),
                ],
              ),
              backgroundColor: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
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
                      child: Icon(Icons.attach_money_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Product Prices',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Update pricing information for ${widget.product.name}',
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

              // Per Kilo Price Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.withOpacity(0.2)),
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
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.scale_rounded,
                                color: Colors.green[700], size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Per Kilogram Pricing',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildPriceField(
                        initialValue: _perKiloPrice.toString(),
                        labelText: 'Price per Kilogram (₱)',
                        onSaved: (value) {
                          _perKiloPrice = double.parse(value!);
                        },
                        prefixIcon: Icons.scale_rounded,
                        borderColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),

              // Sack Prices Section
              if (_sackPrices.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppColors.accent.withOpacity(0.2)),
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
                              child: Icon(Icons.inventory_rounded,
                                  color: AppColors.accent, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Sack Pricing Options',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _sackPrices.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final sack = _sackPrices[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.primary,
                                                AppColors.primary
                                                    .withOpacity(0.8)
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            parseSackType(widget
                                                .product.sackPrice[index].type),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildPriceField(
                                      initialValue: sack.price.toString(),
                                      labelText: 'Regular Price (₱)',
                                      onSaved: (value) {
                                        _sackPrices[index].price =
                                            double.parse(value!);
                                      },
                                      prefixIcon: Icons.attach_money_rounded,
                                      borderColor: AppColors.primary,
                                    ),

                                    // Special Price Section
                                    if (sack.hasSpecialPrice) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary
                                              .withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppColors.secondary
                                                  .withOpacity(0.2)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.local_offer_rounded,
                                                    color: AppColors.secondary,
                                                    size: 18),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Special Pricing',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.secondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            _buildPriceField(
                                              initialValue:
                                                  sack.specialPrice.toString(),
                                              labelText: 'Special Price (₱)',
                                              onSaved: (value) {
                                                _sackPrices[index]
                                                        .specialPrice =
                                                    value?.isEmpty == true
                                                        ? 0
                                                        : double.parse(value!);
                                              },
                                              prefixIcon:
                                                  Icons.local_offer_rounded,
                                              borderColor: AppColors.secondary,
                                              required: false,
                                            ),
                                            const SizedBox(height: 12),
                                            _buildQuantityField(
                                              initialValue:
                                                  sack.minimumQty.toString(),
                                              labelText:
                                                  'Minimum Quantity for Special Price',
                                              onSaved: (value) {
                                                _sackPrices[index].minimumQty =
                                                    value?.isEmpty == true
                                                        ? 0
                                                        : int.parse(value!);
                                              },
                                              required: false,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Enhanced Submit Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isLoading
                        ? [Colors.grey[400]!, Colors.grey[300]!]
                        : [
                            AppColors.secondary,
                            AppColors.secondary.withOpacity(0.8)
                          ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _isLoading
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.secondary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _isLoading
                        ? null
                        : () {
                            _submitForm().then((_) {
                              ref.read(productProvider.notifier).getProducts();
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
                          ] else ...[
                            Icon(Icons.save_rounded,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                          ],
                          Text(
                            _isLoading ? 'Updating Prices...' : 'Update Prices',
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

  Widget _buildPriceField({
    required String initialValue,
    required String labelText,
    required Function(String?) onSaved,
    required IconData prefixIcon,
    required Color borderColor,
    bool required = true,
  }) {
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
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              color: borderColor, fontSize: 14, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(prefixIcon, color: borderColor, size: 20),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
      ),
    );
  }

  Widget _buildQuantityField({
    required String initialValue,
    required String labelText,
    required Function(String?) onSaved,
    bool required = true,
  }) {
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
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              color: AppColors.secondary,
              fontSize: 14,
              fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.secondary.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.secondary.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.secondary, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.numbers_rounded,
                color: AppColors.secondary, size: 20),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Please enter a quantity';
          }
          if (value != null &&
              value.isNotEmpty &&
              int.tryParse(value) == null) {
            return 'Please enter a valid quantity';
          }
          return null;
        },
        onSaved: onSaved,
      ),
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
