import 'dart:convert';

class AccountDashboardPromotion {
  final String title;
  final String subtitle;
  final String description;
  final String image;

  AccountDashboardPromotion({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
  });

  factory AccountDashboardPromotion.fromJson(Map<String, dynamic> json) {
    return AccountDashboardPromotion(
      title: json["title"] ?? '',
      subtitle: json["subtitle"] ?? '',
      description: json["description"] ?? '',
      image: json["image1"] ?? '',
    );
  }

  static List<AccountDashboardPromotion> listFromApi(Map<String, dynamic> json) {
    final List<dynamic> list = json["apiResponse"]["ResponseBody"]["promotions"];
    return list.map((e) => AccountDashboardPromotion.fromJson(e)).toList();
  }
}
