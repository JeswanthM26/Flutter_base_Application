import "package:flutter/material.dart";

const Color primary = Color(0xFF4FA8DE);
const Color secondary = Color(0xFFB3E0FF);

const Color cursor_color = Color(0xFFFFFFFF);

const Color primary_button_default = Color(0xFF000108);
const Color primary_button_pressed = Color(0xFF2A2B31);
const Color primary_button_disabled = Color(0x1F000108);

const Color secondary_button_default = Color(0xFFFFFFFF);
const Color secondary_button_pressed = Color(0xFFCCCCCE);
const Color secondary_button_disabled =
    Color(0x1F000108); // 12% opacity on #000108

const Color tertiary_button_default = Color(0xFF0073C0);
const Color tertiary_button_pressed = Color(0xFF2A8ACB);
const Color tertiary_button_disabled = Color(0xFFCCE3F2);
const Color tertiary_button_default_background = Colors.transparent;

const Color primary_text = Color(0xFFFFFFFF);
const Color inverse_text = Color(0xFF181818);
const Color secondary_text = Color(0xFFE6F2FA);
const Color tertiary_text = Color(0xFFBABABA);

const Color semantic_sucess = Color(0xFF34C759);
const Color semantaic_sucess_radius = Color(0xFFD6F4DE);
const Color semantic_warning = Color(0xFFFFD21E);
const Color semantic_warning_radius = Color(0xFFFFF6D2);
const Color semantic_error = Color(0xFFF04248);
const Color semantic_error_radius = Color(0xFFFCD9DA);
const Color semantic_info = Color(0xFF2F80ED);
const Color semantic_info_radius = Color(0xFFD5E6FB);

const Color input_field_filled = Color(0x14767680); // 8% opacity on #767680
const Color input_field_border = Color(0xFF8D8D95);
const Color input_field_border_error = Color(0xFFF04248);
const Color input_field_label = Color(0xFFE6F2FA);
const Color input_field_placeholder_default = Color(0xFFE6F2FA);
const Color input_field_placeholder_filled = Color(0xFFFFFFFF);
const Color input_field_helper_text = Color(0xFFE6F2FA);
const Color input_field_helper_text_error = Color(0xFFF04248);
const Color input_field_flag_divider = Color(0x1F6A6A6A);

const Color button_text_white = Color(0xFFFFFFFF);
const Color button_text_black = Color(0xFF000108);

const Color primary_shadow_1 = Color(0x0A28293D);
const Color primary_shadow_2 = Color(0x29606170);

const Color secondary_shadow_1 = Color(0x0A28293D);
const Color secondary_shadow_2 = Color(0x29606170);

const Color popup_shadow = Color(0x29000108);

const Color container_box = Colors.transparent;

const Color searchbar_placeholder_default =
    Color(0xB3FFFFFF); // 70% opacity on #FFFFFF
const Color searchbar_placeholder_filled = Color(0xFFFFFFFF);
const List<Color> searchbarGradientColors = <Color>[
  Color(0xFFFFFFFF), // White
  Color(0xFF3A3139), // Dark shade
];
const List<Color> searchbarGradientLight = <Color>[
  Color(0xFFFFFFFF),
  Color(0xFFF5F8FF), // Light bluish shade
];

const List<Color> searchbarBorderLine = <Color>[
  Color(0x14FFFFFF), // White with 8% opacity
  Color(0x4DB3E0FF), // Light Blue with 30% opacity
];

const Color Toggle_default = Color(0xFF1C41B0);
const Color Toggle_hover = Color(0xFF0073C0);
const Color Toggle_disabled = Color(0xFFE5E5E5);

const Color semantic_shadow = Color(0x1F000000);

Color message_background1 = Color(0xFF383838); // 383838 with 100% opacity
Color message_background2 = Color(0xD1B3B3B3);

// Footer Colors
const Color footer_background = Color(0xFF353535);
const Color footer_default = Color(0xFFAEBBD1);
const Color footer_selected = Color(0xFFFFFFFF);

//header
const Color header_icon_color = Color(0xFFFFFFFF);

//login stories
const Color onboardingProgressInactive =
    Color(0x66FFFFFF); // white with 40% opacity
const Color onboarding = Color(0xFFFFFFFF);
const Color onboardingSkipButtonBg = Color(0xFF787880);

//login
const Color barrierColor = Colors.transparent;
const Color languageDropdownShadow = Color(0x1A000000);
const Color dropdown = Colors.black;

// Dark Theme Colors for Dashboard

const Color dashboardActionButtonBgStart = Color(0xFF181A20);
const Color dashboardActionButtonBgEnd = Color(0xFF23262E);
const Color dashboardActionButtonBorderColor = Color(0xFF2C2F38);
const Color dashboardActionButtonShadow1 = Color(0x1F000000); // 12% black
const Color dashboardActionButtonShadow2 = Color(0x0D000000); // 5% black
const Color dashboardActionButtonIconColor =
    Color(0xFF4EA8DE); // lighter blue accent
const Color dashboardActionButtonLabelColor =
    Color(0xFFE2E2E2); // light grey text

