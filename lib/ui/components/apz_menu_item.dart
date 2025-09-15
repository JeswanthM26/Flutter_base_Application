// // lib/ui/components/menu_item.dart
// import 'package:flutter/material.dart';

// class MenuItemCard extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final VoidCallback onTap;

//   const MenuItemCard({
//     Key? key,
//     required this.label,
//     required this.icon,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         height: 98,
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//         decoration: ShapeDecoration(
//           color: Colors.grey.withOpacity(0.6), // inner grey background
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 28, color: Colors.white),
//             const SizedBox(height: 12),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/themes/common_properties.dart';
import 'package:flutter/material.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(menuItemCardBorderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.menuItemCardBackground(context),
          borderRadius: BorderRadius.circular(menuItemCardBorderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.menuItemCardContent(context),
              size: menuItemCardIconSize,
            ),
            const SizedBox(height: menuItemCardIconSpacing),
            Text(
              label,
              style: TextStyle(
                color: AppColors.menuItemCardContent(context),
                fontSize: menuItemCardLabelFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
