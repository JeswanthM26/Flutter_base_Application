import 'package:Retail_Application/themes/common_properties.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';

class ApzButton extends StatefulWidget {
  final String? label;
  final ApzButtonAppearance appearance;
  final ApzButtonSize size;
  final bool disabled;
  final VoidCallback? onPressed;
  final IconData? iconLeading;
  final IconData? iconTrailing;
  final IconData? iconOnly;

  // New optional textColor parameter
  final Color? textColor;

  const ApzButton({
    Key? key,
    this.label,
    this.appearance = ApzButtonAppearance.primary,
    this.size = ApzButtonSize.large,
    this.disabled = false,
    this.onPressed,
    this.iconLeading,
    this.iconTrailing,
    this.iconOnly,
    this.textColor,
  }) : super(key: key);

  @override
  _AppzButtonState createState() => _AppzButtonState();
}

class _AppzButtonState extends State<ApzButton> {
  bool _isPressed = false;

  void _updatePressed(bool pressed) {
    if (widget.disabled) return;
    setState(() {
      _isPressed = pressed;
    });
  }

  Color _backgroundColor(BuildContext context) {
    // Transparent background for tertiary button always
    if (widget.appearance == ApzButtonAppearance.tertiary) {
      return AppColors.tertiary_button_default_background(context);
    }

    if (widget.disabled) {
      switch (widget.appearance) {
        case ApzButtonAppearance.primary:
          return AppColors.primary_button_disabled(context);
        case ApzButtonAppearance.secondary:
          return AppColors.secondary_button_disabled(context);
        case ApzButtonAppearance.tertiary:
          return AppColors.tertiary_button_default_background(context);
      }
    }

    if (_isPressed) {
      switch (widget.appearance) {
        case ApzButtonAppearance.primary:
          return AppColors.primary_button_pressed(context);
        case ApzButtonAppearance.secondary:
          return AppColors.secondary_button_pressed(context);
        case ApzButtonAppearance.tertiary:
          // No background change on pressed for tertiary
          return AppColors.tertiary_button_default_background(context);
      }
    }

    switch (widget.appearance) {
      case ApzButtonAppearance.primary:
        return AppColors.primary_button_default(context);
      case ApzButtonAppearance.secondary:
        return AppColors.secondary_button_default(context);
      case ApzButtonAppearance.tertiary:
        return AppColors.tertiary_button_default_background(context);
    }
  }

  Color _textColor(BuildContext context) {
    // Use provided textColor parameter if any
    if (widget.textColor != null) {
      return widget.textColor!;
    }
    if (widget.disabled) {
      return widget.appearance == ApzButtonAppearance.primary
          ? AppColors.button_text_white(context).withOpacity(0.6)
          : AppColors.button_text_black(context).withOpacity(0.6);
    }

    if (widget.appearance == ApzButtonAppearance.tertiary) {
      if (_isPressed) {
        return AppColors.tertiary_button_pressed(context);
      }
      return AppColors.tertiary_button_default(context);
    }

    switch (widget.appearance) {
      case ApzButtonAppearance.primary:
        return AppColors.button_text_white(context);
      case ApzButtonAppearance.secondary:
        return AppColors.button_text_black(context);
      default:
        return AppColors.tertiary_button_default(context);
    }
  }

  Widget _buildIcon(IconData icon, Color color, double size) {
    return Icon(icon, color: color, size: size);
  }

  @override
  Widget build(BuildContext context) {
    final height = buttonHeights[widget.size]!;
    final fontSize = buttonFontSizes[widget.size]!;

    final bgColor = _backgroundColor(context);
    final txtColor = _textColor(context);

    List<Widget> content = [];

    if (widget.iconOnly != null) {
      content.add(_buildIcon(widget.iconOnly!, txtColor, fontSize));
    } else {
      if (widget.iconLeading != null) {
        content.add(Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _buildIcon(widget.iconLeading!, txtColor, fontSize),
        ));
      }
      if (widget.label != null) {
        content.add(ApzText(
          label: widget.label!,
          color: txtColor,
          fontWeight: ApzFontWeight.titlesSemibold,
          fontSize: fontSize,
        ));
      }

      if (widget.iconTrailing != null) {
        content.add(Padding(
          padding: const EdgeInsets.only(left: 8),
          child: _buildIcon(widget.iconTrailing!, txtColor, fontSize),
        ));
      }
    }

    // Separate layout for tertiary button - no DecoratedBox, no background decoration,
    // only content inside a GestureDetector with SizedBox for height.
    // Changed to left aligned (remove Center, align start):
    if (widget.appearance == ApzButtonAppearance.tertiary) {
      return GestureDetector(
        onTapDown: (_) => _updatePressed(true),
        onTapUp: (_) => _updatePressed(false),
        onTapCancel: () => _updatePressed(false),
        onTap: widget.disabled ? null : widget.onPressed,
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: content,
          ),
        ),
      );
    }

    // Default layout for primary and secondary buttons with shadows
    return GestureDetector(
      onTapDown: (_) => _updatePressed(true),
      onTapUp: (_) => _updatePressed(false),
      onTapCancel: () => _updatePressed(false),
      child: SizedBox(
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(buttonCornerRadius),
            boxShadow: (widget.appearance == ApzButtonAppearance.primary ||
                    widget.appearance == ApzButtonAppearance.secondary)
                ? [
                    BoxShadow(
                      color: widget.appearance == ApzButtonAppearance.primary
                          ? AppColors.primary_shadow_1(context)
                          : AppColors.secondary_shadow_1(context),
                      offset: buttonShadowOffset1,
                      blurRadius: buttonShadowBlurRadius1,
                      spreadRadius: buttonShadowSpreadRadius1,
                    ),
                    BoxShadow(
                      color: widget.appearance == ApzButtonAppearance.primary
                          ? AppColors.primary_shadow_2(context)
                          : AppColors.secondary_shadow_2(context),
                      offset: buttonShadowOffset2,
                      blurRadius: buttonShadowBlurRadius2,
                      spreadRadius: buttonShadowSpreadRadius2,
                    ),
                  ]
                : null,
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: buttonPaddings[widget.size]!,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonCornerRadius),
              ),
              backgroundColor: Colors.transparent,
            ),
            onPressed: widget.disabled ? null : widget.onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: content,
            ),
          ),
        ),
      ),
    );
  }
}

enum ApzButtonAppearance { primary, secondary, tertiary }

enum ApzButtonSize { small, large }
