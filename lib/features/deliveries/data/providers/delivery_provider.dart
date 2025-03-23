import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_state_model.dart';
import 'package:falsisters_pos_android/features/deliveries/data/providers/delivery_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deliveryProvider =
    AsyncNotifierProvider<DeliveryNotifier, DeliveryStateModel>(() {
  return DeliveryNotifier();
});
