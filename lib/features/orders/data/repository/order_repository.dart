import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/orders/data/models/order_model.dart';

class OrderRepository {
  final DioClient _dio = DioClient();

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _dio.instance.get('/order/cashier');

      print("Response data: ${response.data}");

      if (response.data == null) {
        return [];
      }

      return (response.data as List)
          .map((order) => OrderModel.fromJson(order))
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<OrderModel> rejectOrder(String orderId) async {
    try {
      final response = await _dio.instance.patch('/order/cancel/$orderId');

      if (response.data == null) {
        throw Exception('Failed to reject order');
      }

      return OrderModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<OrderModel> getOrderById(String id) async {
    try {
      final response = await _dio.instance.get('/order/cashier/$id');

      if (response.data == null) {
        throw Exception('Order not found');
      }

      // Handle case where the backend returns a list with one item instead of a single object
      if (response.data is List) {
        if ((response.data as List).isEmpty) {
          throw Exception('Order not found');
        }
        return OrderModel.fromJson((response.data as List).first);
      }

      return OrderModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
