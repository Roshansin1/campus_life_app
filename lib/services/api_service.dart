// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import 'auth_service.dart';
import '../models/event.dart';
import '../models/announcement.dart';

class ApiService {
  static Future<List<Event>> getEvents() async {
    final token = await AuthService.getToken();
    final url = Uri.parse('${AppConfig.baseUrl}/events');
    final res = await http.get(url, headers: _authHeader(token));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  static Future<Event> getEvent(String id) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('${AppConfig.baseUrl}/events/$id');
    final res = await http.get(url, headers: _authHeader(token));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return Event.fromJson(data);
    } else {
      throw Exception('Failed to load event');
    }
  }

  static Future<List<Announcement>> getAnnouncements() async {
    final token = await AuthService.getToken();
    final url = Uri.parse('${AppConfig.baseUrl}/announcements');
    final res = await http.get(url, headers: _authHeader(token));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((a) => Announcement.fromJson(a)).toList();
    } else {
      throw Exception('Failed to load announcements');
    }
  }

  static Map<String, String> _authHeader(String? token) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  static Future<bool> rsvpEvent(String eventId) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('${AppConfig.baseUrl}/rsvp/$eventId');

    try {
      final res = await http.post(url, headers: _authHeader(token));

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        throw Exception(
          'RSVP failed with status ${res.statusCode}: ${res.body}',
        );
      }
    } catch (e) {
      throw Exception('Error during RSVP: $e');
    }
  }

  static Future<bool> rsvpEventWithStatus(String eventId, String status) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('${AppConfig.baseUrl}/rsvp/$eventId');

    final res = await http.post(
      url,
      headers: _authHeader(token),
      body: json.encode({'status': status}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) return true;

    throw Exception('RSVP failed with status ${res.statusCode}: ${res.body}');
  }

  static Future<void> postEvent(Map<String, dynamic> body) async {
    final token = await AuthService.getToken();
    final url = Uri.parse("http://192.168.1.103:5000/api/events");
    final response = await http.post(
      url,
      headers: _authHeader(token),
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create event: ${response.body}");
    }
  }
}
