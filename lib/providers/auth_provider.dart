
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? user;
  String? token;
  bool get isAuthenticated => token != null;

  Future<void> tryAutoLogin() async {
    token = await AuthService.getToken();
    if (token != null) {
      try {
        user = await AuthService.fetchMe();
      } catch (e) {
        await logout();
      }
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final result = await AuthService.login(email, password);
    token = result['token'];
    if (result['user'] != null) {
      user = User.fromJson(result['user']);
    } else {
      user = await AuthService.fetchMe();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.deleteToken();
    token = null;
    user = null;
    notifyListeners();
  }
}
