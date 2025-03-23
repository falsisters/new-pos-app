import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/deliveries/data/models/create_delivery_request_model.dart';

class DeliveryRepository {
  final DioClient _dio = DioClient();

  Future<Map<String, dynamic>> createDelivery(
      CreateDeliveryRequestModel delivery) async {
    try {
      final deliveryData = jsonEncode(delivery.toJson());
      final response =
          await _dio.instance.post('/delivery/create', data: deliveryData);

      if (response.data == null) {
        return {};
      }

      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
