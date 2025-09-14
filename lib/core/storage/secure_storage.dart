import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _keyToken = 'AUTH_TOKEN';

  static Future<void> saveToken(String token) => _storage.write(key: _keyToken, value: token);
  static Future<String?> readToken() => _storage.read(key: _keyToken);
  static Future<void> deleteToken() => _storage.delete(key: _keyToken);
}
