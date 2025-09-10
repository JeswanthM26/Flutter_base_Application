class Story {
  final String imageUrl;
  final String title;
  final String description;

  Story({
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
    };
  }
}
