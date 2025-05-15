import 'dart:convert';

/// Utility class to handle API responses in a consistent way
class ApiResponseHandler {
  /// Safely parses any API response into a list
  /// Returns empty list if response cannot be parsed or is empty
  static List<T> parseList<T>(
    dynamic response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      // Handle null response
      if (response == null) {
        print('API response is null');
        return [];
      }

      // Handle empty string response
      if (response is String && response.isEmpty) {
        print('API response is an empty string');
        return [];
      }

      // Handle String response by attempting to parse as JSON
      if (response is String) {
        try {
          final parsed = jsonDecode(response);
          if (parsed is List) {
            return parsed.map((item) => fromJson(item)).toList();
          } else {
            print('Parsed JSON is not a list: ${parsed.runtimeType}');
            return [];
          }
        } catch (e) {
          print('Failed to parse JSON string: $e');
          return [];
        }
      }

      // Handle List response directly
      if (response is List) {
        return response.map((item) => fromJson(item)).toList();
      }

      // Handle Map response with potential data/items field
      if (response is Map) {
        if (response['data'] is List) {
          return (response['data'] as List)
              .map((item) => fromJson(item))
              .toList();
        }
        if (response['items'] is List) {
          return (response['items'] as List)
              .map((item) => fromJson(item))
              .toList();
        }
        if (response['sales'] is List) {
          return (response['sales'] as List)
              .map((item) => fromJson(item))
              .toList();
        }

        print('Map response does not contain expected list field');
        return [];
      }

      // If we reach here, the response format is unexpected
      print('Unexpected response format: ${response.runtimeType}');
      return [];
    } catch (e) {
      print('Error parsing API response: $e');
      return [];
    }
  }
}
