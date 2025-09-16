class FavoriteTransaction {
  final String name;
  final String? imageUrl;

  FavoriteTransaction({
    required this.name,
    this.imageUrl,
  });

  factory FavoriteTransaction.fromJson(Map<String, dynamic> json) {
    return FavoriteTransaction(
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}
