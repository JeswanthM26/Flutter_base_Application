import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/themes/common_properties.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:Retail_Application/ui/components/apz_datepicker.dart';

enum AmountFormatType {
  lakhs,
  millions,
}

enum ApzInputFieldAppearance {
  primary,
  secondary,
  filled,
}

enum ApzInputFieldState {
  defaultState,
  error,
  disabled,
  focused,
  success,
}

enum ApzInputLabelPosition {
  top,
  left,
}

enum ApzInputValidationType {
  none,
  mandatory,
  email,
  numeric,
  amount,
  password,
}

enum ApzInputFieldType {
  normal,
  readonly,
  textDescription,
  otp4,
  otp6,
  datepicker,
}

enum ApzInputKeyboardType {
  text,
  multiline,
  number,
  phone,
  emailAddress,
  url,
  password,
  date,
  dateTime,
}

class ApzInputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool isVisibility;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final bool isEmailFld;
  final bool isAmount;
  final AmountFormatType? amountFormatType;
  final bool allowAllCaps;
  final bool isMandatory;
  final bool onlyNumbers;
  final ApzInputFieldType fieldType;
  final String? textDescription;
  final Color? focusColor;
  final String? minDate;
  final String? maxDate;
  final SelectionType? selectionType;
  final String? dateFormat;

  const ApzInputField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.isVisibility = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.isEmailFld = false,
    this.isAmount = false,
    this.amountFormatType,
    this.allowAllCaps = false,
    this.isMandatory = false,
    this.onlyNumbers = false,
    this.fieldType = ApzInputFieldType.normal,
    this.textDescription,
    this.focusColor,
    this.minDate,
    this.maxDate,
    this.selectionType,
    this.dateFormat,
  });

  @override
  State<ApzInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<ApzInputField> {
  late bool _isObscured;
  late FocusNode _fieldFocusNode;
  late FocusNode _descFocusNode;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    _fieldFocusNode = FocusNode()..addListener(() => setState(() {}));
    _descFocusNode = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fieldFocusNode.removeListener(() {});
    _fieldFocusNode.dispose();
    _descFocusNode.removeListener(() {});
    _descFocusNode.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    if (widget.validator != null) return widget.validator!(value);

    if (widget.isMandatory && (value == null || value.trim().isEmpty)) {
      return 'This field is required';
    }

    if (widget.isEmailFld) {
      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (value == null || value.trim().isEmpty) return 'Email is required';
      if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    }

    return null;
  }

  List<TextInputFormatter> _buildInputFormatters() {
    final formatters = <TextInputFormatter>[];

    if (widget.isAmount) {
      formatters
          .add(_ThousandsSeparatorInputFormatter(widget.amountFormatType));
    } else if (widget.onlyNumbers) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    if (widget.allowAllCaps) {
      formatters.add(UpperCaseTextFormatter());
    }

    return formatters;
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText && !widget.isVisibility) {
      return IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility_off : Icons.visibility,
          color: AppColors.primary_text(context),
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      );
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.fieldType) {
      case ApzInputFieldType.otp4:
        return _buildOtpInput(4);
      case ApzInputFieldType.otp6:
        return _buildOtpInput(6);
      case ApzInputFieldType.readonly:
        return _buildReadOnlyField();
      case ApzInputFieldType.textDescription:
        return _buildTextDescriptionField();
      case ApzInputFieldType.datepicker:
        return _buildDatePickerField();
      case ApzInputFieldType.normal:
      default:
        return _buildNormalField();
    }
  }

  Widget _buildNormalField() {
    final borderShape = OutlineInputBorder(
      borderRadius: BorderRadius.circular(inputFieldBorderRadius),
      borderSide: BorderSide.none,
    );

    final Color activeFocusColor =
        widget.focusColor ?? AppColors.cursor_color(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ApzText(
              label: widget.label,
              color: AppColors.input_field_label(context),
              fontSize: 12,
            ),
            if (widget.isMandatory)
              ApzText(
                label: "*",
                color: AppColors.semantic_error(context),
                fontSize: 12,
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: _fieldFocusNode,
          controller: widget.controller,
          obscureText: _isObscured,
          cursorColor: activeFocusColor,
          keyboardType: widget.isAmount || widget.onlyNumbers
              ? const TextInputType.numberWithOptions(decimal: true)
              : widget.keyboardType,
          validator: _validate,
          enabled: widget.enabled,
          inputFormatters: _buildInputFormatters(),
          style: inputFieldHintStyle.copyWith(
              color: AppColors.input_field_placeholder_filled(context),
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: widget.hintText ?? '',
            hintStyle: inputFieldHintStyle.copyWith(
              color: AppColors.input_field_placeholder_default(context),
            ),
            filled: true,
            fillColor: AppColors.input_field_filled(context),
            contentPadding: inputFieldContentPadding,
            border: borderShape,
            enabledBorder: borderShape,
            disabledBorder: borderShape,
            errorBorder: borderShape,
            focusedBorder: borderShape.copyWith(
              borderSide: BorderSide(
                color: AppColors.input_field_border(context),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: borderShape.copyWith(
              borderSide: BorderSide(
                color: AppColors.semantic_error(context),
                width: 1.5,
              ),
            ),
            suffixIcon: _buildSuffixIcon(),
            prefixIcon: widget.prefixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.input_field_filled(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ApzText(
            label: widget.label,
            color: AppColors.secondary_text(context),
            fontSize: 12,
            fontWeight: ApzFontWeight.bodyRegular,
          ),
          const SizedBox(height: 4),
          ApzText(
            label: widget.controller.text,
            color: AppColors.primary_text(context),
            fontSize: 14,
            fontWeight: ApzFontWeight.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTextDescriptionField() {
    final borderShape = OutlineInputBorder(
      borderRadius: BorderRadius.circular(inputFieldBorderRadius),
      borderSide: BorderSide.none,
    );

    final Color activeFocusColor =
        widget.focusColor ?? AppColors.cursor_color(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ApzText(
              label: widget.label,
              color: AppColors.secondary_text(context),
              fontSize: 12,
            ),
            if (widget.isMandatory)
              ApzText(
                label: "*",
                color: AppColors.semantic_error(context),
                fontSize: 12,
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: _descFocusNode,
          controller: widget.controller,
          obscureText: _isObscured,
          cursorColor: activeFocusColor,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          minLines: 4,
          maxLines: 4,
          validator: _validate,
          enabled: widget.enabled,
          inputFormatters: _buildInputFormatters(),
          style: inputFieldHintStyle.copyWith(
              color: AppColors.primary_text(context),
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: widget.hintText ?? '',
            hintStyle: inputFieldHintStyle.copyWith(
              color: AppColors.secondary_text(context),
            ),
            filled: true,
            fillColor: AppColors.input_field_filled(context),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: borderShape,
            enabledBorder: borderShape,
            disabledBorder: borderShape,
            errorBorder: borderShape,
            focusedBorder: borderShape.copyWith(
              borderSide: BorderSide(
                color: AppColors.input_field_border(context),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: borderShape.copyWith(
              borderSide: BorderSide(
                color: AppColors.semantic_error(context),
                width: 1.5,
              ),
            ),
            suffixIcon: _buildSuffixIcon(),
            prefixIcon: widget.prefixIcon,
            helperText: widget.textDescription,
            helperStyle: const TextStyle(
              color: Color(0xFF737373),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField() {
    final borderShape = OutlineInputBorder(
      borderRadius: BorderRadius.circular(inputFieldBorderRadius),
      borderSide: BorderSide.none,
    );

    final Color activeFocusColor =
        widget.focusColor ?? AppColors.cursor_color(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ApzText(
              label: widget.label,
              color: AppColors.secondary_text(context),
              fontSize: 12,
            ),
            if (widget.isMandatory)
              ApzText(
                label: "*",
                color: AppColors.semantic_error(context),
                fontSize: 12,
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          focusNode: _fieldFocusNode,
          controller: widget.controller,
          readOnly: true,
          cursorColor: activeFocusColor,
          validator: _validate,
          enabled: widget.enabled,
          style: inputFieldHintStyle.copyWith(
              color: AppColors.primary_text(context),
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: widget.hintText ?? '',
            hintStyle: inputFieldHintStyle.copyWith(
              color: AppColors.secondary_text(context),
            ),
            filled: true,
            fillColor: AppColors.input_field_filled(context),
            contentPadding: inputFieldContentPadding,
            border: borderShape,
            enabledBorder: borderShape,
            disabledBorder: borderShape,
            errorBorder: borderShape,
            focusedBorder: borderShape.copyWith(
              borderSide: BorderSide(
                color: AppColors.input_field_border(context),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: borderShape.copyWith(
              borderSide: BorderSide(
                color: AppColors.semantic_error(context),
                width: 1.5,
              ),
            ),
            suffixIcon: const Icon(Icons.calendar_today),
            prefixIcon: widget.prefixIcon,
          ),
          onTap: () async {
            final DateTime? minDate = widget.minDate != null
                ? DateTime.tryParse(widget.minDate!)
                : null;
            final DateTime? maxDate = widget.maxDate != null
                ? DateTime.tryParse(widget.maxDate!)
                : null;

            final List<String?>? dates =
                await ApzCustomDatepicker().showCustomDate(
              ApzDatepicker(
                context: context,
                minDate: minDate ?? DateTime(1900),
                maxDate: maxDate ?? DateTime(2100),
                initialDate: DateTime.now(),
                selectionType: widget.selectionType ?? SelectionType.single,
                dateFormat: widget.dateFormat,
              ),
            );
            if (dates != null && dates.isNotEmpty) {
              if (widget.selectionType == SelectionType.range) {
                widget.controller.text =
                    '${dates.first ?? ''} - ${dates.last ?? ''}';
              } else {
                widget.controller.text = dates.first!;
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildOtpInput(int otpLength) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ApzText(
              label: widget.label,
              color: AppColors.secondary_text(context),
              fontSize: 12,
            ),
            if (widget.isMandatory)
              ApzText(
                label: "*",
                color: AppColors.semantic_error(context),
                fontSize: 12,
              ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: (48 * otpLength) + (16 * (otpLength - 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              otpLength,
              (index) => _OtpBox(
                controller: widget.controller,
                index: index,
                otpLength: otpLength,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final int index;
  final int otpLength;

  const _OtpBox({
    required this.controller,
    required this.index,
    required this.otpLength,
  });

  @override
  _OtpBoxState createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  late FocusNode _focusNode;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textController = TextEditingController();

    widget.controller.addListener(_onControllerChanged);
    _focusNode.addListener(_onFocusChanged);
    _onControllerChanged();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      if (widget.controller.text.length > widget.index &&
          _textController.text != widget.controller.text[widget.index]) {
        _textController.text = widget.controller.text[widget.index];
      } else if (widget.controller.text.length <= widget.index &&
          _textController.text.isNotEmpty) {
        _textController.clear();
      }
    }
  }

  void _onFocusChanged() {
    if (mounted) {
      setState(() {
        // Re-build to show/hide hint
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.primary_text(context),
    );

    return SizedBox(
      width: 48,
      height: 48,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_textController.text.isEmpty && widget.index > 0) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
        child: TextFormField(
          controller: _textController,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: textStyle,
          decoration: InputDecoration(
            hintText: _focusNode.hasFocus ? null : '-',
            hintStyle:
                textStyle.copyWith(color: AppColors.secondary_text(context)),
            filled: true,
            fillColor: AppColors.input_field_filled(context),
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(inputFieldBorderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(inputFieldBorderRadius),
              borderSide: BorderSide(
                color: AppColors.input_field_border(context),
                width: 1.5,
              ),
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (widget.index < widget.controller.text.length) {
                final newText =
                    widget.controller.text.substring(0, widget.index) +
                        value +
                        widget.controller.text.substring(widget.index + 1);
                widget.controller.text = newText;
              } else {
                widget.controller.text += value;
              }
              if (widget.index < widget.otpLength - 1) {
                FocusScope.of(context).nextFocus();
              } else {
                _focusNode.unfocus();
              }
            } else {
              if (widget.index < widget.controller.text.length) {
                final newText =
                    widget.controller.text.substring(0, widget.index) +
                        widget.controller.text.substring(widget.index + 1);
                widget.controller.text = newText;
              }
            }
            widget.controller.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.controller.text.length),
            );
          },
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final AmountFormatType? formatType;

  _ThousandsSeparatorInputFormatter(this.formatType);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    String cleanText = newValue.text.replaceAll(',', '');

    final regExp = RegExp(r'^\d*\.?\d*$');
    if (!regExp.hasMatch(cleanText)) {
      return oldValue;
    }

    List<String> parts = cleanText.split('.');
    String integerPart = parts[0].isEmpty ? "0" : parts[0];
    String? decimalPart = parts.length > 1 ? parts[1] : null;

    if (decimalPart != null && decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    int? intValue = int.tryParse(integerPart);
    if (intValue == null) return oldValue;

    NumberFormat formatter = (formatType == AmountFormatType.lakhs)
        ? NumberFormat.decimalPattern('en_IN')
        : NumberFormat.decimalPattern('en_US');

    String formattedInteger = formatter.format(intValue);

    String newText = (decimalPart != null)
        ? "$formattedInteger.$decimalPart"
        : formattedInteger;

    int selectionIndex =
        newText.length - (newValue.text.length - newValue.selection.end);
    selectionIndex = selectionIndex.clamp(0, newText.length);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
