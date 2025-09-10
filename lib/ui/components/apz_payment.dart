import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
// import your button
import 'apz_button.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/themes/common_properties.dart'; // ✅ import properties

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
          child: Icon(widget.icon, color: AppColors.primary_text(context)),
        );
        break;

      case PaymentCardActionType.text:
        trailing = ApzText(
          label: widget.amount ?? "",
          fontSize: paymentCardAmountFontSize,
          fontWeight: ApzFontWeight.headingsMedium,
          color: widget.isCredit == true
              ? AppColors.semantic_sucess(context)
              : AppColors.primary_text(context),
        );
        break;
    }

    return Container(
      width: double.infinity,
      padding: paymentCardPadding,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        leading: Container(
          width: paymentCardImageSize,
          height: paymentCardImageSize,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(paymentCardImageBorderRadius),
            ),
            shadows: const [paymentCardImageShadow],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(paymentCardImageBorderRadius),
            child: Image.asset(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: ApzText(
          label: widget.title,
          fontWeight: ApzFontWeight.headingsMedium,
          fontSize: paymentCardTitleFontSize,
          color: AppColors.primary_text(context),
        ),
        subtitle: ApzText(
          label: widget.subtitle,
          fontWeight: ApzFontWeight.bodyRegular,
          fontSize: paymentCardSubtitleFontSize,
          color: AppColors.secondary_text(context),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // ✅ Keeps it tight to the end
          children: [
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
