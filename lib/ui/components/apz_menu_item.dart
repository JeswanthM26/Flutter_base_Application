// lib/ui/components/menu_item.dart
import 'package:retail_application/themes/apz_app_themes.dart';
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
    required backgroundColor,
    required contentColor,
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
          color: AppColors.menuItemCardBackgroundColor(
              context), // inner grey background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 28,
                color:
                    AppColors.menuItemCardContentColor(context)), // white icon
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.menuItemCardContentColor(context),
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
