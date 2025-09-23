import 'package:retail_application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/themes/common_properties.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ToastType { success, warning, error, info }

enum ToastAlignment { bottomCenter, topCenter }

class ApzToast extends StatefulWidget {
  final String title;
  final String message;
  final ToastType type;
  final ToastAlignment alignment;

  const ApzToast({
    required this.title,
    required this.message,
    required this.type,
    this.alignment = ToastAlignment.bottomCenter,
    super.key,
  });

  @override
  State<ApzToast> createState() => _AppzToastState();

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required ToastType type,
    ToastAlignment alignment = ToastAlignment.bottomCenter,
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: (MediaQuery.of(context).size.width - toast_width) / 2,
        bottom: alignment == ToastAlignment.bottomCenter ? 50 : null,
        top: alignment == ToastAlignment.topCenter ? 50 : null,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.vertical, // swipe left/right
          onDismissed: (_) => entry.remove(),
          child: ApzToast(
            title: title,
            message: message,
            type: type,
            // duration: duration,
            alignment: alignment,
          ),
        ),
      ),
    );

    overlay.insert(entry);

    // Auto-remove after duration
    Future.delayed(
        const Duration(seconds: 3) + const Duration(milliseconds: 500), () {
      if (entry.mounted) entry.remove();
    });
  }
}

class _AppzToastState extends State<ApzToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<ToastType, String> iconAssetPaths = {
    ToastType.success: 'assets/toast/Success.svg',
    ToastType.warning: 'assets/toast/Warning.svg',
    ToastType.error: 'assets/toast/Error.svg',
    ToastType.info: 'assets/toast/Info.svg',
  };

  // Helper to fetch matching semantic radius color from AppColors
  Color _getSemanticRadiusColor(BuildContext context, ToastType type) {
    switch (type) {
      case ToastType.success:
        return AppColors.semantaic_sucess_radius(context);
      case ToastType.warning:
        return AppColors.semantic_warning_radius(context);
      case ToastType.error:
        return AppColors.semantic_error_radius(context);
      case ToastType.info:
        return AppColors.semantic_info_radius(context);
      default:
        return AppColors.container_box(context);
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () async {
      await _animationController.reverse();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: toast_width,
          padding: toast_padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                _getSemanticRadiusColor(context, widget.type),
                AppColors.container_box(context),
                AppColors.container_box(context),
              ],
            ),
            borderRadius: BorderRadius.circular(toast_borderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.semantic_shadow(context),
                offset: toastShadowOffset,
                blurRadius: toastShadowBlurRadius,
                spreadRadius: toastShadowSpreadRadius,
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: toast_iconSize,
                height: toast_iconSize,
                child: SvgPicture.asset(
                  iconAssetPaths[widget.type]!,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: toast_spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ApzText(
                      label: widget.title,
                      color: AppColors.primary_text(context),
                      fontSize: toast_titleFontSize,
                      fontWeight: ApzFontWeight.titlesSemibold,
                    ),
                    ApzText(
                      label: widget.message,
                      color: AppColors.secondary_text(context),
                      fontSize: toast_messageFontSize,
                      fontWeight: ApzFontWeight.titlesRegular,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
