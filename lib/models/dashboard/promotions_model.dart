import 'dart:convert';

class Promotion {
  final String title;
  final String subtitle;
  final String image1;
 

  Promotion({
    required this.title,
    required this.subtitle,
    required this.image1,

  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      title: json["title"] ?? '',
      subtitle: json["subtitle"] ?? '',
      image1: json["image1"] ?? '',
  
    );
  }
  static List<Promotion> listFromApi(Map<String, dynamic> json) {
    final List<dynamic> list = json["apiResponse"]["ResponseBody"]["promotions"];
    return list.map((e) => Promotion.fromJson(e)).toList();
  }
}
