// lib/screens/events/event_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  const EventDetailScreen({required this.eventId, super.key});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Event? event;
  bool loading = true;
  String? error;
  bool rsvpLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  Future<void> _loadEvent() async {
    setState(() { loading = true; error = null; });
    try {
      final e = await ApiService.getEvent(widget.eventId);
      setState(() { event = e; });
    } catch (e) {
      setState(() { error = e.toString(); });
    } finally {
      setState(() { loading = false; });
    }
  }

  // Show dialog to select RSVP status
  void _showRsvpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('RSVP to Event'),
        content: const Text('Select your RSVP status:'),
        actions: [
          TextButton(
            onPressed: () { Navigator.pop(context); _rsvp('Going'); },
            child: const Text('Going'),
          ),
          TextButton(
            onPressed: () { Navigator.pop(context); _rsvp('Not Going'); },
            child: const Text('Not Going'),
          ),
        ],
      ),
    );
  }

  // Call API to RSVP
  Future<void> _rsvp(String status) async {
    setState(() { rsvpLoading = true; });
    try {
      await ApiService.rsvpEventWithStatus(widget.eventId, status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('RSVP "$status" saved successfully!')),
      );
      Navigator.pop(context, true); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to RSVP: $e')),
      );
    } finally {
      setState(() { rsvpLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
    if (error != null) return Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $error')));

    final f = DateFormat.yMMMd().add_jm();

    return Scaffold(
      appBar: AppBar(title: Text(event!.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event!.imageUrl != null)
              CachedNetworkImage(
                imageUrl: event!.imageUrl!,
                placeholder: (_, __) => Container(height: 200, child: const Center(child: CircularProgressIndicator())),
                errorWidget: (_, __, ___) => Container(height: 200, color: Colors.grey[300], child: const Icon(Icons.broken_image)),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(event!.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('${f.format(event!.startAt)}' + (event!.endAt != null ? ' — ${f.format(event!.endAt!)}' : '')),
                const SizedBox(height: 12),
                if (event!.location != null) Row(children: [const Icon(Icons.location_on), const SizedBox(width: 6), Expanded(child: Text(event!.location!))]),
                const SizedBox(height: 12),
                Text(event!.description),
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: rsvpLoading ? null : _showRsvpDialog,
        tooltip: 'RSVP',
        child: rsvpLoading ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.add),
      ),
    );
  }
}
