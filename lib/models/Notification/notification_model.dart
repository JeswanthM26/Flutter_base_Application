import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  final int notifId;

  final String appId;

  final String notifMsg;

  final String title;

  final String category;

  final String createTs;

  final String formatDate;

  NotificationModel({
    required this.notifId,
    required this.appId,
    required this.notifMsg,
    required this.title,
    required this.category,
    required this.createTs,
    required this.formatDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        notifId: json["notifId"],
        appId: json["appId"],
        notifMsg: json["notifMsg"],
        title: json["title"],
        category: json["category"],
        createTs: json["createTs"],
        formatDate: json["formatDate"],
      );

  Map<String, dynamic> toJson() => {
        "notifId": notifId,
        "appId": appId,
        "notifMsg": notifMsg,
        "title": title,
        "category": category,
        "createTs": createTs,
        "formatDate": formatDate,
      };
}
