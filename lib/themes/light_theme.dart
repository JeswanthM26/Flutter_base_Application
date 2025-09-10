import "package:flutter/material.dart";

const Color primary = Color(0xFF4FA8DE);
const Color secondary = Color(0xFFB3E0FF);

const Color cursor_color = Color(0xFF8D8D95);

const Color primary_button_default = Color(0xFF000108);
const Color primary_button_pressed = Color(0xFF2A2B31);
const Color primary_button_disabled =
    Color(0x1F000108); // 12% opacity on #000108

const Color secondary_button_default = Color(0xFFFFFFFF);
const Color secondary_button_pressed = Color(0xFFCCCCCE);
const Color secondary_button_disabled =
    Color(0x1F000108); // 12% opacity on #000108

const Color tertiary_button_default = Color(0xFF0073C0);
const Color tertiary_button_pressed = Color(0xFF2A8ACB);
const Color tertiary_button_disabled = Color(0xFFCCE3F2);
const Color tertiary_button_default_background = Colors.transparent;

const Color primary_text = Color(0xFF181818);
const Color inverse_text = Color(0xFFFFFFFF);
const Color secondary_text = Color(0xFF6D717F);
const Color tertiary_text = Color(0xFF57778C);

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
const Color input_field_label = Color(0xFF6D717F);
const Color input_field_placeholder_default = Color(0xFF6D717F);
const Color input_field_placeholder_filled = Color(0xFF181818);
const Color input_field_helper_text = Color(0xFF6D717F);
const Color input_field_helper_text_error = Color(0xFFF04248);
const Color input_field_flag_divider = Color(0x1F6A6A6A);

const Color button_text_white = Color(0xFFFFFFFF);
const Color button_text_black = Color(0xFF000108);

const Color primary_shadow_1 = Color(0x0A28293D);
const Color primary_shadow_2 = Color(0x29606170);

const Color secondary_shadow_1 = Color(0x0A28293D);
const Color secondary_shadow_2 = Color(0x29606170);

const Color popup_shadow = Color(0x29000108);

const Color container_box = Color(0xFFFFFFFF);

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
const Color footer_background = Color(0xFFFFFFFF);
const Color footer_default = Color(0xFFAEBBD1);
const Color footer_selected = Color(0xFF4FA8DE);

// Header Colors
const Color header_icon_color = Color(0xFF181818);

//dashboard
// 🔹 Dashboard Action Button Colors
const Color dashboardActionButtonBgStart = Colors.white;
const Color dashboardActionButtonBgEnd = Color(0xFFEFF4FF);
const Color dashboardActionButtonBorderColor = Colors.white;
const Color dashboardActionButtonShadow1 = Color(0x05000000);
const Color dashboardActionButtonShadow2 = Color(0x0A000000);
const Color dashboardActionButtonIconColor = Colors.blue;
const Color dashboardActionButtonLabelColor = Colors.black;

// 🔹 Dashboard Info Card Colors
const Color dashboardInfoCardSelectedText = Color(0xFF181818);
const Color dashboardInfoCardUnselectedText =
    Color(0xFF6D6D6D); // approx grey600
const Color dashboardInfoCardGradientStart = Color(0xFFB3E0FF);
const Color dashboardInfoCardGradientEnd = Color(0x33B3E0FF);
const Color dashboardInfoCardBorderColor = Colors.white;
const Color dashboardInfoCardCountSelectedBg = Color(0xFF4FA8DE);
const Color dashboardInfoCardCountUnselectedBg =
    Color(0xFFBDBDBD); // approx grey400
const Color dashboardInfoCardCountSelectedText = Colors.white;
const Color dashboardInfoCardCountUnselectedText =
    Color(0xFF6D6D6D); // approx grey600

// 📌 Dashboard Balance Section Colors
const Color dashboardAvailableBalanceTextColor = Color(0xFF57768B);
const Color dashboardBalanceVisibleTextColor = Color(0xFF181818);
const Color dashboardBalanceHiddenTextColor = Color(0xFF181818);
const Color dashboardVisibilityIconColor = Colors.black;
const Color dashboardSavingsTextColor = Color(0xFF4EA8DE);
const Color dashboardSavingsDividerColor = Color(0x5181B4D6);
const Color dashboardIndicatorBgColor = Colors.blue;
const Color dashboardIndicatorTextColor = Colors.white;
const Color dashboardIndicatorDotActive = Colors.blue;
const Color dashboardIndicatorDotInactive = Color(0xFFBDBDBD); // ~grey.shade400

// 📌 Dashboard Balance Trend Chart Colors
const Color dashboardBalanceTrendTitleTextColor = Colors.grey;
const Color dashboardBalanceTrendFilterBgColor = Color(0xFFE8F1FF);
const Color dashboardBalanceTrendFilterTextColor =
    Color(0xFF1565C0); // ~Colors.blue[800]
const Color dashboardBalanceTrendFilterIconColor =
    Color(0xFF1565C0); // ~Colors.blue[800]
const Color dashboardBalanceTrendTooltipTextColor = Colors.white;
const Color dashboardBalanceTrendTooltipLineColor =
    Color.fromARGB(255, 207, 207, 209);
const Color dashboardBalanceTrendYAxisLabelTextColor = Colors.grey;
const Color dashboardBalanceTrendXAxisLabelTextColor = Colors.grey;
const Color dashboardBalanceTrendLineColor = Color(0xFF4A90E2);
const Color dashboardBalanceTrendLineGradientStart = Color(0xFF4A90E2);
const Color dashboardBalanceTrendLineGradientEnd = Color(0xFF4A90E2);
const Color dashboardBalanceTrendBelowLineGradientStart = Color(0xFF4A90E2);
const Color dashboardBalanceTrendBelowLineGradientEnd = Colors.transparent;
const Color dashboardBalanceTrendDotFillColor = Colors.white;
const Color dashboardBalanceTrendDotBorderColor = Color(0xFF4A90E2);
