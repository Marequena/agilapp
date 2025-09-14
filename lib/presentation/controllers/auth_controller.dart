import 'package:flutter/material.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/storage/secure_storage.dart';

import 'dart:developer' as developer;

class AuthController extends ChangeNotifier {
  final AuthRepository _repo;
  String? _token;
  bool _loading = false;

  AuthController(this._repo);
  
  Future<void> init() async {
    try {
      final t = await SecureStorage.readToken();
      _token = t;
      notifyListeners();
    } catch (e, st) {
      developer.log('Failed to read token on init', error: e, stackTrace: st);
    }
  }

  bool get isAuthenticated => _token != null;
  bool get loading => _loading;

  Future<bool> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    final token = await _repo.login(email: email, password: password);
    _loading = false;
    if (token != null) {
      _token = token;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _token = null;
    await SecureStorage.deleteToken();
    notifyListeners();
  }
}
