import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/deliveries/presentation/screens/confirm_delivery_screen.dart';
import 'package:falsisters_pos_android/features/deliveries/presentation/widgets/product_list.dart';
import 'package:falsisters_pos_android/features/deliveries/presentation/widgets/truck_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryScreen extends ConsumerStatefulWidget {
  const DeliveryScreen({super.key});

  @override
  ConsumerState<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends ConsumerState<DeliveryScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      _handleConfirmDelivery();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _handleConfirmDelivery() {
    // Navigate to confirm delivery screen
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const ConfirmDeliveryScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      autofocus: true,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.local_shipping_rounded, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Management',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Prepare and schedule deliveries',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[50]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Product listing (70% of space)
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const DeliveryProductList(),
                  ),
                ),

                const SizedBox(width: 12),

                // Truck list (30% of space)
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const TruckList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
