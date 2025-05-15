import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/create_expense_list.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/expense_list.dart';

class ExpenseRepository {
  final DioClient _dio = DioClient();

  Future<ExpenseList> getExpenseList() async {
    try {
      final response = await _dio.instance.get('/expenses/today');

      return ExpenseList.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<ExpenseList> getExpenseListByDate(DateTime date) async {
    try {
      final formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response =
          await _dio.instance.get('/expenses/today', queryParameters: {
        'date': formattedDate,
      });

      return ExpenseList.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<ExpenseList> createExpense(CreateExpenseList expenseList) async {
    try {
      final expenseData = jsonEncode(expenseList.toJson());

      final response =
          await _dio.instance.post('/expenses/create', data: expenseData);

      return ExpenseList.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<ExpenseList> updateExpense(
      String id, CreateExpenseList expenseList) async {
    try {
      final expenseData = jsonEncode(expenseList.toJson());

      final response =
          await _dio.instance.put('/expenses/update/$id', data: expenseData);

      return ExpenseList.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.error);
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
