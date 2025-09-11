class ActionButtonModel {
  final String appID;
  final String icon;
  final String screenID;
  final String value;
  final String action;

  ActionButtonModel({
    required this.appID,
    required this.icon,
    required this.screenID,
    required this.value,
    required this.action,
  });

  factory ActionButtonModel.fromJson(Map<String, dynamic> json) {
    return ActionButtonModel(
      appID: json['appID'] ?? "",
      icon: json['icon'] ?? "",
      screenID: json['screenID'] ?? "",
      value: json['value'] ?? "",
      action: json['action'] ?? "",
    );
  }
}
