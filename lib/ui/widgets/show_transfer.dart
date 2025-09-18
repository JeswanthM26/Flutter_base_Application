import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showTransferModelAtButton(BuildContext context,
    GlobalKey buttonKey, ValueChanged<bool> onHighlightChange) async {
  // Lift the button
  onHighlightChange(true);

  // Get the position & size of the button safely
  final RenderBox? renderBox =
      buttonKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final buttonSize = renderBox.size;
  final buttonPosition = renderBox.localToGlobal(Offset.zero);

  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Dismiss",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(), // Tap outside to close
        child: Stack(
          children: [
            // BACKGROUND BLUR
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0, // Blur strength
                  sigmaY: 0,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
            // TRANSFER POPUP
            Positioned(
              left: buttonPosition.dx,
              top: buttonPosition.dy + buttonSize.height + 4,
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {}, // Prevent tap inside popup from closing
                  child: Container(
                    width: 170,
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF353535),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x2D000000),
                          blurRadius: 8,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _transferRow('Own Bank', () {
                          debugPrint("Own Bank tapped");
                        }),
                        _divider(),
                        _transferRow('Within Bank', () {
                          debugPrint("Within Bank tapped");
                        }),
                        _divider(),
                        _transferRow('Other Bank', () {
                          debugPrint("Other Bank tapped");
                        }),
                        _divider(),
                        _transferRow('International Bank', () {
                          debugPrint("International Bank tapped");
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
      return FadeTransition(
        opacity: anim1,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
              .animate(curved),
          child: ScaleTransition(scale: curved, child: child),
        ),
      );
    },
  );

  // Reset the button highlight after dialog is dismissed
  onHighlightChange(false);
}

Widget _transferRow(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.all(5),
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(125)),
              ),
            ),
            child: const SizedBox.shrink(),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFEFF8FF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.20,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _divider() {
  return Opacity(
    opacity: 0.8,
    child: Container(
      width: double.infinity,
      height: 1,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.3,
            color: Color(0x6668696A),
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
      ),
    ),
  );
}
