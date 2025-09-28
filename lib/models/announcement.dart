// lib/models/announcement.dart
class Announcement {
  final String id;
  final String title;
  final String body;
  final DateTime postedAt;

  Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.postedAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      postedAt: DateTime.parse(json['posted_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
