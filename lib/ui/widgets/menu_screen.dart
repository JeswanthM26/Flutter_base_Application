
// import 'package:flutter/material.dart';
// import 'package:Retail_Application/models/menu_model/apz_menu_options.dart';
// import 'package:Retail_Application/ui/components/apz_menu_item.dart';

// class MenuSheet extends StatefulWidget {
//   const MenuSheet({Key? key, required this.options}) : super(key: key);

//   final List<MenuOptionModel> options;

//   @override
//   State<MenuSheet> createState() => _MenuSheetState();
// }

// class _MenuSheetState extends State<MenuSheet> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController.addListener(() {
//       final newPage = _pageController.page?.round();
//       if (newPage != null && newPage != _currentPage) {
//         setState(() {
//           _currentPage = newPage;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const int itemsPerPage = 6;
//     final int pageCount = (widget.options.length / itemsPerPage).ceil();

//     return Container(
//       height: MediaQuery.of(context).size.height * 0.55,
//       decoration: const BoxDecoration(
//         color: Color(0xFF1a1a1a),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 20),
//           const Text(
//             'Menu',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: PageView.builder(
//               controller: _pageController,
//               itemCount: pageCount,
//               itemBuilder: (context, pageIndex) {
//                 final startIndex = pageIndex * itemsPerPage;
//                 final endIndex =
//                     (startIndex + itemsPerPage > widget.options.length)
//                         ? widget.options.length
//                         : startIndex + itemsPerPage;
//                 final pageOptions =
//                     widget.options.sublist(startIndex, endIndex);

//                 return GridView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0, vertical: 20.0),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     childAspectRatio: 1.0,
//                   ),
//                   itemCount: pageOptions.length,
//                   itemBuilder: (context, index) {
//                     final option = pageOptions[index];
//                     return MenuItemCard(
//                       label: option.label,
//                       icon: option.icon,
//                       onTap: option.onTap,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           if (pageCount > 1)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(pageCount, (index) {
//                   return Container(
//                     width: 8,
//                     height: 8,
//                     margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: _currentPage == index
//                           ? Colors.white
//                           : Colors.white.withOpacity(0.5),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:Retail_Application/models/menu_model/apz_menu_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MenuSheet extends StatefulWidget {
  const MenuSheet({Key? key, required List options}) : super(key: key);

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
    final String response = await rootBundle.loadString('mock/menu_options/menu_options.json');
    final data = await json.decode(response) as List;
    setState(() {
      _menuItems = data.map((item) => MenuModel.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CarouselSlider.builder(
                  itemCount: (_menuItems.length / 6).ceil(),
                  itemBuilder: (context, index, realIndex) {
                    final int startIndex = index * 6;
                    final int endIndex = (startIndex + 6 > _menuItems.length) ? _menuItems.length : startIndex + 6;
                    final items = _menuItems.sublist(startIndex, endIndex);
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, gridIndex) {
                        final option = items[gridIndex];
                        return InkWell(
                          onTap: () {
                            // ignore: avoid_print
                            print('Navigate to ${option.route}');
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(option.iconData, color: Colors.white, size: 30),
                              const SizedBox(height: 8),
                              Text(
                                option.label,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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
            count: (_menuItems.length / 6).ceil(),
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: Colors.white,
              dotColor: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
