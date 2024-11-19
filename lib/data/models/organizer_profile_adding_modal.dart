class OrganizerProfileAddingModal {
  final String? id;
  final String name;
  final String? bio;
  final String? imageUrl;
  final List<String>? links;

  OrganizerProfileAddingModal({
    this.id,
    required this.name,
    this.bio,
    this.imageUrl,
    this.links,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'imageUrl': imageUrl,
      'links': links,
    };
  }

  factory OrganizerProfileAddingModal.fromJson(Map<String, dynamic> json) {
    return OrganizerProfileAddingModal(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String?,
      imageUrl: json['imageUrl'] as String?,
      links: (json['links'] as List?)?.map((e) => e as String).toList(),
    );
  }
}