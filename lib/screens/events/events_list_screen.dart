// lib/screens/events/events_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../widgets/event_card.dart';
import 'event_detail_screen.dart';

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  bool _init = true;
  bool _loading = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      _load();
      _init = false;
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await Provider.of<EventProvider>(context, listen: false).loadEvents();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    // Loading state
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Events")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Error state
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Events")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Error: $_error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // Empty events list
    if (events.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Events")),
        body: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 80),
              Icon(Icons.event_available,
                  size: 56, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              const Center(child: Text('No upcoming events')),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final created = await Navigator.pushNamed(context, '/create-event');
            if (created == true) {
              _load(); // refresh after new event
            }
          },
          child: const Icon(Icons.add),
        ),
      );
    }

    // Events list
    return Scaffold(
      appBar: AppBar(title: const Text("Events")),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: events.length,
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => EventDetailScreen(eventId: events[i].id),
              )),
              child: EventCard(event: events[i]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.pushNamed(context, '/create-event');
          if (created == true) {
            _load(); // refresh list if a new event was created
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
