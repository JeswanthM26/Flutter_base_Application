import 'dart:ui';
import 'package:Retail_Application/themes/apz_app_themes.dart';
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
                      color: AppColors.container_box(context),
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
                        _transferRow(
                          'Own Bank',
                          Icons.account_balance, // 🏦 icon
                          () {
                            debugPrint("Own Bank tapped");
                          },
                          context,
                        ),
                        _divider(context),
                        _transferRow(
                          'Within Bank',
                          Icons.account_balance_wallet, // 💼 wallet icon
                          () {
                            debugPrint("Within Bank tapped");
                          },
                          context,
                        ),
                        _divider(context),
                        _transferRow(
                          'Other Bank',
                          Icons
                              .account_balance_outlined, // 🏛 outlined bank icon
                          () {
                            debugPrint("Other Bank tapped");
                          },
                          context,
                        ),
                        _divider(context),
                        _transferRow(
                          'International Bank',
                          Icons.public, // 🌍 globe icon
                          () {
                            debugPrint("International Bank tapped");
                          },
                          context,
                        ),
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

Widget _transferRow(String label, IconData icon, VoidCallback onTap, context) {
  final Color textColor = AppColors.primary_text(context);

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
            child: Icon(
              icon,
              size: 18,
              color: textColor, // ✅ same as text color
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
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

Widget _divider(BuildContext context) {
  return Divider(
    color: AppColors.upcomingPaymentsDivider(context),
    thickness: 0.3,
    height: 0.5, // reduces extra space
  );
}
