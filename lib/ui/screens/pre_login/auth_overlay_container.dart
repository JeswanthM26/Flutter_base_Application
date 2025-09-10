import 'dart:ui';
import 'package:flutter/material.dart';

class AuthOverlayContainer extends StatelessWidget {
  final Widget child;

  const AuthOverlayContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 40),
          child: Opacity(
            opacity: 0.8,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: h * 0.04,
                left: w * 0.04,
                right: w * 0.04,
                bottom: h * 0.045,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00E4E4E4),
                    Color(0xFFE4E4E4),
                  ],
                ),
              ),
              child: child, // only this changes
            ),
          ),
        ),
      ),
    );
  }
}
