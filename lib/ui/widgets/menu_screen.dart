import 'dart:convert';
import 'dart:convert';
import 'package:Retail_Application/models/menu_model/apz_menu_model.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/themes/common_properties.dart';
import 'package:Retail_Application/ui/components/apz_menu_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MenuSheet extends StatefulWidget {
  const MenuSheet({Key? key, required this.onClose}) : super(key: key);
  final VoidCallback onClose;
  @override
  _MenuSheetState createState() => _MenuSheetState();
}

class _MenuSheetState extends State<MenuSheet> {
  int _current = 0;
  List<MenuModel> _menuItems = [];

  @override
  void initState() {
    super.initState();
    _loadMenuData();
  }

  Future<void> _loadMenuData() async {
    final String response =
        await rootBundle.loadString('mock/menu_options/menu_options.json');
    final data = await json.decode(response) as List;
    setState(() {
      _menuItems = data.map((item) => MenuModel.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * menuSheetHeightFactor,
      decoration: BoxDecoration(
        color: AppColors.menuSheetBackground(context),
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(menuSheetBorderRadius)),
      ),
      child: Column(
        children: [
          Padding(
            padding: menuSheetPadding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Menu',
                style: TextStyle(
                  color: AppColors.menuSheetTitle(context),
                  fontSize: menuSheetTitleFontSize,
                  fontWeight: menuSheetTitleFontWeight,
                ),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CarouselSlider.builder(
                  itemCount: (_menuItems.length / 9).ceil(),
                  itemBuilder: (context, index, realIndex) {
                    final int startIndex = index * 9;
                    final int endIndex = (startIndex + 9 > _menuItems.length)
                        ? _menuItems.length
                        : startIndex + 9;
                    final items = _menuItems.sublist(startIndex, endIndex);
                    return GridView.builder(
                      padding: menuSheetGridViewPadding,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: menuSheetGridViewSpacing,
                        mainAxisSpacing: menuSheetGridViewSpacing,
                        childAspectRatio: menuSheetGridViewAspectRatio,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, gridIndex) {
                        final option = items[gridIndex];
                        return MenuItemCard(
                          label: option.label,
                          icon: option.iconData,
                          onTap: () {
                            widget.onClose();
                            GoRouter.of(context).push('/${option.route}');
                          },
                        );
                      },
                    );
                  },
                  options: CarouselOptions(
                    height: constraints.maxHeight,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          AnimatedSmoothIndicator(
            activeIndex: _current,
            count: (_menuItems.length / 9).ceil(),
            effect: WormEffect(
              dotHeight: menuSheetIndicatorDotSize,
              dotWidth: menuSheetIndicatorDotSize,
              activeDotColor: AppColors.menuSheetIndicatorActive(context),
              dotColor: AppColors.menuSheetIndicatorInactive(context),
            ),
          ),
          const SizedBox(height: menuSheetIndicatorBottomSpacing),
        ],
      ),
    );
  }
}
