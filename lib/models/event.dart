
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startAt;
  final DateTime? endAt;
  final String? imageUrl;
  final String? location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startAt,
    this.endAt,
    this.imageUrl,
    this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startAt: DateTime.parse(json['start_at'] ?? json['startAt'] ?? DateTime.now().toIso8601String()),
      endAt: json['end_at'] != null ? DateTime.tryParse(json['end_at']) : null,
      imageUrl: json['image_url'] as String?,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'start_at': startAt.toIso8601String(),
        'end_at': endAt?.toIso8601String(),
        'image_url': imageUrl,
        'location': location,
      };
}
