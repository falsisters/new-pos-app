// Create a provider for SecureStorage to handle my JWT bearer token, with the following features:
// Save JWT token
// Get JWT token
// Delete JWT token

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _singleton = SecureStorage._internal();
  static late FlutterSecureStorage _storage;

  factory SecureStorage() {
    return _singleton;
  }

  SecureStorage._internal() {
    _storage = FlutterSecureStorage();
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }
}