// 🔹 Dashboard Info Card Colors
const Color dashboardInfoCardSelectedText = Color(0xFFE2E2E2);
const Color dashboardInfoCardUnselectedText = Color(0xFF999999); // muted grey
const Color dashboardInfoCardGradientStart = Color(0xFF0D4B6B);
const Color dashboardInfoCardGradientEnd =
    Color(0x220D4B6B); // transparent variant
const Color dashboardInfoCardBorderColor = Color(0xFF181A20);
const Color dashboardInfoCardCountSelectedBg = Color(0xFF4EA8DE);
const Color dashboardInfoCardCountUnselectedBg = Color(0xFF555555);
const Color dashboardInfoCardCountSelectedText = Colors.white;
const Color dashboardInfoCardCountUnselectedText = Color(0xFF999999);

// 📌 Dashboard Balance Section Colors
const Color dashboardAvailableBalanceTextColor = Color(0xFF8FA9BE);
const Color dashboardBalanceVisibleTextColor = Color(0xFFE2E2E2);
const Color dashboardBalanceHiddenTextColor = Color(0xFF8A8A8A);
const Color dashboardVisibilityIconColor = Color(0xFFE2E2E2);
const Color dashboardSavingsTextColor = Color(0xFF4EA8DE);
const Color dashboardSavingsDividerColor =
    Color(0x335EA9D8); // transparent blueish
const Color dashboardIndicatorBgColor = Color(0xFF4EA8DE);
const Color dashboardIndicatorTextColor = Colors.white;
const Color dashboardIndicatorDotActive = Color(0xFF4EA8DE);
const Color dashboardIndicatorDotInactive = Color(0xFF555555);

// 📌 Dashboard Balance Trend Chart Colors
const Color dashboardBalanceTrendTitleTextColor = Color(0xFFE6F2FA);
const Color dashboardBalanceTrendFilterBgColor = Color(0xFF23262E);
const Color dashboardBalanceTrendFilterTextColor = Color(0xFFFFFFFF);
const Color dashboardBalanceTrendFilterIconColor = Color(0xFFFFFFFF);
const Color dashboardBalanceTrendTooltipTextColor = Colors.white;
const Color dashboardBalanceTrendTooltipLineColor = Color(0xFF707070);
const Color dashboardBalanceTrendYAxisLabelTextColor = Color(0xFF999999);
const Color dashboardBalanceTrendXAxisLabelTextColor = Color(0xFF999999);
const Color dashboardBalanceTrendLineColor = Color(0xFF4EA8DE);
const Color dashboardBalanceTrendLineGradientStart = Color(0xFF4EA8DE);
const Color dashboardBalanceTrendLineGradientEnd = Color(0xFF4EA8DE);
const Color dashboardBalanceTrendBelowLineGradientStart = Color(0xFF4EA8DE);
const Color dashboardBalanceTrendBelowLineGradientEnd = Colors.transparent;
const Color dashboardBalanceTrendDotFillColor = Color(0xFF23262E);
const Color dashboardBalanceTrendDotBorderColor = Color(0xFF4EA8DE);

final donutChartBackgroundColor = Colors.transparent;
const donutChartTitleColor = Color(0xFFE6F2FA);
const donutChartCenterTextColor = Color(0xFFBABABA);
const donutChartCenterPercentageColor = Color(0xFFF5F5F5);
const donutChartLegendTextColor = Colors.white;
const donutChartAmountTextColor = Colors.white;
const donutChartDateTextColor = Color(0xFFBABABA);
const List<List<Color>> donutChartSectionColors = [
  [Color(0xFFB3E0FF), Color(0xFFF4F8FF)],
  [Color(0xFFF4F8FF), Color(0xFF5AB8F0)],
];

//upcoming payments
const Color upcomingPaymentsCardBackground = Color(0xFF353535);
const Color upcomingPaymentsFooterNote = Color(0xFFFFCB55); // same as light
const Color upcomingPaymentsGradientStart = Color(0xFFB3E0FF); // gradient start
const Color upcomingPaymentsGradientEnd =
    Color(0x33B3E0FF); // gradient end (transparent)
const Color upcomingPaymentsReminderText =
    Color(0xFFE6F2FA); // reminder text color in dark
const Color upcomingPaymentsHeader = Color(0xFFE6F2FA); // header/title text
const Color upcomingPaymentsAddPaymentBlue =
    Color(0xFF0073C0); // button background for dark theme
const Color upcomingPaymentsDivider = Color(0x6668696A); // same as light
const Color upcomingPaymentsPaymentCount =
    Color(0xFFEFF8FF); // count number color

//reecnt transaction
const Color cardBackground = Color(0xFF353535);
const Color transactionTagBackground = Color.fromARGB(255, 104, 102, 102);

//menu
final Color menuScrimColor = Colors.black.withOpacity(0.5);
const Color menuSheetBackgroundColor = Color(0xFF353535);
const Color menuSheetTitleColor = Colors.white;
const Color menuSheetIndicatorActiveColor = Colors.white;
final Color menuSheetIndicatorInactiveColor = Colors.grey;
final Color menuItemCardBackgroundColor = Colors.grey.withOpacity(0.1);
const Color menuItemCardContentColor = Colors.white;

//favourites
const Color favouriteHeader = Color(0xFFE6F2FA);
const Color favouriteBoxShadow = Color(0x33000000);
const Color favouriteText = Color(0xFF181818);
