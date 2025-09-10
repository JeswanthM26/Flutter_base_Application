// lib/ui/components/menu_item.dart
import 'package:flutter/material.dart';

class MenuItemCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const MenuItemCard({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 98,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: ShapeDecoration(
          color: Colors.grey.withOpacity(0.6), // inner grey background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
