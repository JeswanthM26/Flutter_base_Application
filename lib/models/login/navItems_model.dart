class MenuItemModel {
  final String screenID;
  final String YN;
  final String appID;
  final String menu;

  MenuItemModel({
    required this.screenID,
    required this.YN,
    required this.appID,
    required this.menu,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      screenID: json['screenID'] ?? '',
      YN: json['YN'] ?? '',
      appID: json['appID'] ?? '',
      menu: json['menu'] ?? '',
    );
  }
}
