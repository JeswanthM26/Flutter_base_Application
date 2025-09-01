import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';

class FontStylesScreen extends StatelessWidget {
  const FontStylesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Font Styles Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 12),
            ApzText(
              label: "labelRegular",
              fontWeight: ApzFontWeight.labelRegular,
             // fontSize: 16,
              color: AppColors.semantic_sucess(context),
            ),
            const SizedBox(height: 12),
            ApzText(
              label: "buttonTextMedium",
              fontWeight: ApzFontWeight.buttonTextMedium,
              //fontSize: 16,
              color: AppColors.semantic_error(context),
            ),
            const SizedBox(height: 12),
            ApzText(
              label: "captionSemibold",
              fontWeight: ApzFontWeight.captionSemibold,
              //fontSize: 16,
              color: AppColors.semantic_warning(context),
            ),
            const SizedBox(height: 12),
            ApzText(
              label: "bodyRegular",
              fontWeight: ApzFontWeight.bodyRegular,
              fontSize: 16,
              color: AppColors.semantic_info(context),
            ),
            const SizedBox(height: 12),
            ApzText(
              label: "bodyMedium",
              fontWeight: ApzFontWeight.bodyMedium,
              fontSize: 16,
              color: AppColors.semantic_info(context),
            ),
            const SizedBox(height: 12),
            ApzText(
              label: "titlesRegular",
              fontWeight: ApzFontWeight.titlesRegular,
              fontSize: 16,
              color: AppColors.semantic_info(context),
            ),
            const SizedBox(height: 12),
            ApzText(
              label: "titlesSemibold",
              fontWeight: ApzFontWeight.titlesSemibold,
              fontSize: 16,
              color: AppColors.semantic_info(context),
            ),
            const SizedBox(height: 12),
            ApzText(
              label: "titlesMedium",
              fontWeight: ApzFontWeight.titlesMedium,
              fontSize: 16,
              color: AppColors.semantic_info(context),
            ),
            const SizedBox(height: 12),
            ApzText(
              label: "headingSemibold",
              fontWeight: ApzFontWeight.headingSemibold,
              fontSize: 16,
              color: AppColors.semantic_info(context),
            ),
            const SizedBox(height: 12),
            ApzText(
              label: "headingsMedium",
              fontWeight: ApzFontWeight.headingsMedium,
              fontSize: 16,
              //color: AppColors.semantic_info(context),
            ),
            const SizedBox(height: 12),
            ApzText(
              label: "headingsBold",
              fontWeight: ApzFontWeight.headingsBold,
              fontSize: 16,
              //color: AppColors.semantic_info(context),
            ),
            const SizedBox(height: 12),
            ApzText(
              label: "displayHeadingExpandedRegular",
              fontWeight: ApzFontWeight.displayHeadingExpandedRegular,
              fontSize: 16,
              color: AppColors.semantic_info(context),
            ),
          ],
        ),
      ),
    );
  }
}
