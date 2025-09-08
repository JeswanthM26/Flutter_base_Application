import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
// import your button
import 'apz_button.dart';

enum PaymentCardActionType { button, icon, text }

class PaymentCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl; // ✅ Now treated as an asset path

  final PaymentCardActionType actionType;

  // For Button
  final String? buttonLabel;
  final ApzButtonAppearance? buttonAppearance;
  final ApzButtonSize? buttonSize;
  final bool buttonDisabled;

  // For Icon
  final IconData? icon;
  final VoidCallback? onIconTap;

  // For Text (debit/credit)
  final String? amount;
  final bool? isCredit; // true = credit (green), false = debit (red)

  const PaymentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.actionType,

    // Button config
    this.buttonLabel,
    this.buttonAppearance = ApzButtonAppearance.primary,
    this.buttonSize = ApzButtonSize.small,
    this.buttonDisabled = false,

    // Icon config
    this.icon,
    this.onIconTap,

    // Text config
    this.amount,
    this.isCredit,
  });

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  @override
  Widget build(BuildContext context) {
    Widget? trailing;

    switch (widget.actionType) {
      case PaymentCardActionType.button:
        trailing = ApzButton(
          label: widget.buttonLabel ?? "Pay",
          appearance: widget.buttonAppearance!,
          size: widget.buttonSize!,
          disabled: widget.buttonDisabled,
          onPressed: () {
            debugPrint("${widget.buttonLabel ?? "Button"} pressed");
          },
        );
        break;

      case PaymentCardActionType.icon:
        trailing = GestureDetector(
          onTap: widget.onIconTap,
          child: Icon(widget.icon, color: Colors.black),
        );
        break;

      case PaymentCardActionType.text:
        trailing = ApzText(
          label: widget.amount ?? "",
          fontSize: 13,
          fontWeight: ApzFontWeight.headingsMedium,
          color: widget.isCredit == true ? Colors.green : Colors.black,
        );
        break;
    }

    return Container(
      width: 323, // ✅ fixed width as per Figma
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ Asset Image with Box Shadow (Figma style)
          Container(
            width: 36,
            height: 36,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x1E000000),
                  blurRadius: 2.91,
                  offset: Offset(3.64, -1.45),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Text block (expanded)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // replace these lines inside the Column
                ApzText(
                  label: widget.title,
                  fontWeight: ApzFontWeight.headingsMedium,
                  fontSize: 12,
                  color: const Color(0xFF181818),
                ),
                const SizedBox(height: 4),
                ApzText(
                  label: widget.subtitle,
                  fontWeight: ApzFontWeight.bodyRegular,
                  fontSize: 12,
                  color: const Color(0xFF6D717F),
                ),
              ],
            ),
          ),

          // Trailing widget
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing,
          ],
        ],
      ),
    );
  }
}
