import 'package:falsisters_pos_android/features/deliveries/data/models/create_delivery_request_model.dart';
import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_product_dto_model.dart';
import 'package:falsisters_pos_android/features/deliveries/data/models/delivery_state_model.dart';
import 'package:falsisters_pos_android/features/deliveries/data/models/truck_model.dart';
import 'package:falsisters_pos_android/features/deliveries/data/repository/delivery_repository.dart';
import 'package:falsisters_pos_android/features/products/data/providers/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryNotifier extends AsyncNotifier<DeliveryStateModel> {
  final DeliveryRepository _deliveryRepository = DeliveryRepository();

  @override
  Future<DeliveryStateModel> build() async {
    return DeliveryStateModel(truck: TruckModel());
  }

  Future<void> addProductToTruck(DeliveryProductDtoModel product) async {
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final currentTruck = currentState.truck;

      // Create new truck with the added product
      final updatedTruck = TruckModel(
        products: [...currentTruck.products, product],
      );

      return DeliveryStateModel(truck: updatedTruck);
    });
  }

  Future<void> removeProductFromTruck(DeliveryProductDtoModel product) async {
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final currentTruck = currentState.truck;

      // Remove the product from the truck
      final updatedTruck = TruckModel(
        products: currentTruck.products
            .where((element) => element.id != product.id)
            .toList(),
      );

      return DeliveryStateModel(truck: updatedTruck);
    });
  }

  Future<void> createDelivery(
      String driverName, DateTime deliveryTimeStart) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentTruck = state.value!.truck;

      // Create a properly formatted request
      final createDeliveryRequest = CreateDeliveryRequestModel(
        deliveryItems: currentTruck.products,
        driverName: driverName,
        deliveryTimeStart: deliveryTimeStart,
      );

      // Submit the delivery to the server
      await _deliveryRepository.createDelivery(createDeliveryRequest);

      // Refresh products after successful delivery
      await ref.refresh(productProvider.notifier).getProducts();

      // Return clean state with empty truck
      return DeliveryStateModel(truck: TruckModel());
    });
  }
}
