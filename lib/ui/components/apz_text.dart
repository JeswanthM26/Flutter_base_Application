import 'package:flutter/material.dart';
import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/themes/common_properties.dart';

class ApzText extends StatelessWidget {
  final String label;
  final ApzFontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  
const ApzText({
  super.key,
  required this.label,  
  this.fontWeight,
  this.fontSize,
  this.color,
});

  @override
  Widget build(BuildContext context) {
    // Determine the final font weight. Use bodyRegular as a sensible default.
    final FontWeight finalFontWeight =
        (fontWeight ?? ApzFontWeight.bodyRegular).value;

    // Determine the final font size, falling back to the one in common_properties.
    final double finalFontSize = fontSize ?? defaultFontSize;

    // Determine the final color, falling back to the primary text color from the theme.
    final Color finalColor = color ?? AppColors.primary_text(context);

    return Text(
      label,
      style: TextStyle(
        color: finalColor,
        fontSize: finalFontSize,
        fontWeight: finalFontWeight,
      ),
    );
  }
}
enum ApzFontWeight {
  labelRegular,
  buttonTextMedium,
  captionSemibold,
  bodyRegular,
  bodyMedium,
  titlesRegular,
  titlesSemibold,
  titlesMedium,
  headingSemibold,
  headingsMedium,
  headingsBold,
  displayHeadingExpandedRegular,
}

extension ApzFontWeightExtension on ApzFontWeight {
  FontWeight get value {
    switch (this) {
      case ApzFontWeight.labelRegular:
        return FontWeight.w400; // 400
      case ApzFontWeight.buttonTextMedium:
        return FontWeight.w500; // Mapped from 510
      case ApzFontWeight.captionSemibold:
        return FontWeight.w600; // Mapped from 590
      case ApzFontWeight.bodyRegular:
        return FontWeight.w400; // 400
      case ApzFontWeight.bodyMedium:
        return FontWeight.w500; // Mapped from 510
      case ApzFontWeight.titlesRegular:
        return FontWeight.w400; // 400
      case ApzFontWeight.titlesSemibold:
        return FontWeight.w600; // Mapped from 590
      case ApzFontWeight.titlesMedium:
        return FontWeight.w500; // Mapped from 510
      case ApzFontWeight.headingSemibold:
        return FontWeight.w600; // Mapped from 590
      case ApzFontWeight.headingsMedium:
        return FontWeight.w400; // Mapped from 410
      case ApzFontWeight.headingsBold:
        return FontWeight.w700; // 700
      case ApzFontWeight.displayHeadingExpandedRegular:
        return FontWeight.w400; // Mapped from 410
    }
  }
}
