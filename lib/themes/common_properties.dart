import 'package:Retail_Application/ui/components/apz_button.dart';
import 'package:flutter/material.dart';

// Typography
const double defaultFontSize = 14.0;

// Input Field
const double inputFieldBorderRadius = 8.0;
const EdgeInsets inputFieldContentPadding =
    EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0);

// Base TextStyles (colors will be applied in the component)
const TextStyle inputFieldHintStyle =
    TextStyle(fontWeight: FontWeight.w400, fontSize: 13);
const TextStyle inputFieldLabelStyle =
    TextStyle(fontWeight: FontWeight.w400, fontSize: 12);
const TextStyle countryCodeStyle =
    TextStyle(fontWeight: FontWeight.w400, fontSize: 14);

const double buttonCornerRadius = 16.0;

const Map<ApzButtonSize, EdgeInsets> buttonPaddings = {
  ApzButtonSize.small: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
  ApzButtonSize.large: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
};

const Map<ApzButtonSize, double> buttonHeights = {
  ApzButtonSize.small: 36.0,
  ApzButtonSize.large: 48.0,
};

const Map<ApzButtonSize, double> buttonFontSizes = {
  ApzButtonSize.small: 12.0,
  ApzButtonSize.large: 16.0,
};

const Offset buttonShadowOffset1 = Offset(0, 2);
const double buttonShadowBlurRadius1 = 4;
const double buttonShadowSpreadRadius1 = 0;

const Offset buttonShadowOffset2 = Offset(0, 8);
const double buttonShadowBlurRadius2 = 16;
const double buttonShadowSpreadRadius2 = 0;

const double checkbox_width = 20.0;
const double checkbox_height = 20.0;
const double checkbox_borderRadius = 4.0;
const double checkbox_iconSize = 16.0;
const double checkbox_borderWidth = 1.43;
const double checkbox_containerWidth = 24.5;
const double checkbox_containerHeight = 24;
const double checkbox_spacing = 8.0;
const double checkbox_label_fontSize = 14.0;
const double checkbox_subtitle_fontSize = 13.0;

const double radio_outerRadius = 10;
const double radio_innerRadius = 5;
const double radio_borderWidth = 2;
const double radio_spacing = 8;
const double radio_label_fontSize = 12;
const double radio_option_fontSize = 14;

const double alert_width = 343;
const double alert_borderRadius = 16;
const double alert_headerHeight = 56;
const double alert_headerPaddingHorizontal = 24;
const double alert_headerPaddingVertical = 16;
const double alert_contentPadding = 16;
const double alert_buttonContainerPadding = 16;
const double alert_iconContainerSize = 56;
const double alert_iconSize = 50;
const double alert_iconSpacing = 10;
const double alert_buttonSpacing = 8;
const double alert_borderWidth = 1;
const double alert_iconBorderRadius = 999;
const Offset alert_ShadowOffset = Offset(0, 8);
const double alertShadowBlurRadius = 16;
const double alertShadowSpreadRadius = 0;

const double searchbar_height = 34.0;
const double searchbar_borderRadius = 20.0;
const double searchbar_borderWidth = 1.0;

const EdgeInsets searchbar_padding =
    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);

const double searchbar_iconSize = 18.0; // 18x18
const double searchbar_fontSize = 12.0;

const double toggleSmallWidth = 36;
const double toggleSmallHeight = 20;
const double toggleSmallThumbSize = 16;
const double toggleLargeWidth = 44;
const double toggleLargeHeight = 24;
const double toggleLargeThumbSize = 20;
const double toggleCornerRadius = 12;
const double togglePaddingHorizontal = 2;
const double togglePaddingVertical = 2;
const double toggleBorderWidth = 2;
const double toggleFontSize = 14;

const double toast_width = 343.0;
const double toast_borderRadius = 12.0; // optionally add if you want as well
const EdgeInsets toast_padding =
    EdgeInsets.symmetric(horizontal: 16, vertical: 12);
const double toast_iconSize = 40.0;
const double toast_titleFontSize = 16.0;
const double toast_messageFontSize = 13.0;
const double toast_spacing = 16.0; // spacing between icon and text
const Offset toastShadowOffset = Offset(0, 6);
const double toastShadowBlurRadius = 30;
const double toastShadowSpreadRadius = 0;

const double input_label_fontsize = 14.0;
const double input_error_fontsize = 12.0;

const double segmentedControlHeight = 40.0;
const double segmentedCornerRadius = 12.0;
const double segmentedOptionRadius = 7.0;
const EdgeInsets segmentedPadding = EdgeInsets.all(4.0);
const double segmentedFontSize = 12.0;
const double segmentedShadowBlur = 8;
const double segmentedSpreadRadius = 0;
const Offset segmentedShadowOffset = Offset(0, 3);

const double messagewidth = 270;
const double messageborderradius = 14;
const double messagePaddingTop = 19;
const double messagePaddingBottom = 15;
const double messagePaddingHorizontal = 16;
const double messagefooterheight = 44;
