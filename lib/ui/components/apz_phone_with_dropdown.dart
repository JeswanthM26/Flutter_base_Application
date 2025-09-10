import 'package:Retail_Application/models/dropdown_country_model/apz_country.dart';
import 'package:Retail_Application/models/dropdown_country_model/apz_country_model.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/themes/common_properties.dart';
import 'package:Retail_Application/ui/components/apz_input_field.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:phonecodes/phonecodes.dart';
import 'package:Retail_Application/ui/components/apz_searchbar.dart';

class AppzPhoneInputWithDropdown extends StatefulWidget {
  final void Function(PhoneNumberModel)? onChanged;
  final String? initialPhoneCode;
  final String? initialValue;
  final String? label;
  final bool isMandatory;

  const AppzPhoneInputWithDropdown({
    super.key,
    this.onChanged,
    this.initialPhoneCode,
    this.label,
    this.initialValue,
    this.isMandatory = false,
  });

  @override
  State<AppzPhoneInputWithDropdown> createState() =>
      _PhoneInputWithDropdownState();
}

class _PhoneInputWithDropdownState extends State<AppzPhoneInputWithDropdown> {
  late TextEditingController _controller;
  late List<CountryModel> fullCountryList;
  late CountryModel _selectedCountry;
  late ValueNotifier<String?> _selectedCountryNotifier;

  OverlayEntry? _overlayEntry;
  final _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  late List<CountryModel> filteredCountryList;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');

    fullCountryList = Country.values.map((country) {
      return CountryModel(
        isoCode: country.code,
        name: country.name,
        phoneCode: country.dialCode.replaceAll('+', ''),
        flag: country.flag,
      );
    }).toList();

    _selectedCountry = fullCountryList.firstWhere(
      (c) => c.phoneCode == (widget.initialPhoneCode ?? '91'),
      orElse: () => fullCountryList.first,
    );

    _selectedCountryNotifier = ValueNotifier(
        "${_selectedCountry.flag} +${_selectedCountry.phoneCode}");

    filteredCountryList = fullCountryList;
  }

  void _notifyChange() {
    final phoneData = PhoneNumberModel(
      countryCode: '+${_selectedCountry.phoneCode}',
      phoneNumber: _controller.text.trim(),
    );
    widget.onChanged?.call(phoneData);
  }

  void _showCountryDropdown() {
    _searchController.clear();
    filteredCountryList = fullCountryList;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ApzSearchBar(
                      type: AppzSearchBarType.primary,
                      placeholder: 'Search...',
                      controller: _searchController,
                      items: fullCountryList,
                      labelSelector: (item) =>
                          "${item.flag} ${item.name} +${item.phoneCode}",
                      onFiltered: (filtered) {
                        setState(() {
                          filteredCountryList = filtered.cast<CountryModel>();
                        });
                        _overlayEntry?.markNeedsBuild();
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredCountryList.length,
                      itemBuilder: (context, index) {
                        final country = filteredCountryList[index];
                        return ListTile(
                          leading: Text(country.flag,
                              style: const TextStyle(fontSize: 20)),
                          title: Text(country.name),
                          trailing: Text('+${country.phoneCode}'),
                          onTap: () {
                            setState(() {
                              _selectedCountry = country;
                              _selectedCountryNotifier.value =
                                  "${country.flag} +${country.phoneCode}";
                            });
                            _removeOverlay();
                            _notifyChange();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _selectedCountryNotifier.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) {
        final text = _controller.text.trim();
        if (widget.isMandatory && text.isEmpty) {
          return 'Phone number is required';
        }
        if (text.isNotEmpty && text.length != 10) {
          return 'Phone number must be exactly 10 digits';
        }
        return null;
      },
      builder: (field) {
        _controller.addListener(() {
          final text = _controller.text;
          field.didChange(text);
          _notifyChange();
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) ...[
              Row(
                children: [
                  ApzText(
                    label: widget.label!,
                    fontWeight: ApzFontWeight.headingSemibold,
                    fontSize: input_label_fontsize,
                  ),
                  if (widget.isMandatory)
                    ApzText(
                      label: ' *',
                      color: AppColors.input_field_border_error(context),
                      fontWeight: ApzFontWeight.headingSemibold,
                    ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // CompositedTransformTarget for dropdown
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: GestureDetector(
                      onTap: () {
                        if (_overlayEntry == null) {
                          _showCountryDropdown();
                        } else {
                          _removeOverlay();
                        }
                      },
                      child: Container(
                        height: 48,
                        width: 91,
                        decoration: BoxDecoration(
                          color: AppColors.input_field_filled(context),
                          border: Border.all(
                            color: field.hasError
                                ? AppColors.input_field_border_error(context)
                                : Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "${_selectedCountry.flag} +${_selectedCountry.phoneCode}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ApzInputField(
                      label: "",
                      controller: _controller,
                      hintText: "Enter phone number",
                      keyboardType: TextInputType.phone,
                      onlyNumbers: true,
                    ),
                  ),
                ],
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 8),
                child: ApzText(
                  label: field.errorText ?? '',
                  color: AppColors.input_field_border_error(context),
                  fontSize: input_label_fontsize,
                  fontWeight: ApzFontWeight.bodyRegular,
                ),
              ),
          ],
        );
      },
    );
  }
}
