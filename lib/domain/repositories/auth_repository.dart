abstract class AuthRepository {
  /// Retorna un token si el login es exitoso
  Future<String?> login({required String email, required String password});
}
