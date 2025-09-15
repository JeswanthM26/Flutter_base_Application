// import 'package:Retail_Application/themes/apz_app_themes.dart';
// import 'package:Retail_Application/ui/components/apz_text.dart';
// import 'package:flutter/material.dart';
// import 'package:Retail_Application/themes/common_properties.dart';

// class ApzSearchBar extends StatefulWidget {
//   final AppzSearchBarType type;
//   final String placeholder;
//   final Widget? trailingIcon;
//   final VoidCallback? onTrailingPressed;
//   final TextEditingController? controller;
//   final ValueChanged<String>? onChanged;
//   final List<dynamic>? items;
//   final String Function(dynamic item)? labelSelector;
//   final void Function(List<dynamic> filtered)? onFiltered;
//   final List<String>? recommendations;
//   final Widget? categoriesWidget;

//   const ApzSearchBar({
//     super.key,
//     required this.type,
//     this.placeholder = "Search...",
//     this.trailingIcon,
//     this.onTrailingPressed,
//     this.controller,
//     this.onChanged,
//     this.items,
//     this.labelSelector,
//     this.onFiltered,
//     this.recommendations,
//     this.categoriesWidget,
//   });

//   @override
//   State<ApzSearchBar> createState() => _ApzSearchBarState();
// }

// class _ApzSearchBarState extends State<ApzSearchBar> {
//   late TextEditingController _controller;
//   bool _hasText = false;
//   // ignore: unused_field
//   List<dynamic> _filteredItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller ?? TextEditingController();
//     _hasText = _controller.text.isNotEmpty;

