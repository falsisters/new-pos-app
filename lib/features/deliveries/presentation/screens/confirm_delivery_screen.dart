import 'package:falsisters_pos_android/core/constants/colors.dart';
import 'package:falsisters_pos_android/features/deliveries/data/providers/delivery_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ConfirmDeliveryScreen extends ConsumerStatefulWidget {
  const ConfirmDeliveryScreen({super.key});

  @override
  ConsumerState<ConfirmDeliveryScreen> createState() =>
      _ConfirmDeliveryScreenState();
}

class _ConfirmDeliveryScreenState extends ConsumerState<ConfirmDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _driverNameController = TextEditingController();
  final _focusNode = FocusNode();
  DateTime? _deliveryTimeStart;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Request focus when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _driverNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Only handle key down events to prevent duplicate triggers
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        _handleScheduleDelivery();
        return KeyEventResult.handled;
      }
      // Handle Escape key to go back
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        if (mounted && !_isProcessing) {
          Navigator.pop(context);
        }
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  Future<void> _handleScheduleDelivery() async {
    // Prevent multiple simultaneous submissions
    if (_isProcessing) return;

    final deliveryState = ref.read(deliveryProvider);
    if (deliveryState.valueOrNull?.truck.products.isEmpty ?? true) {
      _showErrorMessage('Cannot schedule an empty delivery.');
      return;
    }

    if (_formKey.currentState!.validate() && _deliveryTimeStart != null) {
      setState(() => _isProcessing = true);

      try {
        await ref.read(deliveryProvider.notifier).createDelivery(
              _driverNameController.text.trim(),
              _deliveryTimeStart!.toUtc(),
            );

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text('Delivery scheduled successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          _showErrorMessage('Failed to create delivery: $e');
        }
      } finally {
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    } else {
      _formKey.currentState!.validate();
      if (_deliveryTimeStart == null) {
        _showErrorMessage('Please select a delivery time');
      }
    }
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deliveryState = ref.watch(deliveryProvider);

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[50]!, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _buildDeliverySummaryPanel(deliveryState),
                        const SizedBox(width: 16),
                        _buildDriverInformationPanel(),
                      ],
                    ),
                  ),
                ),
                _buildScheduleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, size: 20),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_circle_rounded, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            'Confirm Delivery',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: _isProcessing ? null : () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliverySummaryPanel(AsyncValue deliveryState) {
    return Expanded(
      flex: 5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.15),
                    AppColors.secondary.withOpacity(0.08),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondary,
                          AppColors.secondary.withOpacity(0.8)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_shipping_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        deliveryState.when(
                          data: (state) => Text(
                            '${state.truck.products.length} item${state.truck.products.length > 1 ? "s" : ""} to deliver',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          loading: () => const SizedBox(height: 16),
                          error: (_, __) => const SizedBox(height: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Products List
            Expanded(
              child: deliveryState.when(
                data: (state) {
                  if (state.truck.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No items to deliver',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.truck.products.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = state.truck.products[index];
                      final quantity = product.sackPrice != null
                          ? '${product.sackPrice!.quantity.toStringAsFixed(0)} sack${product.sackPrice!.quantity > 1 ? "s" : ""}'
                          : '${product.perKiloPrice!.quantity.toStringAsFixed(1)} kg';

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.inventory_2_rounded,
                                color: AppColors.primary,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    quantity,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
                error: (error, _) => Center(
                  child: Text(
                    "Error: $error",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            // Total Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: deliveryState.when(
                data: (state) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Items',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '${state.truck.products.length}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                ),
                error: (_, __) => const Text("Error calculating total"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInformationPanel() {
    return Expanded(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver Info Header
              Row(
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
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Driver Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Driver Name Field
              TextFormField(
                controller: _driverNameController,
                enabled: !_isProcessing,
                onFieldSubmitted: (_) => _handleScheduleDelivery(),
                decoration: InputDecoration(
                  labelText: 'Driver Name',
                  labelStyle: TextStyle(color: AppColors.primary, fontSize: 14),
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.drive_eta_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the driver name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Delivery Time Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Delivery Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: _isProcessing ? null : _selectDeliveryTime,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _deliveryTimeStart == null
                          ? Colors.red.withOpacity(0.3)
                          : Colors.grey[300]!,
                      width: _deliveryTimeStart == null ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _deliveryTimeStart == null
                              ? Colors.red.withOpacity(0.1)
                              : AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.calendar_today_rounded,
                          color: _deliveryTimeStart == null
                              ? Colors.red
                              : AppColors.secondary,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _deliveryTimeStart == null
                              ? 'Select delivery time'
                              : DateFormat('MMM dd, yyyy - hh:mm a')
                                  .format(_deliveryTimeStart!),
                          style: TextStyle(
                            color: _deliveryTimeStart == null
                                ? Colors.red
                                : Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: _deliveryTimeStart == null
                            ? Colors.red
                            : AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ),

              if (_deliveryTimeStart == null)
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    'Please select a delivery time',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              // Delivery Notes (Optional)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.accent,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delivery Information',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Make sure all items are properly loaded and the driver has all necessary delivery documentation.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDeliveryTime() async {
    final result = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.datetime,
      initialDate: DateTime.now(),
    );

    if (result != null && mounted) {
      setState(() {
        _deliveryTimeStart = result;
      });
    }
  }

  Widget _buildScheduleButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _handleScheduleDelivery,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: AppColors.secondary.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isProcessing
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.schedule_send_rounded, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Schedule Delivery',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
