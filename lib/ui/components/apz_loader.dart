import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:retail_application/ui/components/apz_text.dart';

class ApzLoader {
  static Future<void> show(BuildContext context, {Widget? label}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: _LoaderUI(label: label),
          ),
        );
      },
    );
  }
}

class _LoaderUI extends StatelessWidget {
  final Widget? label;

  const _LoaderUI({Key? key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double defaultHeight = 150.0;
    const double defaultWidth = 150.0;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final assetPath = isDarkMode ? 'assets/loader/loader_dark.gif' : 'assets/loader/loader_light.gif';
    
    final Widget gifWidget = SizedBox(
      height: defaultHeight,
      width: defaultWidth,
      child: Image.asset(
        assetPath,
        fit: BoxFit.fill,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        gifWidget,
        if (label != null) ...[
          const SizedBox(height: 2),
          label!,
        ] else ... [
          const SizedBox(height: 2),
          //const ApzText(label: 'Loading...'),
        ]
      ],
    );
  }
}


