// lib/providers/event_provider.dart
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  bool loading = false;

  List<Event> get events => _events;

  Future<void> loadEvents() async {
    loading = true;
    notifyListeners();
    try {
      _events = await ApiService.getEvents();
    } catch (e) {
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Event? findById(String id) {
    return _events.firstWhere((e) => e.id == id, orElse: () => throw Exception('Event not found'));
  }
}
