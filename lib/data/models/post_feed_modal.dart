

class Post {
  final String id;
  final String userId;
  final String imageUrl;
  final String description;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      userId: json['userId'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}