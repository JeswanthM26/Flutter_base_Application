import 'package:flutter/material.dart';
import 'package:Retail_Application/themes/light_theme.dart' as light;
import 'package:Retail_Application/themes/dark_theme.dart' as dark;

class AppColors {
  static Color primary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.primary
          : light.primary;

  static Color cursor_color(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.cursor_color
          : light.cursor_color;

  static Color secondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.secondary
          : light.secondary;

  static Color primary_button_default(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.primary_button_default
          : light.primary_button_default;

  static Color primary_button_pressed(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.primary_button_pressed
          : light.primary_button_pressed;

  static Color primary_button_disabled(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.primary_button_disabled
          : light.primary_button_disabled;
  static Color secondary_button_default(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.secondary_button_default
          : light.secondary_button_default;

  static Color secondary_button_pressed(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.secondary_button_pressed
          : light.secondary_button_pressed;

  static Color secondary_button_disabled(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.secondary_button_disabled
          : light.secondary_button_disabled;

  static Color tertiary_button_default(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.tertiary_button_default
          : light.tertiary_button_default;

  static Color tertiary_button_pressed(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.tertiary_button_pressed
          : light.tertiary_button_pressed;
  static Color tertiary_button_disabled(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.tertiary_button_disabled
          : light.tertiary_button_disabled;

  static Color tertiary_button_default_background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.tertiary_button_default_background
          : light.tertiary_button_default_background;

  static Color primary_text(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.primary_text
          : light.primary_text;

  static Color inverse_text(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.inverse_text
          : light.inverse_text;
  static Color secondary_text(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.secondary_text
          : light.secondary_text;

  static Color tertiary_text(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.tertiary_text
          : light.tertiary_text;
  static Color semantic_sucess(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.semantic_sucess
          : light.semantic_sucess;

  static Color semantaic_sucess_radius(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.semantaic_sucess_radius
          : light.semantaic_sucess_radius;

  static Color semantic_warning(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.semantic_warning
          : light.semantic_warning;

  static Color semantic_warning_radius(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.semantic_warning_radius
          : light.semantic_warning_radius;

  static Color semantic_error(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.semantic_error
          : light.semantic_error;

  static Color semantic_error_radius(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.semantic_error_radius
          : light.semantic_error_radius;

  static Color semantic_info(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.semantic_info
          : light.semantic_info;

  static Color semantic_info_radius(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.semantic_info_radius
          : light.semantic_info_radius;

  static Color input_field_filled(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.input_field_filled
          : light.input_field_filled;

  static Color input_field_border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.input_field_border
          : light.input_field_border;
  static Color input_field_border_error(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.input_field_border_error
          : light.input_field_border_error;

  static Color input_field_label(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.input_field_label
          : light.input_field_label;

  static Color input_field_placeholder_default(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.input_field_placeholder_default
          : light.input_field_placeholder_default;

  static Color input_field_placeholder_filled(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.input_field_placeholder_filled
          : light.input_field_placeholder_filled;

  static Color input_field_helper_text(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.input_field_helper_text
          : light.input_field_helper_text;

  static Color input_field_helper_text_error(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.input_field_helper_text_error
          : light.input_field_helper_text_error;

  static Color button_text_white(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.button_text_white
          : light.button_text_white;

  static Color button_text_black(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.button_text_black
          : light.button_text_black;

  static Color primary_shadow_1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.primary_shadow_1
          : light.primary_shadow_1;

  static Color primary_shadow_2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.primary_shadow_2
          : light.primary_shadow_2;

  static Color secondary_shadow_1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.secondary_shadow_1
          : light.secondary_shadow_1;

  static Color secondary_shadow_2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.secondary_shadow_2
          : light.secondary_shadow_2;

  static Color popup_shadow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.popup_shadow
          : light.popup_shadow;

  static Color container_box(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.container_box
          : light.container_box;

  static Color searchbar_placeholder_default(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.searchbar_placeholder_default
          : light.searchbar_placeholder_default;
  static Color searchbar_placeholder_filled(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.searchbar_placeholder_filled
          : light.searchbar_placeholder_filled;

  static List<Color> searchbarGradientColors(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.searchbarGradientColors
          : light.searchbarGradientColors;
  static List<Color> searchbarGradientLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.searchbarGradientLight
          : light.searchbarGradientLight;
  static List<Color> searchbarBorderLine(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.searchbarBorderLine
          : light.searchbarBorderLine;
  static Color Toggle_default(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.Toggle_default
          : light.Toggle_default;
  static Color Toggle_hover(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.Toggle_hover
          : light.Toggle_hover;
  static Color Toggle_disabled(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.Toggle_disabled
          : light.Toggle_disabled;
  static Color semantic_shadow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.semantic_shadow
          : light.semantic_shadow;
  static Color input_field_flag_divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.input_field_flag_divider
          : light.input_field_flag_divider;

  static Color message_background1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.message_background1
          : light.message_background1;
  static Color message_background2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.message_background2
          : light.message_background2;

  static Color footer_background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.footer_background
          : light.footer_background;

  static Color footer_default(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.footer_default
          : light.footer_default;

  static Color footer_selected(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.footer_selected
          : light.footer_selected;
  static Color header_icon_color(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.header_icon_color
          : light.header_icon_color;

  //login stories
  // onboarding colors
  static Color onboardingProgressInactive(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.onboardingProgressInactive
          : light.onboardingProgressInactive;

  static Color onboarding(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.onboarding
          : light.onboarding;

  static Color onboardingSkipButtonBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.onboardingSkipButtonBg
          : light.onboardingSkipButtonBg;

  // login screen colors
  static Color barrierColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.barrierColor
          : light.barrierColor;

  static Color languageDropdownShadow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.languageDropdownShadow
          : light.languageDropdownShadow;

  static Color dropdown(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dropdown
          : light.dropdown;

  static Color dashboardActionButtonBgStart(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardActionButtonBgStart
          : light.dashboardActionButtonBgStart;
  static Color dashboardActionButtonBgEnd(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardActionButtonBgEnd
          : light.dashboardActionButtonBgEnd;
  static Color dashboardActionButtonBorderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardActionButtonBorderColor
          : light.dashboardActionButtonBorderColor;
  static Color dashboardActionButtonShadow1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardActionButtonShadow1
          : light.dashboardActionButtonShadow1;
  static Color dashboardActionButtonShadow2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardActionButtonShadow2
          : light.dashboardActionButtonShadow2;

  static Color dashboardActionButtonIconColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardActionButtonIconColor
          : light.dashboardActionButtonIconColor;

  static Color dashboardActionButtonLabelColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardActionButtonLabelColor
          : light.dashboardActionButtonLabelColor;
  static Color dashboardInfoCardSelectedText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardInfoCardSelectedText
          : light.dashboardInfoCardSelectedText;
  static Color dashboardInfoCardUnselectedText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardInfoCardUnselectedText
          : light.dashboardInfoCardUnselectedText;
  static Color dashboardInfoCardGradientStart(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardInfoCardGradientStart
          : light.dashboardInfoCardGradientStart;
  static Color dashboardInfoCardGradientEnd(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardInfoCardGradientEnd
          : light.dashboardInfoCardGradientEnd;
  static Color dashboardInfoCardBorderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardInfoCardBorderColor
          : light.dashboardInfoCardBorderColor;
  static Color dashboardInfoCardCountSelectedBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardInfoCardCountSelectedBg
          : light.dashboardInfoCardCountSelectedBg;
  static Color dashboardInfoCardCountUnselectedBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardInfoCardCountUnselectedBg
          : light.dashboardInfoCardCountUnselectedBg;
  static Color dashboardInfoCardCountSelectedText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardInfoCardCountSelectedText
          : light.dashboardInfoCardCountSelectedText;
  static Color dashboardInfoCardCountUnselectedText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardInfoCardCountUnselectedText
          : light.dashboardInfoCardCountUnselectedText;

  static Color dashboardAvailableBalanceTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardAvailableBalanceTextColor
          : light.dashboardAvailableBalanceTextColor;

  static Color dashboardBalanceVisibleTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceVisibleTextColor
          : light.dashboardBalanceVisibleTextColor;

  static Color dashboardBalanceHiddenTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceHiddenTextColor
          : light.dashboardBalanceHiddenTextColor;

  static Color dashboardVisibilityIconColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardVisibilityIconColor
          : light.dashboardVisibilityIconColor;

  static Color dashboardSavingsTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardSavingsTextColor
          : light.dashboardSavingsTextColor;

  static Color dashboardSavingsDividerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardSavingsDividerColor
          : light.dashboardSavingsDividerColor;

  static Color dashboardIndicatorBgColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardIndicatorBgColor
          : light.dashboardIndicatorBgColor;

  static Color dashboardIndicatorTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardIndicatorTextColor
          : light.dashboardIndicatorTextColor;

  static Color dashboardIndicatorDotActive(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardIndicatorDotActive
          : light.dashboardIndicatorDotActive;

  static Color dashboardIndicatorDotInactive(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardIndicatorDotInactive
          : light.dashboardIndicatorDotInactive;

  // 📌 Dashboard Balance Trend Chart Colors
  static Color dashboardBalanceTrendTitleTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendTitleTextColor
          : light.dashboardBalanceTrendTitleTextColor;

  static Color dashboardBalanceTrendFilterBgColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendFilterBgColor
          : light.dashboardBalanceTrendFilterBgColor;

  static Color dashboardBalanceTrendFilterTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendFilterTextColor
          : light.dashboardBalanceTrendFilterTextColor;

  static Color dashboardBalanceTrendFilterIconColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendFilterIconColor
          : light.dashboardBalanceTrendFilterIconColor;

  static Color dashboardBalanceTrendTooltipTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendTooltipTextColor
          : light.dashboardBalanceTrendTooltipTextColor;

  static Color dashboardBalanceTrendTooltipLineColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendTooltipLineColor
          : light.dashboardBalanceTrendTooltipLineColor;

  static Color dashboardBalanceTrendYAxisLabelTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendYAxisLabelTextColor
          : light.dashboardBalanceTrendYAxisLabelTextColor;

  static Color dashboardBalanceTrendXAxisLabelTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendXAxisLabelTextColor
          : light.dashboardBalanceTrendXAxisLabelTextColor;

  static Color dashboardBalanceTrendLineColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendLineColor
          : light.dashboardBalanceTrendLineColor;

  static Color dashboardBalanceTrendLineGradientStart(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendLineGradientStart
          : light.dashboardBalanceTrendLineGradientStart;

  static Color dashboardBalanceTrendLineGradientEnd(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendLineGradientEnd
          : light.dashboardBalanceTrendLineGradientEnd;

  static Color dashboardBalanceTrendBelowLineGradientStart(
          BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendBelowLineGradientStart
          : light.dashboardBalanceTrendBelowLineGradientStart;

  static Color dashboardBalanceTrendBelowLineGradientEnd(
          BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendBelowLineGradientEnd
          : light.dashboardBalanceTrendBelowLineGradientEnd;

  static Color dashboardBalanceTrendDotFillColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendDotFillColor
          : light.dashboardBalanceTrendDotFillColor;

  static Color dashboardBalanceTrendDotBorderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.dashboardBalanceTrendDotBorderColor
          : light.dashboardBalanceTrendDotBorderColor;

  static Color donutChartBackgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.donutChartBackgroundColor
          : light.donutChartBackgroundColor;
  static Color donutChartTitleColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.donutChartTitleColor
          : light.donutChartTitleColor;
  static Color donutChartCenterTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.donutChartCenterTextColor
          : light.donutChartCenterTextColor;
  static Color donutChartCenterPercentageColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.donutChartCenterPercentageColor
          : light.donutChartCenterPercentageColor;
  static Color donutChartLegendTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.donutChartLegendTextColor
          : light.donutChartLegendTextColor;
  static Color donutChartAmountTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.donutChartAmountTextColor
          : light.donutChartAmountTextColor;
  static Color donutChartDateTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.donutChartDateTextColor
          : light.donutChartDateTextColor;
  static List<List<Color>> donutChartSectionColors(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.donutChartSectionColors
          : light.donutChartSectionColors;

  // 📌 Upcoming Payments Card Colors
  static Color upcomingPaymentsCardBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.upcomingPaymentsCardBackground
          : light.upcomingPaymentsCardBackground;

  static Color upcomingPaymentsFooterNote(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.upcomingPaymentsFooterNote
          : light.upcomingPaymentsFooterNote;

  static Color upcomingPaymentsGradientStart(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.upcomingPaymentsGradientStart
          : light.upcomingPaymentsGradientStart;

  static Color upcomingPaymentsGradientEnd(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.upcomingPaymentsGradientEnd
          : light.upcomingPaymentsGradientEnd;

  static Color upcomingPaymentsReminderText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.upcomingPaymentsReminderText
          : light.upcomingPaymentsReminderText;

  static Color upcomingPaymentsHeader(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.upcomingPaymentsHeader
          : light.upcomingPaymentsHeader;

  static Color upcomingPaymentsAddPaymentBlue(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.upcomingPaymentsAddPaymentBlue
          : light.upcomingPaymentsAddPaymentBlue;

  static Color upcomingPaymentsDivider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.upcomingPaymentsDivider
          : light.upcomingPaymentsDivider;

  static Color upcomingPaymentsPaymentCount(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.upcomingPaymentsPaymentCount
          : light.upcomingPaymentsPaymentCount;

  //recent transaction
  static Color cardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dark.cardBackground
        : light.cardBackground;
  }

  static Color transactionTagBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? dark.transactionTagBackground
        : light.transactionTagBackground;
  }

  //menu
  static Color menuScrim(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.menuScrimColor
          : light.menuScrimColor;

  static Color menuSheetBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.menuSheetBackgroundColor
          : light.menuSheetBackgroundColor;

  static Color menuSheetTitle(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.menuSheetTitleColor
          : light.menuSheetTitleColor;

  static Color menuSheetIndicatorActive(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.menuSheetIndicatorActiveColor
          : light.menuSheetIndicatorActiveColor;

  static Color menuSheetIndicatorInactive(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.menuSheetIndicatorInactiveColor
          : light.menuSheetIndicatorInactiveColor;

  static Color menuItemCardBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.menuItemCardBackgroundColor
          : light.menuItemCardBackgroundColor;

  static Color menuItemCardContent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.menuItemCardContentColor
          : light.menuItemCardContentColor;

  //favourites
  static Color favouriteHeader(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.favouriteHeader
          : light.favouriteHeader;
  static Color favouriteBoxShadow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.favouriteBoxShadow
          : light.favouriteBoxShadow;
  static Color favouriteText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.favouriteText
          : light.favouriteText;
  static Color favoritesTransactionColor1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.favoritesTransactionColor1
          : light.favoritesTransactionColor1;
  static Color favoritesTransactionColor2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.favoritesTransactionColor2
          : light.favoritesTransactionColor2;
  static Color favoritesTransactionColor3(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.favoritesTransactionColor3
          : light.favoritesTransactionColor3;
  static Color favoritesTransactionColor4(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.favoritesTransactionColor4
          : light.favoritesTransactionColor4;
  static Color favoritesTransactionColor5(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.favoritesTransactionColor5
          : light.favoritesTransactionColor5;
  //profile
  static Color profileFooterBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.profileFooterBg
          : light.profileFooterBg;
  static Color profileFooterShadow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.profileFooterShadow
          : light.profileFooterShadow;
  static Color profileFooterButton(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.profileFooterButton
          : light.profileFooterButton;

  //profile header
  static Color profileHeaderIconBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.profileHeaderIconBg
          : light.profileHeaderIconBg;
  static Color profileHeaderIconGradient1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.profileHeaderIconGradient1
          : light.profileHeaderIconGradient1;
  static Color profileHeaderIconGradient2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.profileHeaderIconGradient2
          : light.profileHeaderIconGradient2;
  static Color profileHeaderIconGradient3(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.profileHeaderIconGradient3
          : light.profileHeaderIconGradient3;
  static Color profileHeaderIconGradient4(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.profileHeaderIconGradient4
          : light.profileHeaderIconGradient4;

  static Color slidebuttonBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? dark.slidebuttonBackground
          : light.slidebuttonBackground;
}

class AppImages {
  static String backgroundImage(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? 'assets/images/dark_theme.png'
          : 'assets/images/White_bg.png';
}
