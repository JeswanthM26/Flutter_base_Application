import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonecodes/phonecodes.dart'; // ✅ Use plugin for countries
import 'package:country_flags/country_flags.dart'; // ✅ Added for flag widgets
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/themes/common_properties.dart';
import 'package:Retail_Application/ui/components/apz_searchbar.dart';
import 'package:Retail_Application/ui/components/apz_text.dart'; // ✅ import ApzText

class ApzInputWithDropdown extends StatefulWidget {
  final TextEditingController phoneController;
  final String label;
  final String hintText;
  final bool isMandatory;
  final FormFieldValidator<String>? validator;

  const ApzInputWithDropdown({
    super.key,
    required this.phoneController,
    required this.label,
    this.hintText = 'Enter phone number',
    this.isMandatory = false,
    this.validator,
  });

  @override
  State<ApzInputWithDropdown> createState() => _InputWithDropdownState();
}

class _InputWithDropdownState extends State<ApzInputWithDropdown> {
  late Country selectedCountry;
  final TextEditingController _rawNumberController =
      TextEditingController(); // ✅ keeps only digits

  @override
  @override
  void initState() {
    super.initState();
    // Default to India
    selectedCountry = Country.values.firstWhere((c) => c.code == 'IN');

    // ✅ Initialize raw number from phoneController
    final phone = widget.phoneController.text;
    if (phone.isNotEmpty) {
      // Remove leading '+' and country code if it matches selectedCountry
      final codeDigits = selectedCountry.dialCode.replaceAll('+', '');
      if (phone.startsWith('+$codeDigits')) {
        _rawNumberController.text = phone.substring(codeDigits.length + 1);
      } else {
        _rawNumberController.text = phone;
      }
    }
  }

  void _showCountryPicker() async {
    final result = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CountryPicker(),
    );

    if (result != null) {
      setState(() {
        selectedCountry = result;
      });
      _updateFullPhone();
    }
  }

  void _updateFullPhone() {
    final raw = _rawNumberController.text.trim();
    if (raw.isNotEmpty) {
      widget.phoneController.text =
          "+${selectedCountry.dialCode.replaceAll('+', '')}$raw";
    } else {
      widget.phoneController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = inputFieldLabelStyle.copyWith(
      color: AppColors.secondary_text(context),
    );
    final mandatoryStyle = inputFieldLabelStyle.copyWith(
      color: AppColors.semantic_error(context),
    );

    return FormField<String>(
      validator: (value) {
        if (widget.validator != null) {
          return widget.validator!(value);
        }

        final text = _rawNumberController.text.trim();
        if (widget.isMandatory && text.isEmpty) {
          return 'Phone number is required';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: widget.label,
                style: labelStyle,
                children: widget.isMandatory
                    ? [TextSpan(text: ' *', style: mandatoryStyle)]
                    : [],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Country picker button
                InkWell(
                  onTap: _showCountryPicker,
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.input_field_filled(context),
                      borderRadius:
                          BorderRadius.circular(inputFieldBorderRadius),
                    ),
                    child: Row(
                      children: [
                        CountryFlag.fromCountryCode(
                          selectedCountry.code,
                          width: 24,
                          height: 24,
                          shape: const Circle(),
                        ),
                        const SizedBox(width: 8),
                        ApzText(
                          label:
                              '+${selectedCountry.dialCode.replaceAll("+", "")}',
                          fontSize: countryCodeStyle.fontSize,
                          color: AppColors.secondary_text(context),
                          fontWeight: ApzFontWeight.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Phone number input (digits only)
                Expanded(
                  child: TextFormField(
                    controller: _rawNumberController,
                    keyboardType: TextInputType.phone,
                    cursorColor: AppColors.cursor_color(context),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // ✅ only digits
                    ],
                    style: inputFieldHintStyle.copyWith(
                      color: AppColors.primary_text(context),
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (_) {
                      _updateFullPhone(); // ✅ update combined value
                      field.didChange(_rawNumberController.text);
                    },
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: inputFieldHintStyle.copyWith(
                        color: AppColors.secondary_text(context),
                      ),
                      filled: true,
                      fillColor: AppColors.input_field_filled(context),
                      contentPadding: inputFieldContentPadding,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(inputFieldBorderRadius),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(inputFieldBorderRadius),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(inputFieldBorderRadius),
                        borderSide: BorderSide(
                          color: AppColors.input_field_border(context),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 8),
                child: ApzText(
                  label: field.errorText ?? '',
                  fontSize: input_error_fontsize,
                  color: AppColors.input_field_border_error(context),
                  fontWeight: ApzFontWeight.bodyRegular,
                ),
              ),
          ],
        );
      },
    );
  }
}

// Country picker modal
class _CountryPicker extends StatefulWidget {
  const _CountryPicker();

  @override
  State<_CountryPicker> createState() => __CountryPickerState();
}

class __CountryPickerState extends State<_CountryPicker> {
  List<Country> filteredCountries = Country.values;

  void _onFiltered(List<dynamic> filtered) {
    setState(() {
      filteredCountries = filtered.cast<Country>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 1.0,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.container_box(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // ✅ ApzSearchBar with all countries from plugin
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ApzSearchBar(
                  type: AppzSearchBarType.primary,
                  placeholder: 'Search Country or Code',
                  items: Country.values,
                  labelSelector: (item) =>
                      "${item.flag} ${item.name} +${item.dialCode.replaceAll('+', '')}",
                  onFiltered: _onFiltered,
                  onTrailingPressed: () {
                    setState(() {
                      filteredCountries = Country.values;
                    });
                  },
                ),
              ),

              // List of countries
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, index) {
                    final country = filteredCountries[index];
                    return Column(
                      children: [
                        ListTile(
                          onTap: () => Navigator.pop(context, country),
                          leading: CountryFlag.fromCountryCode(
                            country.code,
                            width: 24,
                            height: 24,
                            shape: const Circle(),
                          ),
                          title: ApzText(
                            label: country.name,
                            fontSize: countryCodeStyle.fontSize,
                            color: AppColors.primary_text(context),
                            fontWeight: ApzFontWeight.bodyMedium,
                          ),
                          trailing: ApzText(
                            label: '+${country.dialCode.replaceAll("+", "")}',
                            fontSize: countryCodeStyle.fontSize,
                            color: AppColors.secondary_text(context),
                            fontWeight: ApzFontWeight.bodyMedium,
                          ),
                        ),
                        Divider(
                          color: AppColors.input_field_flag_divider(context),
                          height: 1,
                          thickness: 1,
                          indent: 16, // optional for left padding
                          endIndent: 16, // optional for right padding
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
