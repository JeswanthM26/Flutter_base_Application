import 'package:flutter/material.dart';

/// Model class for menu items
class MenuOption {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
