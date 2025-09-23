import 'package:retail_application/models/checkbox/apz_checkboxItem.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:retail_application/themes/common_properties.dart';
import 'package:retail_application/themes/apz_app_themes.dart';

class ApzCheckboxController extends ChangeNotifier {
  String _value = "no";
  List<int> _selectedIndices = [];
  bool _enabled = true;

  String get value => _value;
  List<int> get selectedIndices => List.unmodifiable(_selectedIndices);
  bool get enabled => _enabled;

  void setValue(String value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }

  void toggle() {
    setValue(_value == "yes" ? "no" : "yes");
  }

  void setSelectedIndices(List<int> indices) {
    if (_selectedIndices != indices) {
      _selectedIndices = List.from(indices);
      notifyListeners();
    }
  }

  void toggleIndex(int index) {
    final newIndices = List<int>.from(_selectedIndices);
    if (newIndices.contains(index)) {
      newIndices.remove(index);
    } else {
      newIndices.add(index);
    }
    setSelectedIndices(newIndices);
  }

  void setEnabled(bool enabled) {
    if (_enabled != enabled) {
      _enabled = enabled;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ApzCheckbox extends StatefulWidget {
  final String? value;
  final ValueNotifier<String>? valueNotifier;
  final String? label;
  final String? subtitle;
  final ApzCheckboxAlignment alignment;
  final ApzCheckboxVariant variant;
  final bool enabled;
  final List<ApzCheckboxItem>? groupItems;
  final ValueNotifier<List<int>>? selectedIndicesNotifier;
  final ApzCheckboxController? controller;
  final VoidCallback? onTap;

  const ApzCheckbox({
    super.key,
    this.value,
    this.valueNotifier,
    this.label,
    this.subtitle,
    this.alignment = ApzCheckboxAlignment.left,
    this.variant = ApzCheckboxVariant.single,
    this.enabled = true,
    this.groupItems,
    this.selectedIndicesNotifier,
    this.controller,
    this.onTap,
  }) : assert(
          (variant == ApzCheckboxVariant.group &&
                  (selectedIndicesNotifier != null || controller != null)) ||
              (variant == ApzCheckboxVariant.single &&
                  (valueNotifier != null ||
                      value != null ||
                      controller != null)),
          'For single variant: either valueNotifier, value, or controller must be provided. For group variant: either selectedIndicesNotifier or controller must be provided.',
        );

  @override
  State<ApzCheckbox> createState() => _AppzCheckboxState();
}

class _AppzCheckboxState extends State<ApzCheckbox> {
  ValueNotifier<String>? _localValueNotifier;

  @override
  void initState() {
    super.initState();

    if (widget.variant == ApzCheckboxVariant.single &&
        widget.valueNotifier == null &&
        widget.value != null &&
        widget.controller == null) {
      _localValueNotifier = ValueNotifier<String>(widget.value!);
    }

    if (widget.controller != null) {
      widget.controller!.addListener(_onControllerChanged);
    }
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _localValueNotifier?.dispose();
    if (widget.controller != null) {
      widget.controller!.removeListener(_onControllerChanged);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variant == ApzCheckboxVariant.group) {
      return _buildCheckboxGroup(context);
    }

    final valueNotifier = widget.controller != null
        ? ValueNotifier<String>(widget.controller!.value)
        : widget.valueNotifier ??
            _localValueNotifier ??
            ValueNotifier<String>("no");

    return ValueListenableBuilder<String>(
      valueListenable: valueNotifier,
      builder: (context, value, _) {
        final bool isEnabled = widget.controller?.enabled ?? widget.enabled;
        final primaryTextColor = AppColors.primary_text(context);
        final secondaryTextColor = AppColors.secondary_text(context);
        final primaryColor = AppColors.primary(context);

        final borderColor =
            isEnabled ? primaryTextColor : primaryTextColor.withOpacity(0.5);

        Widget checkboxWidget = GestureDetector(
          onTap: isEnabled
              ? () {
                  widget.onTap?.call();
                  if (widget.controller != null) {
                    widget.controller!.toggle();
                  } else {
                    valueNotifier.value = value == "yes" ? "no" : "yes";
                  }
                }
              : null,
          child: SizedBox(
            width: checkbox_containerWidth,
            height: checkbox_containerHeight,
            child: Stack(
              children: [
                Positioned(
                  left: (checkbox_containerWidth - checkbox_width) / 2,
                  top: (checkbox_containerHeight - checkbox_height) / 2,
                  child: Container(
                    width: checkbox_width,
                    height: checkbox_height,
                    decoration: BoxDecoration(
                      color: value == "yes" && isEnabled
                          ? primaryColor
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(checkbox_borderRadius),
                      border: Border.all(
                        width: checkbox_borderWidth,
                        color: value == "yes" && isEnabled
                            ? primaryColor
                            : borderColor,
                      ),
                    ),
                    child: value == "yes" && isEnabled
                        ? Center(
                            child: Icon(
                              Icons.check,
                              size: checkbox_iconSize,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );

        Widget? textContent;
        if (widget.variant == ApzCheckboxVariant.single &&
            widget.label != null &&
            widget.label!.trim().isNotEmpty) {
          if (widget.subtitle != null && widget.subtitle!.trim().isNotEmpty) {
            // Both label and subtitle present
            textContent = Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ApzText(
                    label: widget.label!,
                    fontWeight: ApzFontWeight.labelRegular,
                    fontSize: checkbox_label_fontSize,
                    color: isEnabled
                        ? primaryTextColor
                        : primaryTextColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 4),
                  ApzText(
                    label: widget.subtitle!,
                    fontWeight: ApzFontWeight.labelRegular,
                    fontSize: checkbox_subtitle_fontSize,
                    color: isEnabled
                        ? secondaryTextColor
                        : secondaryTextColor.withOpacity(0.5),
                  ),
                ],
              ),
            );
          } else {
            // Only label provided, style it like subtitle
            textContent = Expanded(
              child: ApzText(
                label: widget.label!,
                fontWeight: ApzFontWeight.labelRegular,
                fontSize: checkbox_subtitle_fontSize,
                color: isEnabled
                    ? secondaryTextColor
                    : secondaryTextColor.withOpacity(0.5),
              ),
            );
          }
        } else if (widget.variant == ApzCheckboxVariant.group &&
            widget.label != null &&
            widget.label!.trim().isNotEmpty) {
          // Group label styled as subtitle, ignore subtitle prop
          textContent = Expanded(
            child: ApzText(
              label: widget.label!,
              fontWeight: ApzFontWeight.labelRegular,
              fontSize: checkbox_subtitle_fontSize,
              color: isEnabled
                  ? secondaryTextColor
                  : secondaryTextColor.withOpacity(0.5),
            ),
          );
        }

        if (widget.alignment == ApzCheckboxAlignment.left) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              checkboxWidget,
              if (textContent != null) ...[
                SizedBox(width: checkbox_spacing),
                textContent,
              ],
            ],
          );
        } else {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (textContent != null) ...[
                textContent,
                SizedBox(width: checkbox_spacing),
              ],
              checkboxWidget,
            ],
          );
        }
      },
    );
  }

  Widget _buildCheckboxGroup(BuildContext context) {
    final bool isEnabled = widget.controller?.enabled ?? widget.enabled;
    final primaryTextColor = AppColors.primary_text(context);
    final secondaryTextColor = AppColors.secondary_text(context);
    final primaryColor = AppColors.primary(context);

    final borderColor =
        isEnabled ? primaryTextColor : primaryTextColor.withOpacity(0.5);

    final selectedIndicesNotifier = widget.controller != null
        ? ValueNotifier<List<int>>(widget.controller!.selectedIndices)
        : widget.selectedIndicesNotifier!;

    final items = widget.groupItems ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ApzText(
              label: widget.label!,
              fontWeight: ApzFontWeight.labelRegular,
              fontSize: checkbox_subtitle_fontSize,
              color: isEnabled
                  ? secondaryTextColor
                  : secondaryTextColor.withOpacity(0.5),
            ),
          ),
        ValueListenableBuilder<List<int>>(
          valueListenable: selectedIndicesNotifier,
          builder: (context, selectedIndices, _) {
            return Wrap(
              spacing: checkbox_spacing,
              runSpacing: checkbox_spacing,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = selectedIndices.contains(index);
                return GestureDetector(
                  onTap: isEnabled
                      ? () {
                          widget.onTap?.call();
                          if (widget.controller != null) {
                            widget.controller!.toggleIndex(index);
                          } else {
                            final currentSelected =
                                List<int>.from(selectedIndicesNotifier.value);
                            if (currentSelected.contains(index)) {
                              currentSelected.remove(index);
                            } else {
                              currentSelected.add(index);
                            }
                            selectedIndicesNotifier.value = currentSelected;
                          }
                        }
                      : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: checkbox_width,
                          height: checkbox_height,
                          decoration: BoxDecoration(
                            color: isSelected && isEnabled
                                ? primaryColor
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(checkbox_borderRadius),
                            border: Border.all(
                              width: checkbox_borderWidth,
                              color: isSelected && isEnabled
                                  ? primaryColor
                                  : borderColor,
                            ),
                          ),
                          child: isSelected && isEnabled
                              ? Center(
                                  child: Icon(
                                    Icons.check,
                                    size: checkbox_iconSize,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: checkbox_spacing),
                        ApzText(
                          label: item.label,
                          fontWeight: ApzFontWeight.labelRegular,
                          fontSize: checkbox_label_fontSize,
                          color: isEnabled
                              ? primaryTextColor
                              : primaryTextColor.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
enum ApzCheckboxAlignment { left, right }
enum ApzCheckboxVariant { single, group }
