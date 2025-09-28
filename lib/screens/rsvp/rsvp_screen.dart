import 'package:flutter/material.dart';
import '/services/rsvp_service.dart'; // Your fetchAllRsvps() method

class RsvpScreen extends StatefulWidget {
  const RsvpScreen({super.key});

  @override
  State<RsvpScreen> createState() => _RsvpScreenState();
}

class _RsvpScreenState extends State<RsvpScreen> {
  late Future<List<dynamic>> _rsvpsFuture;

  @override
  void initState() {
    super.initState();
    _rsvpsFuture = RsvpService.fetchAllRsvps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All RSVPs"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _rsvpsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          final data = snapshot.data!;

          // Group RSVPs by event
          Map<int, Map<String, dynamic>> eventMap = {};
          for (var item in data) {
            int eventId = item['event_id'];
            if (!eventMap.containsKey(eventId)) {
              eventMap[eventId] = {
                'title': item['title'],
                'rsvps': <Map<String, dynamic>>[],
              };
            }
            if (item['username'] != null) {
              eventMap[eventId]!['rsvps'].add({
                'username': item['username'],
                'role': item['role'],
                'status': item['rsvp_status'],
              });
            }
          }

          final eventList = eventMap.values.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: eventList.length,
            itemBuilder: (context, index) {
              final event = eventList[index];
              final rsvps = event['rsvps'] as List<dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Divider(color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      rsvps.isEmpty
                          ? const Text(
                              "No RSVPs yet",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: rsvps.map((r) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        r['status'] == 'Going'
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: r['status'] == 'Going'
                                            ? Colors.red
                                            : Colors.green,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                            "${r['username']} (${r['role']}): ${r['status']}"),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
