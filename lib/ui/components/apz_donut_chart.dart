import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/themes/common_properties.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';

class DonutChartSectionDetails {
  final double value;
  final String label;
  final String amount;
  final String date;
  final List<Color> colors;

  DonutChartSectionDetails({
    required this.value,
    required this.label,
    required this.amount,
    required this.date,
    required this.colors,
  });
}

class HalfDonutChart extends StatelessWidget {
  final String title;
  final String centerText;
  final String percentage;
  final List<DonutChartSectionDetails> sections;

  const HalfDonutChart({
    Key? key,
    required this.title,
    required this.centerText,
    required this.percentage,
    required this.sections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalValue = sections.fold(0.0, (sum, item) => sum + item.value);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.donutChartBackgroundColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ApzText(
              label: title,
              color: AppColors.donutChartTitleColor(context),
              fontSize: donutChartTitleFontSize,
              fontWeight: donutChartTitleFontWeight,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 250,
            height: 125,
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0.0, 0.5),
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: 180,
                      sectionsSpace: 2,
                      centerSpaceRadius: 80,
                      sections: [
                        ...sections.map((section) => PieChartSectionData(
                              value: section.value,
                              color: section.colors.first,
                              gradient: LinearGradient(colors: section.colors),
                              showTitle: false,
                              radius: 25,
                            )),
                        PieChartSectionData(
                          value: totalValue,
                          color: Colors.transparent,
                          showTitle: false,
                          radius: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ApzText(
                        label: percentage,
                        color:
                            AppColors.donutChartCenterPercentageColor(context),
                        fontSize: donutChartCenterPercentageFontSize,
                        fontWeight: donutChartCenterPercentageFontWeight,
                      ),
                      const SizedBox(height: 2),
                      ApzText(
                        label: centerText,
                        color: AppColors.donutChartCenterTextColor(context),
                        fontSize: donutChartCenterTextFontSize,
                        fontWeight: donutChartCenterTextFontWeight,
                      ),
                    ],
                  ),
                ),
                if (sections.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ApzText(
                          label: sections.first.amount,
                          color: AppColors.donutChartAmountTextColor(context),
                          fontSize: donutChartAmountFontSize,
                          fontWeight: donutChartAmountFontWeight,
                        ),
                        ApzText(
                          label: sections.first.date,
                          color: AppColors.donutChartDateTextColor(context),
                          fontSize: donutChartDateFontSize,
                          fontWeight: donutChartDateFontWeight,
                        ),
                      ],
                    ),
                  ),
                if (sections.length > 1)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ApzText(
                          label: sections.last.amount,
                          color: AppColors.donutChartAmountTextColor(context),
                          fontSize: donutChartAmountFontSize,
                          fontWeight: donutChartAmountFontWeight,
                        ),
                        ApzText(
                          label: sections.last.date,
                          color: AppColors.donutChartDateTextColor(context),
                          fontSize: donutChartDateFontSize,
                          fontWeight: donutChartDateFontWeight,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: sections
                .map((section) =>
                    _buildLegend(context, section.label, section.colors))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(
      BuildContext context, String text, List<Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: colors,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.48),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ApzText(
            label: text,
            color: AppColors.donutChartLegendTextColor(context),
            fontSize: donutChartLegendFontSize,
            fontWeight: donutChartLegendFontWeight,
          ),
        ],
      ),
    );
  }
}
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:Retail_Application/themes/apz_app_themes.dart';
// import 'package:Retail_Application/themes/common_properties.dart';
// import 'package:Retail_Application/ui/components/apz_text.dart';

// class DonutChartSectionDetails {
//   final double value;
//   final String label;
//   final String amount;
//   final String date;
//   final List<Color> colors;

//   DonutChartSectionDetails({
//     required this.value,
//     required this.label,
//     required this.amount,
//     required this.date,
//     required this.colors,
//   });
// }

// class HalfDonutChart extends StatelessWidget {
//   final String title;
//   final String centerText;
//   final String percentage;
//   final List<DonutChartSectionDetails> sections;

