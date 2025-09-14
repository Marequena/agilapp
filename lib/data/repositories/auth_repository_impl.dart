import '../../domain/repositories/auth_repository.dart';
import '../datasources/api_client.dart';
import '../../core/storage/secure_storage.dart';
import 'dart:developer' as developer;

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.create();

  @override
  Future<String?> login({required String email, required String password}) async {
    final res = await _apiClient.post('/api/login', data: {'email': email, 'password': password});
    try {
      if (res.statusCode == 200 && res.data != null) {
        final data = res.data;
        if (data is Map && data['token'] != null) {
          final token = data['token'].toString();
          await SecureStorage.saveToken(token);
          return token;
        }
      }
    } catch (e, st) {
      developer.log('Auth login parse failed', error: e, stackTrace: st);
    }
    return null;
  }
}
