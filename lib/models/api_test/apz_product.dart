class ApzProduct {
  final int? id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category;

  ApzProduct({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
  });

  factory ApzProduct.fromJson(Map<String, dynamic> json) {
    return ApzProduct(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      image: json['image'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'category': category,
    };
  }
}