// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../app_config.dart';
import '../models/user.dart';

class AuthService {
  static final _storage = FlutterSecureStorage();

  static const _tokenKey = 'auth_token';

  static Future<String?> getToken() => _storage.read(key: _tokenKey);

  static Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  static Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${AppConfig.baseUrl}/auth/login');
    final res = await http.post(
    url,
    headers: {"Content-Type": "application/json"}, // 👈 ensure JSON
    body: jsonEncode({"email": email, "password": password}),
  );

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      final token = body['token'] ?? body['access_token'];
      if (token == null) throw Exception('Token missing in response');
      await saveToken(token);
      // optionally fetch user
      final user = body['user'];
      return {'token': token, 'user': user};
    } else {
      throw Exception('Login failed: ${res.statusCode} ${res.body}');
    }
  }

  static Future<User> fetchMe() async {
    final token = await getToken();
    final url = Uri.parse('${AppConfig.baseUrl}/auth/me');
    final res = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      return User.fromJson(body);
    } else {
      throw Exception('Failed to fetch user');
    }
  }
}
