import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/sales/data/constants/parse_payment_method.dart';
import 'package:falsisters_pos_android/features/sales/data/model/create_sale_request_model.dart';
import 'package:falsisters_pos_android/features/sales/data/model/product_dto.dart';
import 'package:falsisters_pos_android/features/sales/data/providers/sales_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends ConsumerWidget {
  final List<ProductDto> products;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.products,
    required this.total,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesNotifier = ref.watch(salesProvider.notifier);
    final formKey = GlobalKey<FormState>();

    final paymentMethodController = TextEditingController();

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
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text('Checkout', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                const Text('Products', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: product.sackPrice != null
                          ? Text('Price: ${product.sackPrice!.price}')
                          : Text('Price: ${product.perKiloPrice!.price}'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Create a dropdown that maps the values of PaymentMethod
                // to a string representation
                const Text('Payment Method', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                DropdownButtonFormField<PaymentMethod>(
                  items: PaymentMethod.values
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(parsePaymentMethod(e)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      paymentMethodController.text = value.toString();
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a payment method';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Total', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text(total.toString()),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final paymentMethod = PaymentMethod.values.firstWhere(
                        (e) => e.toString() == paymentMethodController.text,
                      );
                      salesNotifier.createSale(
                        total,
                        paymentMethod,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ));
  }
}
