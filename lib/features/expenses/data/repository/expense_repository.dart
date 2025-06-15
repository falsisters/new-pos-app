import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falsisters_pos_android/core/handlers/dio_client.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/create_expense_list.dart';
import 'package:falsisters_pos_android/features/expenses/data/models/expense_list.dart';
import 'package:flutter/foundation.dart';

class ExpenseRepository {
  final DioClient _dio = DioClient();

  Future<ExpenseList?> getExpenseList() async {
    try {
      final response = await _dio.instance.get('/expenses/today');
      debugPrint("GetExpenseList response: ${response.data}");

      if (response.data == null) {
        debugPrint("GetExpenseList returned null data");
        return null;
      }

      return ExpenseList.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        debugPrint("DioException in getExpenseList: ${e.toString()}");
        throw Exception(e.error);
      } else {
        debugPrint("Error in getExpenseList: ${e.toString()}");
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<ExpenseList?> getExpenseListByDate(DateTime date) async {
    try {
      // Format date as YYYY-MM-DD
      final formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      debugPrint("Fetching expenses for date: $formattedDate");

      final response = await _dio.instance.get(
        '/expenses/today',
        queryParameters: {
          'date': formattedDate,
        },
      );

      debugPrint("GetExpenseListByDate response: ${response.data}");

      if (response.data == null) {
        debugPrint("No expense data found for date: $formattedDate");
        return null;
      }

      return ExpenseList.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        debugPrint("DioException in getExpenseListByDate: ${e.toString()}");
        debugPrint("Response data: ${e.response?.data}");
        throw Exception(e.message ?? e.error);
      } else {
        debugPrint("Error in getExpenseListByDate: ${e.toString()}");
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<ExpenseList?> createExpense(CreateExpenseList expenseList) async {
    try {
      final expenseData = jsonEncode(expenseList.toJson());
      debugPrint("Creating expense with data: $expenseData");

      final response =
          await _dio.instance.post('/expenses/create', data: expenseData);
      debugPrint("Create expense response: ${response.data}");

      if (response.data == null) {
        debugPrint("CreateExpense returned null data");
        return null;
      }

      return ExpenseList.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        debugPrint("DioException in createExpense: ${e.toString()}");
        debugPrint("Response data: ${e.response?.data}");
        throw Exception(e.message ?? e.error);
      } else {
        debugPrint("Error in createExpense: ${e.toString()}");
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<ExpenseList?> updateExpense(
      String id, CreateExpenseList expenseList) async {
    try {
      final expenseData = jsonEncode(expenseList.toJson());
      debugPrint("Updating expense ID: $id with data: $expenseData");

      final response =
          await _dio.instance.put('/expenses/update/$id', data: expenseData);
      debugPrint("Update expense response: ${response.data}");

      if (response.data == null) {
        debugPrint("UpdateExpense returned null data");
        return null;
      }

      return ExpenseList.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        debugPrint("DioException in updateExpense: ${e.toString()}");
        debugPrint("Response data: ${e.response?.data}");
        throw Exception(e.message ?? e.error);
      } else {
        debugPrint("Error in updateExpense: ${e.toString()}");
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      debugPrint("Deleting expense ID: $id");

      final response = await _dio.instance.delete('/expenses/$id');
      debugPrint("Delete expense response: ${response.statusCode}");
    } catch (e) {
      if (e is DioException) {
        debugPrint("DioException in deleteExpense: ${e.toString()}");
        debugPrint("Response data: ${e.response?.data}");
        throw Exception(e.message ?? e.error);
      } else {
        debugPrint("Error in deleteExpense: ${e.toString()}");
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }
}
