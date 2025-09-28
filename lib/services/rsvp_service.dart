// lib/services/rsvp_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import 'auth_service.dart';

class RsvpService {
  // Fetch RSVPs for a specific event
  static Future<List<dynamic>> fetchAllRsvps() async {
    final token = await AuthService.getToken();
    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/rsvp/all'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Failed to fetch RSVPs');
    }
  }

  static Future<List<dynamic>> fetchRsvps(String eventId) async {
    final token = await AuthService.getToken();
    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/rsvp/$eventId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Failed to fetch RSVPs');
    }
  }

  static Future<void> submitRsvp(String eventId, String status) async {
    final token = await AuthService.getToken();
    final res = await http.post(
      Uri.parse('${AppConfig.baseUrl}/rsvp/$eventId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to submit RSVP');
    }
  }
}
