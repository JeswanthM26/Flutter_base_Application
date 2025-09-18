import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/themes/common_properties.dart';
import 'package:Retail_Application/ui/components/apz_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ApzHeader extends StatelessWidget {
  final bool hasNotification;
  final String avatarUrl;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;

  const ApzHeader({
    super.key,
    this.hasNotification = false,
    this.avatarUrl = "https://placehold.co/40x40",
    this.onProfileTap,
    this.onNotificationTap,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: header_padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Leading Icon (Logo)
          Container(
            width: header_leadingIconContainerSize,
            height: header_leadingIconContainerSize,
            decoration: ShapeDecoration(
              color: AppColors.container_box(context),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(header_leadingIconBorderRadius),
              ),
              shadows: [
                BoxShadow(
                  color: AppColors.primary_shadow_1(context),
                  blurRadius: 4,
                  offset: const Offset(2, -2),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Theme.of(context).brightness == Brightness.dark
                ? SvgPicture.asset(
                    'assets/images/dark_icon.svg',
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    'assets/images/Icon.png',
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(width: header_spacing),

          // 2. Search Bar (Reusable)
          Expanded(
            child: GestureDetector(
              onTap: onSearchTap,
              child: ApzSearchBar(
                type: AppzSearchBarType.primary,
                placeholder: 'Search..',
                trailingIcon: const Icon(Icons.mic),
                onTrailingPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mic icon pressed')),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: header_spacing),

          // 3. Notification Icon with Red Dot
          GestureDetector(
            onTap: onNotificationTap,
            child: Stack(
              children: [
                Icon(
                  Icons.notifications_none,
                  size: header_notificationIconSize,
                  color: AppColors.header_icon_color(context),
                ),
                if (hasNotification)
                  Positioned(
                    right: 0,
                    top: 2,
                    child: Container(
                      width: header_notificationDotSize,
                      height: header_notificationDotSize,
                      decoration: BoxDecoration(
                        color: AppColors.semantic_error(context),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: header_spacing),

          // 4. Profile Icon (Circular, Clickable)
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: header_profileIconContainerSize,
              height: header_profileIconContainerSize,
              decoration: BoxDecoration(
                color: AppColors.input_field_filled(
                    context), // Placeholder background
                borderRadius:
                    BorderRadius.circular(header_profileIconBorderRadius),
              ),
              child: Icon(Icons.person,
                  size: header_profileIconSize,
                  color: AppColors.secondary_text(context)),
            ),
          ),
        ],
      ),
    );
  }
}
