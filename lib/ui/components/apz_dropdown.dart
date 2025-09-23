import 'package:retail_application/ui/components/apz_searchbar.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/themes/common_properties.dart';

enum ApzDropdownVariation { mobile, web }

class ApzDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final String? hintText;
  final ValueNotifier<String?>? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool isMandatory;
  final bool isSearchable;
  final ValueChanged<String?>? onChanged;
  final String? defaultValue;
  final ApzDropdownVariation variation;

  const ApzDropdown({
    super.key,
    required this.label,
    required this.items,
    this.hintText,
    this.controller,
    this.validator,
    this.enabled = true,
    this.isMandatory = false,
    this.isSearchable = false,
    this.onChanged,
    this.defaultValue,
    this.variation = ApzDropdownVariation.web,
  });

  @override
  State<ApzDropdown> createState() => _ApzDropdownState();
}

class _ApzDropdownState extends State<ApzDropdown> {
  String? _selectedValue;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusScopeNode _overlayFocusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.controller?.value ?? widget.defaultValue;
    widget.controller?.addListener(_handleControllerChange);
    _focusNode.addListener(_onFocusChange);
  }

  void _handleControllerChange() {
    if (mounted && widget.controller?.value != _selectedValue) {
      setState(() {
        _selectedValue = widget.controller?.value;
      });
    }
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted &&
            !_focusNode.hasFocus &&
            !_overlayFocusScopeNode.hasFocus) {
          _hideOverlay();
        }
      });
    }
  }

  @override
  void dispose() {
    _hideOverlay();
    widget.controller?.removeListener(_handleControllerChange);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _overlayFocusScopeNode.dispose();
    super.dispose();
  }

  void _updateValue(String? newValue) {
    setState(() {
      _selectedValue = newValue;
    });
    if (widget.controller != null) {
      widget.controller!.value = newValue;
    }
    widget.onChanged?.call(newValue);
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideOverlay,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height + 2.0),
              child: FocusScope(
                node: _overlayFocusScopeNode,
                child: GestureDetector(
                  onTap: () {},
                  child: _DropdownOverlayContent(
                    items: widget.items,
                    isSearchable: widget.isSearchable,
                    onItemSelected: (newValue) {
                      _updateValue(newValue);
                      _hideOverlay();
                    },
                    selectedValue: _selectedValue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    }
  }

  void _showBottomSheet() {
    _focusNode.requestFocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return _BottomSheetContent(
              scrollController: scrollController,
              label: "",
              items: widget.items,
              isSearchable: widget.isSearchable,
              onItemSelected: (newValue) {
                _updateValue(newValue);
                Navigator.pop(context);
              },
              selectedValue: _selectedValue,
            );
          },
        );
      },
    ).whenComplete(() {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    });
  }

  void _handleTap() {
    if (_overlayEntry != null) {
      _hideOverlay();
    } else {
      if (widget.variation == ApzDropdownVariation.web) {
        _focusNode.requestFocus();
        _showOverlay();
      } else {
        _showBottomSheet();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _selectedValue,
      validator: widget.validator,
      enabled: widget.enabled,
      builder: (FormFieldState<String> field) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (field.value != _selectedValue) {
            field.didChange(_selectedValue);
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ApzText(
                  label: widget.label,
                  fontWeight: ApzFontWeight.labelRegular,
                  color: AppColors.secondary_text(context),
                  fontSize: 12,
                ),
                if (widget.isMandatory)
                  ApzText(
                    label: "*",
                    fontWeight: ApzFontWeight.labelRegular,
                    color: AppColors.semantic_error(context),
                    fontSize: 12,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            CompositedTransformTarget(
              link: _layerLink,
              child: GestureDetector(
                onTap: widget.enabled ? _handleTap : null,
                child: Focus(
                  focusNode: _focusNode,
                  child: Container(
                    padding: inputFieldContentPadding,
                    decoration: BoxDecoration(
                      color: widget.enabled
                          ? AppColors.input_field_filled(context)
                          : AppColors.input_field_filled(context)
                              .withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(inputFieldBorderRadius),
                      border: Border.all(
                        color: _isFocused
                            ? AppColors.input_field_border(context)
                            : field.hasError
                                ? AppColors.input_field_border_error(context)
                                : AppColors.input_field_filled(context),
                        width: _isFocused || field.hasError ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedValue ?? widget.hintText ?? '',
                            style: inputFieldHintStyle.copyWith(
                              color: _selectedValue != null
                                  ? AppColors.input_field_placeholder_filled(
                                      context)
                                  : AppColors.input_field_placeholder_default(
                                      context),
                              fontWeight: _selectedValue != null
                                  ? FontWeight.w500
                                  : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Icon(
                            _overlayEntry != null
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: AppColors.input_field_placeholder_default(
                                context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: AppColors.input_field_helper_text_error(context),
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BottomSheetContent extends StatefulWidget {
  final ScrollController scrollController;
  final String label;
  final List<String> items;
  final bool isSearchable;
  final Function(String) onItemSelected;
  final String? selectedValue;

  const _BottomSheetContent({
    required this.scrollController,
    required this.label,
    required this.items,
    required this.isSearchable,
    required this.onItemSelected,
    this.selectedValue,
  });

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      if (mounted) {
        setState(() {
          _filteredItems = widget.items
              .where((item) => item.toLowerCase().contains(query))
              .toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.input_field_filled(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 6,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: ShapeDecoration(
              color: const Color(0xFFC8CFD8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (widget.isSearchable)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: ApzSearchBar(
                type: AppzSearchBarType.primary,
                placeholder: 'Search..',
                controller: _searchController,
                items: widget.items,
                labelSelector: (item) => item.toString(),
              ),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              controller: widget.scrollController,
              padding: EdgeInsets.zero,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final bool isSelected = item == widget.selectedValue;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () => widget.onItemSelected(item),
                    borderRadius: BorderRadius.circular(8), // rounded ripple
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secondary_button_pressed(context)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ApzText(
                        label: item,
                        fontWeight: ApzFontWeight.bodyRegular,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0x1E6A6A6A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownOverlayContent extends StatefulWidget {
  final List<String> items;
  final bool isSearchable;
  final Function(String) onItemSelected;
  final String? selectedValue;

  const _DropdownOverlayContent({
    required this.items,
    required this.isSearchable,
    required this.onItemSelected,
    this.selectedValue,
  });

  @override
  State<_DropdownOverlayContent> createState() =>
      _DropdownOverlayContentState();
}

class _DropdownOverlayContentState extends State<_DropdownOverlayContent> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      if (mounted) {
        setState(() {
          _filteredItems = widget.items
              .where((item) => item.toLowerCase().contains(query))
              .toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(inputFieldBorderRadius),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 250),
        decoration: BoxDecoration(
            color: AppColors.input_field_filled(context),
            borderRadius: BorderRadius.circular(inputFieldBorderRadius),
            border: Border.all(
              color: AppColors.input_field_border(context),
              width: 1,
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isSearchable)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: ApzSearchBar(
                  type: AppzSearchBarType.primary,
                  placeholder: 'Search..',
                  controller: _searchController,
                  items: widget.items,
                  labelSelector: (item) => item.toString(),
                ),
              ),
            Flexible(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  final bool isSelected = item == widget.selectedValue;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () => widget.onItemSelected(item),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.secondary_button_pressed(context)
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ApzText(
                          label: item,
                          fontWeight: ApzFontWeight.bodyRegular,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0x1E6A6A6A),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