//     _controller.addListener(() {
//       final hasTextNow = _controller.text.isNotEmpty;
//       if (hasTextNow != _hasText) {
//         setState(() {
//           _hasText = hasTextNow; // Update hasText state
//         });
//       }
//       _filter(_controller.text);
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.items != null) {
//         _filter(_controller.text);
//       }
//     });
//   }

//   void _clearInput() {
//     _controller.clear();
//     _filter('');
//     setState(() {
//       _hasText = false; // Show developer icon again or no icon
//     });
//   }

//   @override
//   void dispose() {
//     if (widget.controller == null) {
//       _controller.dispose();
//     }
//     super.dispose();
//   }

//   void _filter(String query) {
//     if (widget.items != null && widget.labelSelector != null) {
//       final f = widget.items!
//           .where((item) => widget.labelSelector!(item)
//               .toLowerCase()
//               .contains(query.toLowerCase()))
//           .toList();
//       setState(() {
//         _filteredItems = f;
//       });
//       if (widget.onFiltered != null) widget.onFiltered!(f);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final bool isSecondary = widget.type == AppzSearchBarType.secondary;

//     final Color placeholderColor = _hasText
//         ? (isSecondary
//             ? AppColors.searchbar_placeholder_filled(context)
//             : AppColors.input_field_placeholder_filled(context))
//         : (isSecondary
//             ? AppColors.searchbar_placeholder_default(context)
//             : AppColors.input_field_placeholder_default(context));
//     final Color iconColor = placeholderColor;

//     // Trailing icon logic:
//     // - Show close icon if user typed text
//     // - Else show developer icon if provided
//     // - Else no icon
//     Widget? trailingIconWidget;
//     VoidCallback? trailingOnTap;

//     if (_hasText) {
//       trailingIconWidget =
//           Icon(Icons.close, size: searchbar_iconSize, color: iconColor);
//       trailingOnTap = _clearInput;
//     } else {
//       trailingIconWidget = widget.trailingIcon;
//       trailingOnTap = widget.onTrailingPressed;
//     }

//     final Widget textFieldContent = Row(
//       children: [
//         Icon(
//           Icons.search,
//           size: searchbar_iconSize,
//           color: iconColor,
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: TextField(
//             controller: _controller,
//             cursorColor: AppColors.cursor_color(context),
//             onChanged: (val) {
//               widget.onChanged?.call(val);
//               _filter(val);
//             },
//             style: TextStyle(
//               fontSize: searchbar_fontSize,
//               color: placeholderColor,
//               fontWeight: ApzFontWeight.bodyRegular.value,
//             ),
//             decoration: InputDecoration(
//               isDense: true,
//               border: InputBorder.none,
//               hintText: widget.placeholder,
//               hintStyle: TextStyle(
//                 fontSize: searchbar_fontSize,
//                 color: placeholderColor,
//                 fontWeight: ApzFontWeight.bodyRegular.value,
//               ),
//               contentPadding: EdgeInsets.zero,
//             ),
//           ),
//         ),
//         if (trailingIconWidget != null)
//           GestureDetector(
//             onTap: trailingOnTap,
//             child: IconTheme(
//               data: IconThemeData(
//                 color: iconColor,
//                 size: searchbar_iconSize,
//               ),
//               child: trailingIconWidget,
//             ),
//           ),
//       ],
//     );

//     Widget innerContent;
//     if (isSecondary) {
//       innerContent = Stack(
//         children: [
//           Container(
//             width: width,
//             height: searchbar_height,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: AppColors.searchbarGradientLight(context)
//                     .map((c) => c.withOpacity(0.2))
//                     .toList(),
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//               borderRadius: BorderRadius.circular(searchbar_borderRadius),
//             ),
//           ),
//           Container(
//             width: width,
//             height: searchbar_height,
//             padding: searchbar_padding,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: AppColors.searchbarGradientColors(context)
//                     .map((c) => c.withOpacity(0.1))
//                     .toList(),
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//               borderRadius: BorderRadius.circular(searchbar_borderRadius),
//             ),
//             child: textFieldContent,
//           ),
//         ],
//       );
//     } else {
//       innerContent = Container(
//         width: width,
//         height: searchbar_height,
//         padding: searchbar_padding,
//         decoration: BoxDecoration(
//           color: AppColors.input_field_filled(context),
//           borderRadius: BorderRadius.circular(searchbar_borderRadius),
//         ),
//         child: textFieldContent,
//       );
//     }

//     final List<Widget> extraWidgets = [];
//     if (widget.recommendations != null && widget.recommendations!.isNotEmpty) {
//       extraWidgets.add(
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Wrap(
//             spacing: 8,
//             children: widget.recommendations!
//                 .map((keyword) => ActionChip(
//                       label: ApzText(
//                         label: keyword,
//                         fontSize: searchbar_fontSize,
//                         color: placeholderColor,
//                         fontWeight: ApzFontWeight.bodyRegular,
//                       ),
//                       onPressed: () {
//                         _controller.text = keyword;
//                         _controller.selection = TextSelection.fromPosition(
//                           TextPosition(offset: keyword.length),
//                         );
//                         _filter(keyword);
//                       },
//                     ))
//                 .toList(),
//           ),
//         ),
//       );
//     }
//     if (widget.categoriesWidget != null) {
//       extraWidgets.add(
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: widget.categoriesWidget!,
//         ),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GradientBorderContainer(
//           borderRadius: searchbar_borderRadius,
//           borderWidth: searchbar_borderWidth,
//           gradientColors: AppColors.searchbarBorderLine(context),
//           child: innerContent,
//         ),
//         ...extraWidgets,
//       ],
//     );
//   }
// }

// // GradientBorderContainer and _GradientBorderPainter remain unchanged

// class GradientBorderContainer extends StatelessWidget {
//   final double borderRadius;
//   final double borderWidth;
//   final List<Color> gradientColors;
//   final Widget child;

//   const GradientBorderContainer({
//     required this.borderRadius,
//     required this.borderWidth,
//     required this.gradientColors,
//     required this.child,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _GradientBorderPainter(
//         borderRadius: borderRadius,
//         borderWidth: borderWidth,
//         gradientColors: gradientColors,
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(borderRadius),
//         ),
//         child: child,
//       ),
//     );
//   }
// }

// class _GradientBorderPainter extends CustomPainter {
//   final double borderRadius;
//   final double borderWidth;
//   final List<Color> gradientColors;

//   _GradientBorderPainter({
//     required this.borderRadius,
//     required this.borderWidth,
//     required this.gradientColors,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Rect rect = Offset.zero & size;
//     final RRect outer =
//         RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
//     final RRect inner = RRect.fromRectAndRadius(
//       Rect.fromLTWH(borderWidth, borderWidth, size.width - borderWidth * 2,
//           size.height - borderWidth * 2),
//       Radius.circular(borderRadius - borderWidth),
//     );

//     final Paint paint = Paint()
//       ..shader = LinearGradient(
//         colors: gradientColors,
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//       ).createShader(rect)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = borderWidth;

//     final Path borderPath = Path()
//       ..addRRect(outer)
//       ..addRRect(inner)
//       ..fillType = PathFillType.evenOdd;

//     canvas.drawPath(borderPath, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// enum AppzSearchBarType {
//   primary,
//   secondary,
// }
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:Retail_Application/themes/common_properties.dart';

class ApzSearchBar extends StatefulWidget {
  final AppzSearchBarType type;
  final String placeholder;
  final Widget? trailingIcon;
  final VoidCallback? onTrailingPressed;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final List<dynamic>? items;
  final String Function(dynamic item)? labelSelector;
  final void Function(List<dynamic> filtered)? onFiltered;
  final List<String>? recommendations;
  final Widget? categoriesWidget;

  const ApzSearchBar({
    super.key,
    required this.type,
    this.placeholder = "Search...",
    this.trailingIcon,
    this.onTrailingPressed,
    this.controller,
    this.onChanged,
    this.items,
    this.labelSelector,
    this.onFiltered,
    this.recommendations,
    this.categoriesWidget,
  });

  @override
  State<ApzSearchBar> createState() => _ApzSearchBarState();
}

class _ApzSearchBarState extends State<ApzSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;
  // ignore: unused_field
  List<dynamic> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;

    _controller.addListener(() {
      final hasTextNow = _controller.text.isNotEmpty;
      if (hasTextNow != _hasText) {
        setState(() {
          _hasText = hasTextNow; // Update hasText state
        });
      }
      _filter(_controller.text);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.items != null) {
        _filter(_controller.text);
      }
    });
  }

  void _clearInput() {
    _controller.clear();
    _filter('');
    setState(() {
      _hasText = false; // Show developer icon again or no icon
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _filter(String query) {
    if (widget.items != null && widget.labelSelector != null) {
      final f = widget.items!
          .where((item) => widget.labelSelector!(item)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      setState(() {
        _filteredItems = f;
      });
      if (widget.onFiltered != null) widget.onFiltered!(f);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isSecondary = widget.type == AppzSearchBarType.secondary;

    final Color placeholderColor = _hasText
        ? (isSecondary
            ? AppColors.searchbar_placeholder_filled(context)
            : AppColors.input_field_placeholder_filled(context))
        : (isSecondary
            ? AppColors.searchbar_placeholder_default(context)
            : AppColors.input_field_placeholder_default(context));
    final Color iconColor = placeholderColor;

    // Trailing icon logic:
    // - Show close icon if user typed text
    // - Else show developer icon if provided
    // - Else no icon
    Widget? trailingIconWidget;
    VoidCallback? trailingOnTap;

    if (_hasText) {
      trailingIconWidget =
          Icon(Icons.close, size: searchbar_iconSize, color: iconColor);
      trailingOnTap = _clearInput;
    } else {
      trailingIconWidget = widget.trailingIcon;
      trailingOnTap = widget.onTrailingPressed;
    }

    final Widget textFieldContent = Row(
      children: [
        Icon(
          Icons.search,
          size: searchbar_iconSize,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _controller,
            cursorColor: AppColors.cursor_color(context),
            onChanged: (val) {
              widget.onChanged?.call(val);
              _filter(val);
            },
            style: TextStyle(
              fontSize: searchbar_fontSize,
              color: placeholderColor,
              fontWeight: ApzFontWeight.bodyRegular.value,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                fontSize: searchbar_fontSize,
                color: placeholderColor,
                fontWeight: ApzFontWeight.bodyRegular.value,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        if (trailingIconWidget != null)
          GestureDetector(
            onTap: trailingOnTap,
            child: IconTheme(
              data: IconThemeData(
                color: iconColor,
                size: searchbar_iconSize,
              ),
              child: trailingIconWidget,
            ),
          ),
      ],
    );

    Widget innerContent;
    if (isSecondary) {
      innerContent = Stack(
        children: [
          Container(
            height: searchbar_height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.searchbarGradientLight(context)
                    .map((c) => c.withOpacity(0.2))
                    .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(searchbar_borderRadius),
            ),
          ),
          Container(
            height: searchbar_height,
            padding: searchbar_padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.searchbarGradientColors(context)
                    .map((c) => c.withOpacity(0.1))
                    .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(searchbar_borderRadius),
            ),
            child: textFieldContent,
          ),
        ],
      );
    } else {
      innerContent = Container(
        height: searchbar_height,
        padding: searchbar_padding,
        decoration: BoxDecoration(
          color: AppColors.input_field_filled(context),
          borderRadius: BorderRadius.circular(searchbar_borderRadius),
        ),
        child: textFieldContent,
      );
    }

    final List<Widget> extraWidgets = [];
    if (widget.recommendations != null && widget.recommendations!.isNotEmpty) {
      extraWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Wrap(
            spacing: 8,
            children: widget.recommendations!
                .map((keyword) => ActionChip(
                      label: ApzText(
                        label: keyword,
                        fontSize: searchbar_fontSize,
                        color: placeholderColor,
                        fontWeight: ApzFontWeight.bodyRegular,
                      ),
                      onPressed: () {
                        _controller.text = keyword;
                        _controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: keyword.length),
                        );
                        _filter(keyword);
                      },
                    ))
                .toList(),
          ),
        ),
      );
    }
    if (widget.categoriesWidget != null) {
      extraWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: widget.categoriesWidget!,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientBorderContainer(
          borderRadius: searchbar_borderRadius,
          borderWidth: searchbar_borderWidth,
          gradientColors: AppColors.searchbarBorderLine(context),
          child: innerContent,
        ),
        ...extraWidgets,
      ],
    );
  }
}

// GradientBorderContainer and _GradientBorderPainter remain unchanged

class GradientBorderContainer extends StatelessWidget {
  final double borderRadius;
  final double borderWidth;
  final List<Color> gradientColors;
  final Widget child;

  const GradientBorderContainer({
    required this.borderRadius,
    required this.borderWidth,
    required this.gradientColors,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        gradientColors: gradientColors,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double borderRadius;
  final double borderWidth;
  final List<Color> gradientColors;

  _GradientBorderPainter({
    required this.borderRadius,
    required this.borderWidth,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect outer =
        RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final RRect inner = RRect.fromRectAndRadius(
      Rect.fromLTWH(borderWidth, borderWidth, size.width - borderWidth * 2,
          size.height - borderWidth * 2),
      Radius.circular(borderRadius - borderWidth),
    );

    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final Path borderPath = Path()
      ..addRRect(outer)
      ..addRRect(inner)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(borderPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum AppzSearchBarType {
  primary,
  secondary,
}
