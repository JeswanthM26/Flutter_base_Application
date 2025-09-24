import 'package:flutter/material.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:retail_application/ui/components/apz_button.dart';
import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/themes/common_properties.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ApzAlertMessageType { success, error, info, warning }

class ApzAlert extends StatelessWidget {
  final String title;
  final String message;
  final ApzAlertMessageType messageType;
  final List<String> buttons;
  final Function(String)? onButtonPressed;

  const ApzAlert({
    Key? key,
    required this.title,
    required this.message,
    required this.messageType,
    this.buttons = const ['Okay'],
    this.onButtonPressed,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required ApzAlertMessageType messageType,
    List<String> buttons = const ['Okay'],
    Function(String)? onButtonPressed,
    Alignment alignment = Alignment.center,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Align(
          alignment: alignment,
          child: ApzAlert(
            title: title,
            message: message,
            messageType: messageType,
            buttons: buttons,
            onButtonPressed: onButtonPressed,
          ),
        );
      },
    );
  }

  String _getIconPath() {
    switch (messageType) {
      case ApzAlertMessageType.success:
        return 'assets/alerts/Success.svg';
      case ApzAlertMessageType.error:
        return 'assets/alerts/Error.svg';
      case ApzAlertMessageType.info:
        return 'assets/alerts/Info.svg';
      case ApzAlertMessageType.warning:
        return 'assets/alerts/Alert.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: alert_width,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: AppColors.container_box(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(alert_borderRadius),
          ),
          shadows: [
            BoxShadow(
              color: AppColors.popup_shadow(context),
              offset: alert_ShadowOffset,
              blurRadius: alertShadowBlurRadius,
              spreadRadius: alertShadowSpreadRadius,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: alert_headerHeight, // fixed height
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // vertical centering
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: alert_headerPaddingHorizontal,
                      ),
                      child: Align(
                        alignment:
                            Alignment.centerLeft, // keep text left aligned
                        child: ApzText(
                          label: title,
                          fontWeight: ApzFontWeight.headingsBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.all(alert_contentPadding),
              child: Row(
                children: [
                  SvgPicture.asset(
                    _getIconPath(),
                  ),
                  SizedBox(width: alert_iconSpacing),
                  Expanded(
                    child: ApzText(
                      label: message,
                      fontWeight: ApzFontWeight.labelRegular,
                      color: AppColors.secondary_text(context),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(alert_buttonContainerPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (buttons.length > 1) ...[
                    Expanded(
                      child: ApzButton(
                        label: buttons[0],
                        appearance:
                            ApzButtonAppearance.primary, // ✅ First = Primary
                        size: ApzButtonSize.large,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onButtonPressed?.call(buttons[0]);
                        },
                      ),
                    ),
                    SizedBox(width: alert_buttonSpacing),
                    Expanded(
                      child: ApzButton(
                        label: buttons[1],
                        appearance: ApzButtonAppearance
                            .secondary, // ✅ Second = Secondary
                        size: ApzButtonSize.large,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onButtonPressed?.call(buttons[1]);
                        },
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: ApzButton(
                        label: buttons[0],
                        appearance: ApzButtonAppearance
                            .primary, // ✅ Single button = Primary
                        size: ApzButtonSize.large,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onButtonPressed?.call(buttons[0]);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
