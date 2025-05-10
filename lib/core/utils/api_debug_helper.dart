import 'dart:developer' as developer;

class ApiDebugHelper {
  static void debugResponse(dynamic response,
      {String? endpoint, String? method}) {
    try {
      developer.log('--------- API Response Debug ---------', name: 'API');
      if (endpoint != null) {
        developer.log('Endpoint: $endpoint', name: 'API');
      }
      if (method != null) {
        developer.log('Method: $method', name: 'API');
      }

      developer.log('Response Type: ${response.runtimeType}', name: 'API');

      if (response?.data != null) {
        developer.log('Data Type: ${response.data.runtimeType}', name: 'API');
        developer.log('Data: ${response.data}', name: 'API');

        if (response.data is List) {
          developer.log('List Length: ${(response.data as List).length}',
              name: 'API');
          if ((response.data as List).isNotEmpty) {
            developer.log(
                'First Item Type: ${(response.data as List).first.runtimeType}',
                name: 'API');
            developer.log('First Item: ${(response.data as List).first}',
                name: 'API');
          }
        }
      } else {
        developer.log('Data is null', name: 'API');
      }

      developer.log('-----------------------------------', name: 'API');
    } catch (e) {
      developer.log('Error debugging response: $e', name: 'API');
    }
  }
}