//   const HalfDonutChart({
//     Key? key,
//     required this.title,
//     required this.centerText,
//     required this.percentage,
//     required this.sections,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final totalValue = sections.fold(0.0, (sum, item) => sum + item.value);
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.donutChartBackgroundColor(context),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           ApzText(
//             label: title,
//             color: AppColors.donutChartTitleColor(context),
//             fontSize: donutChartTitleFontSize,
//             fontWeight: donutChartTitleFontWeight,
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: 250,
//             height: 125,
//             child: Stack(
//               children: [
//                 Align(
//                   alignment: const Alignment(0.0, 0.5),
//                   child: PieChart(
//                     PieChartData(
//                       startDegreeOffset: 180,
//                       sectionsSpace: 2,
//                       centerSpaceRadius: 80,
//                       sections: [
//                         ...sections.map((section) => PieChartSectionData(
//                               value: section.value,
//                               color: section.colors.first,
//                               gradient: LinearGradient(colors: section.colors),
//                               showTitle: false,
//                               radius: 25,
//                             )),
//                         PieChartSectionData(
//                           value: totalValue,
//                           color: Colors.transparent,
//                           showTitle: false,
//                           radius: 50,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ApzText(
//                         label: percentage,
//                         color:
//                             AppColors.donutChartCenterPercentageColor(context),
//                         fontSize: donutChartCenterPercentageFontSize,
//                         fontWeight: donutChartCenterPercentageFontWeight,
//                       ),
//                       const SizedBox(height: 2),
//                       ApzText(
//                         label: centerText,
//                         color: AppColors.donutChartCenterTextColor(context),
//                         fontSize: donutChartCenterTextFontSize,
//                         fontWeight: donutChartCenterTextFontWeight,
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (sections.isNotEmpty)
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ApzText(
//                           label: sections.first.amount,
//                           color: AppColors.donutChartAmountTextColor(context),
//                           fontSize: donutChartAmountFontSize,
//                           fontWeight: donutChartAmountFontWeight,
//                         ),
//                         ApzText(
//                           label: sections.first.date,
//                           color: AppColors.donutChartDateTextColor(context),
//                           fontSize: donutChartDateFontSize,
//                           fontWeight: donutChartDateFontWeight,
//                         ),
//                       ],
//                     ),
//                   ),
//                 if (sections.length > 1)
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         ApzText(
//                           label: sections.last.amount,
//                           color: AppColors.donutChartAmountTextColor(context),
//                           fontSize: donutChartAmountFontSize,
//                           fontWeight: donutChartAmountFontWeight,
//                         ),
//                         ApzText(
//                           label: sections.last.date,
//                           color: AppColors.donutChartDateTextColor(context),
//                           fontSize: donutChartDateFontSize,
//                           fontWeight: donutChartDateFontWeight,
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: sections
//                 .map((section) =>
//                     _buildLegend(context, section.label, section.colors))
//                 .toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegend(
//       BuildContext context, String text, List<Color> colors) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Row(
//         children: [
//           Container(
//             width: 12,
//             height: 12,
//             decoration: ShapeDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: colors,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(2.48),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           ApzText(
//             label: text,
//             color: AppColors.donutChartLegendTextColor(context),
//             fontSize: donutChartLegendFontSize,
//             fontWeight: donutChartLegendFontWeight,
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:Retail_Application/themes/apz_app_themes.dart';
// import 'package:Retail_Application/themes/common_properties.dart';
// import 'package:Retail_Application/ui/components/apz_text.dart';

// class DonutChartSectionDetails {
//   final double value;
//   final String label;
//   final String amount;
//   final String date;
//   final List<Color> colors;

//   DonutChartSectionDetails({
//     required this.value,
//     required this.label,
//     required this.amount,
//     required this.date,
//     required this.colors,
//   });
// }

// class HalfDonutChart extends StatelessWidget {
//   final String title;
//   final String centerText;
//   final String percentage;
//   final List<DonutChartSectionDetails> sections;

//   const HalfDonutChart({
//     Key? key,
//     required this.title,
//     required this.centerText,
//     required this.percentage,
//     required this.sections,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final totalValue = sections.fold(0.0, (sum, item) => sum + item.value);
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.donutChartBackgroundColor(context),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.centerLeft,
//             child: ApzText(
//               label: title,
//               color: AppColors.donutChartTitleColor(context),
//               fontSize: donutChartTitleFontSize,
//               fontWeight: donutChartTitleFontWeight,
//             ),
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: 250,
//             height: 125,
//             child: Stack(
//               children: [
//                 Align(
//                   alignment: const Alignment(0.0, 0.5),
//                   child: PieChart(
//                     PieChartData(
//                       startDegreeOffset: 180,
//                       sectionsSpace: 2,
//                       centerSpaceRadius: 80,
//                       sections: [
//                         ...sections.map((section) => PieChartSectionData(
//                               value: section.value,
//                               color: section.colors.first,
//                               gradient: LinearGradient(colors: section.colors),
//                               showTitle: false,
//                               radius: 25,
//                             )),
//                         PieChartSectionData(
//                           value: totalValue,
//                           color: Colors.transparent,
//                           showTitle: false,
//                           radius: 50,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ApzText(
//                         label: percentage,
//                         color:
//                             AppColors.donutChartCenterPercentageColor(context),
//                         fontSize: donutChartCenterPercentageFontSize,
//                         fontWeight: donutChartCenterPercentageFontWeight,
//                       ),
//                       const SizedBox(height: 2),
//                       ApzText(
//                         label: centerText,
//                         color: AppColors.donutChartCenterTextColor(context),
//                         fontSize: donutChartCenterTextFontSize,
//                         fontWeight: donutChartCenterTextFontWeight,
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (sections.isNotEmpty)
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ApzText(
//                           label: sections.first.amount,
//                           color: AppColors.donutChartAmountTextColor(context),
//                           fontSize: donutChartAmountFontSize,
//                           fontWeight: donutChartAmountFontWeight,
//                         ),
//                         ApzText(
//                           label: sections.first.date,
//                           color: AppColors.donutChartDateTextColor(context),
//                           fontSize: donutChartDateFontSize,
//                           fontWeight: donutChartDateFontWeight,
//                         ),
//                       ],
//                     ),
//                   ),
//                 if (sections.length > 1)
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         ApzText(
//                           label: sections.last.amount,
//                           color: AppColors.donutChartAmountTextColor(context),
//                           fontSize: donutChartAmountFontSize,
//                           fontWeight: donutChartAmountFontWeight,
//                         ),
//                         ApzText(
//                           label: sections.last.date,
//                           color: AppColors.donutChartDateTextColor(context),
//                           fontSize: donutChartDateFontSize,
//                           fontWeight: donutChartDateFontWeight,
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: sections
//                 .map((section) =>
//                     _buildLegend(context, section.label, section.colors))
//                 .toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegend(
//       BuildContext context, String text, List<Color> colors) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Row(
//         children: [
//           Container(
//             width: 12,
//             height: 12,
//             decoration: ShapeDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: colors,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(2.48),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           ApzText(
//             label: text,
//             color: AppColors.donutChartLegendTextColor(context),
//             fontSize: donutChartLegendFontSize,
//             fontWeight: donutChartLegendFontWeight,
//           ),
//         ],
//       ),
//     );
//   }
// }