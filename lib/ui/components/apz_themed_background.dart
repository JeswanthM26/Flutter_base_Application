import 'package:flutter/material.dart';

class ApzThemedBackground extends StatelessWidget {
  final Widget child;

  const ApzThemedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundImage = isDarkMode
        ? 'assets/images/dark_theme.png'
        : 'assets/images/light_theme.png';

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
