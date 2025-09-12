import 'package:flutter/material.dart';

class MenuModel {
  final String label;
  final String icon;
  final String route;

  MenuModel({
    required this.label,
    required this.icon,
    required this.route,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      label: json['label'],
      icon: json['icon'],
      route: json['route'],
    );
  }

  IconData get iconData {
    switch (icon) {
      case 'local_offer_outlined':
        return Icons.local_offer_outlined;
      case 'payment':
        return Icons.payment;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'swap_horiz':
        return Icons.swap_horiz;
      case 'settings':
        return Icons.settings;
      case 'help_outline':
        return Icons.help_outline;
      case 'exit_to_app':
        return Icons.exit_to_app;
      default:
        return Icons.error;
    }
  }
}
