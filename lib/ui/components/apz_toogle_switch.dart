import 'package:retail_application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:retail_application/themes/common_properties.dart';
import 'package:retail_application/themes/apz_app_themes.dart';

enum ApzToggleSize { small, large }

class ApzToggleController extends ChangeNotifier {
  bool _value;
  ApzToggleController(this._value);

  bool get value => _value;
  set value(bool newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}

class ApzToggleButton extends StatefulWidget {
  final String label;
  final ApzToggleController controller;
  final bool isDisabled;
  final ApzToggleSize size;
  final ValueChanged<bool>? onChanged;

  const ApzToggleButton({
    Key? key,
    required this.label,
    required this.controller,
    this.isDisabled = false,
    this.size = ApzToggleSize.small,
    this.onChanged,
  }) : super(key: key);

  @override
  State<ApzToggleButton> createState() => _ApzToggleButtonState();
}

class _ApzToggleButtonState extends State<ApzToggleButton> {
  late bool _isOn;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _isOn = widget.controller.value;
    widget.controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  void _controllerListener() {
    if (_isOn != widget.controller.value) {
      setState(() {
        _isOn = widget.controller.value;
      });
    }
  }

  void _toggle() {
    if (widget.isDisabled) return; // Disabled disables toggle interaction only
    final newValue = !_isOn;
    widget.controller.value = newValue;
    widget.onChanged?.call(newValue);
  }

  double get _width =>
      widget.size == ApzToggleSize.small ? toggleSmallWidth : toggleLargeWidth;
  double get _height => widget.size == ApzToggleSize.small
      ? toggleSmallHeight
      : toggleLargeHeight;
  double get _thumbSize => widget.size == ApzToggleSize.small
      ? toggleSmallThumbSize
      : toggleLargeThumbSize;

  Color _getTrackColor(BuildContext context) {
    if (widget.isDisabled) return AppColors.Toggle_disabled(context);
    if (_isOn) {
      return _isHovered
          ? AppColors.Toggle_hover(context)
          : AppColors.Toggle_default(context);
    }
    return AppColors.Toggle_disabled(context);
  }

  // Label color stays primary_text regardless of disabled state
  Color _getLabelColor(BuildContext context) {
    return AppColors.primary_text(context);
  }

  @override
  Widget build(BuildContext context) {
    final trackColor = _getTrackColor(context);
    final labelColor = _getLabelColor(context);

    return MouseRegion(
      onEnter: (_) {
        if (!widget.isDisabled) {
          setState(() {
            _isHovered = true;
          });
        }
      },
      onExit: (_) {
        if (!widget.isDisabled) {
          setState(() {
            _isHovered = false;
          });
        }
      },
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Label left, toggle right
        children: [
          Flexible(
            child: ApzText(
              label: widget.label,
              color: labelColor,
              fontWeight: ApzFontWeight.labelRegular,
              fontSize: toggleFontSize,
            ),
          ),
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.translucent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: _width,
              height: _height,
              padding: EdgeInsets.all(togglePaddingHorizontal),
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: BorderRadius.circular(_height / 2),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: _thumbSize,
                  height: _thumbSize,
                  decoration: BoxDecoration(
                    color: AppColors.inverse_text(context),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
