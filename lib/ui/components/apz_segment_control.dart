import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/themes/common_properties.dart';

class ApzSegmentedControl extends StatelessWidget {
  final List<String> values;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const ApzSegmentedControl({
    super.key,
    required this.values,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: segmentedControlHeight,
      padding: segmentedPadding,
      decoration: BoxDecoration(
        color: AppColors.input_field_filled(context),
        borderRadius: BorderRadius.circular(segmentedCornerRadius),
      ),
      child: Row(
        children: List.generate(values.length, (index) {
          final bool selected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white
                      : AppColors.input_field_filled(
                          context), // <-- blend unselected
                  borderRadius: selected
                      ? BorderRadius.circular(segmentedOptionRadius)
                      : BorderRadius.zero, // <-- only selected rounded
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.semantic_shadow(context),
                            offset: segmentedShadowOffset,
                            blurRadius: segmentedShadowBlur,
                            spreadRadius: segmentedSpreadRadius,
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                height: segmentedControlHeight,
                child: ApzText(
                  label: values[index],
                  fontWeight: selected
                      ? ApzFontWeight.headingsBold
                      : ApzFontWeight.headingSemibold,
                  fontSize: segmentedFontSize,
                  color: selected
                      ? AppColors.primary_button_default(context)
                      : AppColors.secondary_button_default(context),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
