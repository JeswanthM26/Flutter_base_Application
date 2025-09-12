import 'package:flutter/material.dart';

/// Model class for menu items
class MenuOption {
  final String icon;
  final String label;
  final String route;

  const MenuOption({
    required this.icon,
    required this.label,
    required this.route,
  });
}
