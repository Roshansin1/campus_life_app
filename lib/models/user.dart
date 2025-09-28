
class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final String role;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.role,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      avatarUrl: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'role': role,
        'avatar': avatarUrl,
      };
}
