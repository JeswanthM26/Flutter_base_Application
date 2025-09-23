import 'package:retail_application/themes/common_properties.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:retail_application/themes/apz_app_themes.dart';

class ApzRadioItem extends StatefulWidget {
  final String label;
  final List<String> options;
  final String? defaultValue;
  final bool isDisabled;
  final bool isMandatory;
  final bool showError;
  final ValueChanged<String>? onChanged;

  const ApzRadioItem({
    Key? key,
    required this.label,
    required this.options,
    this.defaultValue,
    this.isDisabled = false,
    this.isMandatory = false,
    this.showError = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<ApzRadioItem> createState() => _AppzRadioItemState();
}

class _AppzRadioItemState extends State<ApzRadioItem> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.defaultValue;
  }

  void _handleSelection(String value) {
    if (widget.isDisabled) return;
    setState(() {
      _selected = value;
    });
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final showError =
        widget.isMandatory && widget.showError && _selected == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with optional asterisk
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ApzText(
              label: widget.label,
              color: AppColors.secondary_text(context),
              fontWeight: ApzFontWeight.labelRegular,
              fontSize: radio_label_fontSize,
            ),
            if (widget.isMandatory)
              ApzText(
                label: '*',
                color: AppColors.semantic_error(context),
                fontWeight: ApzFontWeight.labelRegular,
                fontSize: radio_label_fontSize,
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Options
        Wrap(
          spacing: radio_spacing,
          runSpacing: radio_spacing,
          children: widget.options.map((option) {
            final isSelected = _selected == option;
            final isDisabled = widget.isDisabled;

            // Colors depending on state and disabled status
            final borderColor = isDisabled
                ? AppColors.secondary_text(context).withOpacity(0.3)
                : (isSelected
                    ? AppColors.primary(context)
                    : AppColors.secondary_text(context).withOpacity(0.5));

            final innerColor = isDisabled
                ? (isSelected
                    ? AppColors.secondary_text(context).withOpacity(0.3)
                    : Colors.transparent)
                : (isSelected
                    ? AppColors.primary(context)
                    : Colors.transparent);

            final textColor = isDisabled
                ? AppColors.secondary_text(context).withOpacity(0.5)
                : AppColors.primary_text(context);

            return GestureDetector(
              onTap: () => _handleSelection(option),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Outer circle
                  Container(
                    width: radio_outerRadius * 2,
                    height: radio_outerRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderColor,
                        width: radio_borderWidth,
                      ),
                    ),
                    child: Center(
                      // Inner circle
                      child: Container(
                        width: radio_innerRadius * 2,
                        height: radio_innerRadius * 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: innerColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: radio_spacing),
                  ApzText(
                    label: option,
                    color: textColor,
                    fontWeight: ApzFontWeight.labelRegular,
                    fontSize: radio_option_fontSize,
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        // Error
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: ApzText(
              label: 'Please select an option',
              color: AppColors.semantic_error(context),
              fontWeight: ApzFontWeight.labelRegular,
              fontSize: radio_label_fontSize,
            ),
          ),
      ],
    );
  }
}
