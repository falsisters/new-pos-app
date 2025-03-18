// ignore_for_file: unused_local_variable

import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/products/data/models/product_model.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_sack_type.dart';
import 'package:falsisters_pos_android/features/sales/data/model/per_kilo_price_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/model/sack_price_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToCartScreen extends ConsumerWidget {
  final Product product;

  const AddToCartScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesNotifier = ref.watch(salesProvider.notifier);
    final formKey = GlobalKey<FormState>();

    // State management for form values using StatefulBuilder
    final ValueNotifier<bool> isGantangNotifier = ValueNotifier<bool>(false);
    final ValueNotifier<bool> isSpecialPriceNotifier =
        ValueNotifier<bool>(false);
    final ValueNotifier<double> quantityNotifier = ValueNotifier<double>(1.0);
    final ValueNotifier<String?> selectedSackPriceIdNotifier =
        ValueNotifier<String?>(null);
    final ValueNotifier<String?> selectedSpecialPriceIdNotifier =
        ValueNotifier<String?>(null);

    // Local variables for easier access within widget builders
    bool isGantang = false;
    bool isSpecialPrice = false;
    double quantity = 1.0;
    String? selectedSackPriceId;
    String? selectedSpecialPriceId;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name and Image
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(product.picture),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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

              // Sack Prices Section
              if (product.sackPrice.isNotEmpty) ...[
                const Text(
                  'Sack Prices',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StatefulBuilder(
                      builder: (context, setState) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: product.sackPrice.map((sackPrice) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSackPriceId = sackPrice.id;
                                isSpecialPrice = false;
                                quantity = 1.0;
                                selectedSpecialPriceId = null;
                                isGantang = false; // Deselect gantang option

                                // Update the notifiers to keep state consistent
                                selectedSackPriceIdNotifier.value =
                                    sackPrice.id;
                                isSpecialPriceNotifier.value = false;
                                quantityNotifier.value = 1.0;
                                selectedSpecialPriceIdNotifier.value = null;
                                isGantangNotifier.value = false;
                              });
                            },
                            child: Container(
                              width: 120,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedSackPriceId == sackPrice.id
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: selectedSackPriceId == sackPrice.id
                                      ? 2
                                      : 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: selectedSackPriceId == sackPrice.id
                                    ? AppColors.primaryLight
                                    : Colors.white,
                                boxShadow: selectedSackPriceId == sackPrice.id
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    parseSackType(sackPrice.type),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedSackPriceId == sackPrice.id
                                          ? AppColors.primary
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₱${sackPrice.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedSackPriceId == sackPrice.id
                                          ? AppColors.primary
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (sackPrice.specialPrice != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: isSpecialPrice &&
                                              selectedSackPriceId ==
                                                  sackPrice.id,
                                          onChanged: (value) {
                                            setState(() {
                                              isSpecialPrice = value ?? false;
                                              if (isSpecialPrice) {
                                                selectedSpecialPriceId =
                                                    sackPrice.specialPrice!.id;
                                                quantity = sackPrice
                                                    .specialPrice!.minimumQty
                                                    .toDouble();
                                              } else {
                                                selectedSpecialPriceId = null;
                                                quantity = 1.0;
                                              }

                                              // Update the notifiers
                                              isSpecialPriceNotifier.value =
                                                  isSpecialPrice;
                                              selectedSpecialPriceIdNotifier
                                                      .value =
                                                  selectedSpecialPriceId;
                                              quantityNotifier.value = quantity;
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 4),
                                        const Expanded(
                                          child: Text(
                                            'Special',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Per Kilo Price Section
              if (product.perKiloPrice != null) ...[
                const Text(
                  'Per Kilo Price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StatefulBuilder(
                      builder: (context, setState) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSackPriceId = null;
                                    isSpecialPrice = false;
                                    selectedSpecialPriceId = null;
                                    isGantang = false;
                                    quantity = 1.0;

                                    // Update the notifiers
                                    selectedSackPriceIdNotifier.value = null;
                                    isSpecialPriceNotifier.value = false;
                                    selectedSpecialPriceIdNotifier.value = null;
                                    isGantangNotifier.value = false;
                                    quantityNotifier.value = 1.0;
                                  });
                                },
                                child: Container(
                                  width: 120,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedSackPriceId == null &&
                                              !isGantang
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                      width: selectedSackPriceId == null &&
                                              !isGantang
                                          ? 2
                                          : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: selectedSackPriceId == null &&
                                            !isGantang
                                        ? AppColors.primaryLight
                                        : Colors.white,
                                    boxShadow: selectedSackPriceId == null &&
                                            !isGantang
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
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
                                          color: selectedSackPriceId == null &&
                                                  !isGantang
                                              ? AppColors.primary
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₱${product.perKiloPrice!.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: selectedSackPriceId == null &&
                                                  !isGantang
                                              ? AppColors.primary
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSackPriceId = null;
                                    isSpecialPrice = false;
                                    selectedSpecialPriceId = null;
                                    isGantang = true;
                                    quantity = 1.0;

                                    // Update the notifiers
                                    selectedSackPriceIdNotifier.value = null;
                                    isSpecialPriceNotifier.value = false;
                                    selectedSpecialPriceIdNotifier.value = null;
                                    isGantangNotifier.value = true;
                                    quantityNotifier.value = 1.0;
                                  });
                                },
                                child: Container(
                                  width: 120,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedSackPriceId == null &&
                                              isGantang
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                      width: selectedSackPriceId == null &&
                                              isGantang
                                          ? 2
                                          : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        selectedSackPriceId == null && isGantang
                                            ? AppColors.primaryLight
                                            : Colors.white,
                                    boxShadow:
                                        selectedSackPriceId == null && isGantang
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withOpacity(0.2),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                )
                                              ]
                                            : null,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gantang',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedSackPriceId == null &&
                                                  isGantang
                                              ? AppColors.primary
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '₱${(product.perKiloPrice!.price * 2.25).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: selectedSackPriceId == null &&
                                                  isGantang
                                              ? AppColors.primary
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '(2.25 kilos)',
                                        style: TextStyle(
                                          color: AppColors.accent,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Quantity Input
              const Text(
                'Quantity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              StatefulBuilder(
                builder: (context, setState) => TextFormField(
                  initialValue: quantity.toString(),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter quantity',
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if ((isSpecialPrice &&
                                      quantity >
                                          (product.sackPrice
                                                  .firstWhere((sp) =>
                                                      sp.id ==
                                                      selectedSackPriceId)
                                                  .specialPrice
                                                  ?.minimumQty ??
                                              1)) ||
                                  (!isSpecialPrice && quantity > 1)) {
                                quantity--;
                                quantityNotifier.value = quantity;
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                              quantityNotifier.value = quantity;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    final qty = double.tryParse(value);
                    if (qty == null || qty <= 0) {
                      return 'Please enter a valid quantity';
                    }
                    if (isSpecialPrice && selectedSackPriceId != null) {
                      final sackPrice = product.sackPrice
                          .firstWhere((sp) => sp.id == selectedSackPriceId);
                      if (qty < (sackPrice.specialPrice?.minimumQty ?? 0)) {
                        return 'Minimum quantity for special price is ${sackPrice.specialPrice?.minimumQty}';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final qty = double.tryParse(value);
                    if (qty != null && qty > 0) {
                      setState(() {
                        quantity = qty;
                        quantityNotifier.value = qty;
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Create ProductDto to add to cart
                      if (selectedSackPriceId != null) {
                        // Using a sack price
                        final sackPrice = product.sackPrice
                            .firstWhere((sp) => sp.id == selectedSackPriceId);

                        final productDto = ProductDto(
                          id: product.id,
                          name: product.name,
                          isGantang: false,
                          isSpecialPrice: isSpecialPrice,
                          sackPrice: SackPriceDto(
                            id: sackPrice.id,
                            price: sackPrice.price,
                            quantity: quantity,
                            type: sackPrice.type,
                          ),
                        );

                        salesNotifier.addProductToCart(productDto);
                      } else if (product.perKiloPrice != null) {
                        // Using per kilo price
                        final perKiloPrice = product.perKiloPrice!;

                        final productDto = ProductDto(
                          id: product.id,
                          name: product.name,
                          isGantang: isGantang,
                          isSpecialPrice: false,
                          perKiloPrice: PerKiloPriceDto(
                            id: perKiloPrice.id,
                            price: perKiloPrice.price,
                            quantity: isGantang ? quantity * 2.25 : quantity,
                          ),
                        );

                        salesNotifier.addProductToCart(productDto);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product added to cart')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
