class User {
  final String id;
  final String name;
  final String username;

  User({
    required this.id,
    required this.name,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matricula': id,
      'name': name,
      'username': username,
    };
  }

  @override
  String toString() {
    return name;
  }
}
